/// Mirrors backend `OrderStatus` (feature 001, extended by spec 004's
/// `AWAITING_ROUTING`/`ROUTED_TO_TRANSPORT` between `APPROVED` and
/// `ASSIGNED_TO_DRIVER` — see `order-status.enum.ts`): 9 sequential + 2
/// terminal states. The client renders this; it never derives it locally
/// (research R7).
///
/// Spec 005: this enum was missing both spec-004 additions entirely, which
/// meant `fromWire` threw for any client order genuinely in one of those
/// two states — a real crash on the orders list/detail fetch, not a
/// theoretical gap. Fixed here because `cardKindFor` (T039) is exhaustive
/// over this enum and must be exhaustive over the real state space.
enum OrderStatus {
  pendingApproval('PENDING_APPROVAL'),
  approved('APPROVED'),
  awaitingRouting('AWAITING_ROUTING'),
  routedToTransport('ROUTED_TO_TRANSPORT'),
  assignedToDriver('ASSIGNED_TO_DRIVER'),
  pendingPayment('PENDING_PAYMENT'),
  // spec 008 FR-046: the truck is verified and heading to (or at) the fuel
  // warehouse, before any fuel is loaded. Sits between assignedToDriver and
  // inTransit — see order_presentation.dart for every exhaustive switch
  // this member must be added to.
  loading('LOADING'),
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
    'AWAITING_ROUTING' => OrderStatus.awaitingRouting,
    'ROUTED_TO_TRANSPORT' => OrderStatus.routedToTransport,
    'ASSIGNED_TO_DRIVER' => OrderStatus.assignedToDriver,
    'PENDING_PAYMENT' => OrderStatus.pendingPayment,
    'LOADING' => OrderStatus.loading,
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
