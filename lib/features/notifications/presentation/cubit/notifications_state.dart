import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/app_notification.dart';

part 'notifications_state.freezed.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.loading() = NotificationsLoading;

  /// [unreadCount] is the caller's whole unread set (FR-031), read by every
  /// `AppTopBar` badge in the app — not just [notifications]' current page.
  const factory NotificationsState.loaded(
    List<AppNotification> notifications, {
    required int unreadCount,
    String? nextCursor,
    @Default(false) bool isLoadingMore,
    @Default(false) bool loadMoreFailed,
  }) = NotificationsLoaded;

  const factory NotificationsState.failure(Failure failure) =
      NotificationsFailureState;
}

/// The badge count everywhere else in the app reads (spec 005 T089) — 0
/// while still loading or on failure, since neither is "no notifications"
/// but there is nothing truthful to show yet either.
extension NotificationsStateBadge on NotificationsState {
  int get unreadBadgeCount => switch (this) {
    NotificationsLoaded(:final unreadCount) => unreadCount,
    _ => 0,
  };
}
