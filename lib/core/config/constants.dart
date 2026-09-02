/// Named, backend-contract-derived values. No magic numbers elsewhere
/// (Constitution Principle I) — every literal that carries meaning lives here.
abstract final class AppDurations {
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Socket.io base reconnection delay (research R6).
  static const Duration socketReconnectDelay = Duration(seconds: 1);

  /// Driver heartbeat interval — emit even without displacement past this (WS contract).
  static const Duration locationHeartbeat = Duration(minutes: 3);

  /// Local abuse-ceiling mirroring the server's 1 accepted update / 5 s (WS contract).
  static const Duration locationEmitFloor = Duration(seconds: 5);

  /// A watched order's location is considered stale once no update has
  /// landed within this window (FR-021).
  static const Duration locationStaleWindow = Duration(minutes: 4);

  /// How often a watcher re-evaluates staleness against the wall clock,
  /// independent of whether a new location update has arrived (FR-021).
  static const Duration staleCheckInterval = Duration(seconds: 15);

  /// OTP verification throttle window (backend: 5 attempts / 15 min).
  static const Duration otpThrottleWindow = Duration(minutes: 15);

  /// While awaiting payment confirmation, the client polls `GET /orders/:id`
  /// at this interval. Required because `order:watch` only succeeds once an
  /// order is already IN_TRANSIT/UNLOADING (WS contract NOT_TRACKABLE) — the
  /// room-scoped `order:status` push cannot be relied on for the
  /// `pendingPayment -> inTransit` transition the client is waiting for.
  static const Duration paymentConfirmationPollInterval = Duration(seconds: 5);

  /// Mandatory driver app-lock (spec 006 FR-012): once the app has been
  /// backgrounded past this, the next foreground re-requires the unlock
  /// challenge before any driver screen is shown. Also engaged on every
  /// cold launch into an existing session, regardless of this threshold.
  static const Duration appLockThreshold = Duration(minutes: 2);
}

abstract final class AppDistances {
  /// Driver location is emitted once displacement exceeds this since the
  /// last accepted point (WS contract, FR-015).
  static const double locationDisplacementMeters = 50;
}

abstract final class AppLimits {
  /// Backend: 5 verify attempts per 15-minute throttle window.
  static const int otpMaxAttempts = 5;
}
