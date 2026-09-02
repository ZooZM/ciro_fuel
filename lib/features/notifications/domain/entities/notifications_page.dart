import 'app_notification.dart';

/// One page of `GET /notifications` (spec 005 T087) — `unreadCount` is the
/// caller's whole unread set, not scoped to this page, so it always agrees
/// with what the badge everywhere else in the app shows (FR-030/FR-031).
class NotificationsPage {
  const NotificationsPage({
    required this.items,
    required this.nextCursor,
    required this.unreadCount,
  });

  final List<AppNotification> items;
  final String? nextCursor;
  final int unreadCount;
}
