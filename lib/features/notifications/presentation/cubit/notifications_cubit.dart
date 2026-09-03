import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/tracking_socket.dart';
import '../../../../shared/enums/notification_type.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_all_notifications_read.dart';
import '../../domain/usecases/mark_notification_read.dart';
import 'notifications_state.dart';

/// Backfills via REST on [load] and prepends live `notification:new` pushes
/// as they arrive — the push payload carries no `createdAt` (WS contract),
/// so the client-observed arrival time stands in for a freshly pushed item.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required GetNotifications getNotifications,
    required MarkNotificationRead markNotificationRead,
    required MarkAllNotificationsRead markAllNotificationsRead,
    required TrackingSocket socket,
  }) : _getNotifications = getNotifications,
       _markNotificationRead = markNotificationRead,
       _markAllNotificationsRead = markAllNotificationsRead,
       _socket = socket,
       super(const NotificationsState.loading()) {
    _socket.onNotification(_handleNew);
  }

  final GetNotifications _getNotifications;
  final MarkNotificationRead _markNotificationRead;
  final MarkAllNotificationsRead _markAllNotificationsRead;
  final TrackingSocket _socket;

  Future<void> load() async {
    emit(const NotificationsState.loading());
    final result = await _getNotifications();
    if (isClosed) return;
    result.fold(
      (failure) => emit(NotificationsState.failure(failure)),
      (page) => emit(
        NotificationsState.loaded(
          page.items,
          unreadCount: page.unreadCount,
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  Future<void> refresh() => load();

  Future<void> loadMore() async {
    final current = state;
    if (current is! NotificationsLoaded) return;
    if (current.nextCursor == null) return;
    if (current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true, loadMoreFailed: false));
    final result = await _getNotifications(cursor: current.nextCursor);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(current.copyWith(isLoadingMore: false, loadMoreFailed: true)),
      (page) => emit(
        NotificationsState.loaded(
          [...current.notifications, ...page.items],
          // The whole-set count is re-read on every page too, so a
          // notification that arrived (or was read elsewhere) between
          // pages is still reflected — never held at the first page's
          // stale figure.
          unreadCount: page.unreadCount,
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  /// Drops everything held for the signed-out user. This cubit is an
  /// app-lifetime singleton (registered eagerly so it can receive
  /// `notification:new` from launch), so without this its state would survive
  /// a sign-out and the next account to sign in on the same device would see
  /// the previous one's notifications until its own [load] resolved.
  /// Back to `loading`, not an empty `loaded`: nothing has been fetched for
  /// whoever comes next, and "no notifications yet" is a different claim.
  void clear() => emit(const NotificationsState.loading());

  Future<void> markRead(String id) async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    final target = current.notifications.where((n) => n.id == id).firstOrNull;
    if (target == null || target.isRead) return;

    final result = await _markNotificationRead(id);
    result.fold((_) {}, (_) {
      final updated = [
        for (final n in current.notifications)
          if (n.id == id) n.copyWith(isRead: true) else n,
      ];
      emit(
        current.copyWith(
          notifications: updated,
          unreadCount: current.unreadCount > 0 ? current.unreadCount - 1 : 0,
        ),
      );
    });
  }

  /// feature 013 US3 (FR-025/FR-026): marks every notification read in one
  /// request, then folds the result into the loaded state so the list and
  /// the badge cannot disagree. A press with nothing unread is a no-op that
  /// shows no error.
  Future<void> markAllRead() async {
    final current = state;
    if (current is! NotificationsLoaded) return;
    if (current.unreadCount == 0) return;

    final result = await _markAllNotificationsRead();
    if (isClosed) return;
    result.fold((_) {}, (_) {
      emit(
        current.copyWith(
          notifications: [
            for (final n in current.notifications) n.copyWith(isRead: true),
          ],
          unreadCount: 0,
        ),
      );
    });
  }

  void _handleNew(Map<String, dynamic> payload) {
    final notification = AppNotification(
      id: payload['id'] as String,
      type: NotificationType.fromWire(payload['type'] as String),
      orderId: payload['orderId'] as String?,
      createdAt: DateTime.now(),
    );

    final current = state;
    final existing = current is NotificationsLoaded
        ? current.notifications
        : const <AppNotification>[];
    final unreadCount = current is NotificationsLoaded
        ? current.unreadCount + 1
        : 1;
    emit(
      NotificationsState.loaded(
        [notification, ...existing],
        unreadCount: unreadCount,
        nextCursor: current is NotificationsLoaded ? current.nextCursor : null,
      ),
    );
  }
}
