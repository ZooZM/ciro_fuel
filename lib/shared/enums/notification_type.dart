/// Mirrors backend notification `type` values relevant to this app
/// (spec FR-022: final price ready, payment lapsed, no eligible driver,
/// delivery completed). Unknown/future types degrade to [unknown] rather
/// than throwing, since notifications are advisory, not lifecycle-critical.
enum NotificationType {
  finalPriceReady('FINAL_PRICE_READY'),
  paymentTimeout('PAYMENT_TIMEOUT'),
  noEligibleDriver('NO_ELIGIBLE_DRIVER'),
  deliveryCompleted('DELIVERY_COMPLETED'),
  unknown('UNKNOWN');

  const NotificationType(this.wire);

  final String wire;

  static NotificationType fromWire(String wire) => switch (wire) {
    'FINAL_PRICE_READY' => NotificationType.finalPriceReady,
    'PAYMENT_TIMEOUT' => NotificationType.paymentTimeout,
    'NO_ELIGIBLE_DRIVER' => NotificationType.noEligibleDriver,
    'DELIVERY_COMPLETED' => NotificationType.deliveryCompleted,
    _ => NotificationType.unknown,
  };

  String toWire() => wire;
}
