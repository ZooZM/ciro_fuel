/// The order-detail screen's states, used for static UI preview until the
/// screen is wired to a real cubit/API.
enum MockOrderState {
  pendingReview,
  confirmed,
  waitingPayment,

  /// Payment pushed to the next order — the receipt shows, but in the
  /// deferred rather than the settled treatment.
  deferred,
  paid,
  inTransit,
  delivered,
}
