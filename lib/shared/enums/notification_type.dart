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
  // feature 013 US5a: addressed to a transport-company admin, not a
  // mobile persona — mirrored here only to keep the parity guard
  // exhaustive against the backend enum.
  orderDriverBlocked('ORDER_DRIVER_BLOCKED'),
  // feature 013: the fuel company has decided a station owner's credit-limit
  // request. This one DOES reach a mobile persona — it is notified to
  // `resolved.clientId` — so its absence here was not cosmetic: a real
  // client's own notification degraded to [unknown] in their own list.
  creditLimitRequestResolved('CREDIT_LIMIT_REQUEST_RESOLVED'),
  // feature 016: the broadcast fuel exchange. All four are addressed to a
  // FUEL_COMPANY_ADMIN, a role with no mobile persona at all — mirrored for
  // the same reason as [orderDriverBlocked].
  exchangeOfferAvailable('EXCHANGE_OFFER_AVAILABLE'),
  exchangeProposalReceived('EXCHANGE_PROPOSAL_RECEIVED'),
  exchangeOfferAwarded('EXCHANGE_OFFER_AWARDED'),
  exchangeOfferClosed('EXCHANGE_OFFER_CLOSED'),
  // feature 017: the platform operator's announcement fan-out, addressed to
  // administrators only.
  platformAnnouncement('PLATFORM_ANNOUNCEMENT'),
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
    'ORDER_DRIVER_BLOCKED' => NotificationType.orderDriverBlocked,
    'CREDIT_LIMIT_REQUEST_RESOLVED' =>
      NotificationType.creditLimitRequestResolved,
    'EXCHANGE_OFFER_AVAILABLE' => NotificationType.exchangeOfferAvailable,
    'EXCHANGE_PROPOSAL_RECEIVED' => NotificationType.exchangeProposalReceived,
    'EXCHANGE_OFFER_AWARDED' => NotificationType.exchangeOfferAwarded,
    'EXCHANGE_OFFER_CLOSED' => NotificationType.exchangeOfferClosed,
    'PLATFORM_ANNOUNCEMENT' => NotificationType.platformAnnouncement,
    _ => NotificationType.unknown,
  };

  String toWire() => wire;
}
