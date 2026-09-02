/// Mirrors backend `NotificationType`
/// (`src/common/enums/notification-type.enum.ts`) value-for-value.
///
/// spec 007 research R10 (`mobile_app/CLAUDE.md` debt #5): before this
/// correction, this enum and the backend's shared **exactly one** value
/// (`PAYMENT_TIMEOUT`) — `finalPriceReady`, `noEligibleDriver` and
/// `deliveryCompleted` were all misspelled or invented wire strings that
/// never once matched a real payload, so every live notification degraded
/// to [unknown]. `ORDER_ASSIGNED` — the one signal that already reaches a
/// driver's user room on dispatch — was absent entirely, so the app could
/// never branch on the one notification this feature needs (FR-002).
/// Unknown/future types still degrade to [unknown] rather than throwing,
/// since notifications are advisory, not lifecycle-critical.
enum NotificationType {
  orderApprovedFinalPrice('ORDER_APPROVED_FINAL_PRICE'),
  noDriverAvailable('NO_DRIVER_AVAILABLE'),
  paymentTimeout('PAYMENT_TIMEOUT'),
  orderAssigned('ORDER_ASSIGNED'),
  orderStatusChanged('ORDER_STATUS_CHANGED'),
  otpIssued('OTP_ISSUED'),
  paymentReconciliationRequired('PAYMENT_RECONCILIATION_REQUIRED'),
  orderRoutedToTransport('ORDER_ROUTED_TO_TRANSPORT'),
  supportRequestRaised('SUPPORT_REQUEST_RAISED'),
  // spec 011 FR-004a: the one type this app raises a DEVICE-LEVEL alert
  // for. Every other type is content for the in-app list, which a driver
  // mid-drive never looks at — which is the whole reason this one differs.
  driverStopDetected('DRIVER_STOP_DETECTED'),
  unknown('UNKNOWN');

  const NotificationType(this.wire);

  final String wire;

  static NotificationType fromWire(String wire) => switch (wire) {
    'ORDER_APPROVED_FINAL_PRICE' => NotificationType.orderApprovedFinalPrice,
    'NO_DRIVER_AVAILABLE' => NotificationType.noDriverAvailable,
    'PAYMENT_TIMEOUT' => NotificationType.paymentTimeout,
    'ORDER_ASSIGNED' => NotificationType.orderAssigned,
    'ORDER_STATUS_CHANGED' => NotificationType.orderStatusChanged,
    'OTP_ISSUED' => NotificationType.otpIssued,
    'PAYMENT_RECONCILIATION_REQUIRED' =>
      NotificationType.paymentReconciliationRequired,
    'ORDER_ROUTED_TO_TRANSPORT' => NotificationType.orderRoutedToTransport,
    'SUPPORT_REQUEST_RAISED' => NotificationType.supportRequestRaised,
    'DRIVER_STOP_DETECTED' => NotificationType.driverStopDetected,
    _ => NotificationType.unknown,
  };

  String toWire() => wire;
}
