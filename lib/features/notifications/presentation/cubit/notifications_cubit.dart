import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/tracking_socket.dart';
import '../../../../shared/enums/notification_type.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_read.dart';
import 'notifications_state.dart';

/// Backfills via REST on [load] and prepends live `notification:new` pushes
/// as they arrive — the push payload carries no `createdAt` (WS contract),
/// so the client-observed arrival time stands in for a freshly pushed item.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required GetNotifications getNotifications,
    required MarkNotificationRead markNotificationRead,
    required TrackingSocket socket,
  }) : _getNotifications = getNotifications,
       _markNotificationRead = markNotificationRead,
       _socket = socket,
       super(const NotificationsState.loading()) {
    _socket.onNotification(_handleNew);
  }

  final GetNotifications _getNotifications;
  final MarkNotificationRead _markNotificationRead;
  final TrackingSocket _socket;

  Future<void> load() async {
    emit(const NotificationsState.loading());
    final result = await _getNotifications();
    result.fold(
      (failure) => emit(NotificationsState.failure(failure)),
      (notifications) => emit(NotificationsState.loaded(notifications)),
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

    final result = await _markNotificationRead(id);
    result.fold((_) {}, (_) {
      final updated = [
        for (final n in current.notifications)
          if (n.id == id) n.copyWith(isRead: true) else n,
      ];
      emit(NotificationsState.loaded(updated));
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
    emit(NotificationsState.loaded([notification, ...existing]));
  }
}
