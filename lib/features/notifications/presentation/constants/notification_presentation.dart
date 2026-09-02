import 'package:easy_localization/easy_localization.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../shared/enums/notification_type.dart';

/// Turns a backend [NotificationType] into the one line of copy every
/// surface that shows a notification uses — the transient banner
/// (`NotificationBannerPresenter`) and the notifications list screen alike,
/// so the two can never say something different about the same push.
abstract final class NotificationPresentation {
  static String message(NotificationType type) =>
      _messageKey(type).tr();

  static String _messageKey(NotificationType type) => switch (type) {
    NotificationType.orderApprovedFinalPrice =>
      NotificationKeys.bannerOrderApprovedFinalPrice,
    NotificationType.noDriverAvailable =>
      NotificationKeys.bannerNoDriverAvailable,
    NotificationType.paymentTimeout => NotificationKeys.bannerPaymentTimeout,
    // spec 007 FR-002: the one signal a driver needs to see a new
    // assignment appear without a restart.
    NotificationType.orderAssigned => NotificationKeys.bannerOrderAssigned,
    NotificationType.orderStatusChanged =>
      NotificationKeys.bannerOrderStatusChanged,
    NotificationType.otpIssued => NotificationKeys.bannerOtpIssued,
    NotificationType.paymentReconciliationRequired =>
      NotificationKeys.bannerPaymentReconciliationRequired,
    NotificationType.orderRoutedToTransport =>
      NotificationKeys.bannerOrderRoutedToTransport,
    NotificationType.supportRequestRaised =>
      NotificationKeys.bannerSupportRequestRaised,
    // spec 011: still appears in the list like any other notification —
    // the device-level alert (FR-004a) is in addition to this, not instead
    // of it, so a driver who missed the alert still finds it here.
    NotificationType.driverStopDetected =>
      NotificationKeys.bannerDriverStopDetected,
    NotificationType.unknown => NotificationKeys.bannerUnknown,
  };
}
