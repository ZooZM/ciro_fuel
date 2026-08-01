import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/enums/converters.dart';
import '../../../../shared/enums/notification_type.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// An in-app notification (`GET /notifications` / WS `notification:new`,
/// FR-022). `orderId` deep-links to the relevant order when present.
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    @NotificationTypeConverter() required NotificationType type,
    String? orderId,
    required DateTime createdAt,
    @Default(false) bool isRead,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, Object?> json) =>
      _$AppNotificationFromJson(json);
}
