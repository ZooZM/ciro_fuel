/// Mirrors backend `OrderStatus` (feature 001): 7 sequential + 2 terminal
/// states. The client renders this; it never derives it locally (research R7).
enum OrderStatus {
  pendingApproval('PENDING_APPROVAL'),
  approved('APPROVED'),
  assignedToDriver('ASSIGNED_TO_DRIVER'),
  pendingPayment('PENDING_PAYMENT'),
  inTransit('IN_TRANSIT'),
  unloading('UNLOADING'),
  delivered('DELIVERED'),
  rejected('REJECTED'),
  cancelled('CANCELLED');

  const OrderStatus(this.wire);

  final String wire;

  static OrderStatus fromWire(String wire) => switch (wire) {
    'PENDING_APPROVAL' => OrderStatus.pendingApproval,
    'APPROVED' => OrderStatus.approved,
    'ASSIGNED_TO_DRIVER' => OrderStatus.assignedToDriver,
    'PENDING_PAYMENT' => OrderStatus.pendingPayment,
    'IN_TRANSIT' => OrderStatus.inTransit,
    'UNLOADING' => OrderStatus.unloading,
    'DELIVERED' => OrderStatus.delivered,
    'REJECTED' => OrderStatus.rejected,
    'CANCELLED' => OrderStatus.cancelled,
    _ => throw ArgumentError.value(wire, 'wire', 'Unknown OrderStatus'),
  };

  String toWire() => wire;

  bool get isTerminal =>
      this == OrderStatus.delivered ||
      this == OrderStatus.rejected ||
      this == OrderStatus.cancelled;
}
