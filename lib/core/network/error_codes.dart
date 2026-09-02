/// Mirrors the backend's `ErrorCode` enum
/// (`src/common/enums/error-code.enum.ts`) value-for-value. These are the
/// application-specific codes the uniform error envelope's `error` field
/// carries when a business rule — not just an HTTP status — needs to reach
/// the app (feature 005). Referenced by name everywhere (Constitution
/// Principle I) rather than compared against the raw string.
abstract final class ErrorCodes {
  static const String pricingNotConfigured = 'PRICING_NOT_CONFIGURED';
  static const String quoteStale = 'QUOTE_STALE';
  static const String quoteExpired = 'QUOTE_EXPIRED';
  static const String phoneInUse = 'PHONE_IN_USE';
  static const String smsSendFailed = 'SMS_SEND_FAILED';
  static const String lastStation = 'LAST_STATION';

  // spec 006 (driver auth & session)
  static const String resetCodeInvalid = 'RESET_CODE_INVALID';
  static const String resetRateLimited = 'RESET_RATE_LIMITED';
  static const String sessionRevoked = 'SESSION_REVOKED';

  // spec 007 (driver home & active delivery)
  static const String orderNotDelivered = 'ORDER_NOT_DELIVERED';
  static const String alreadyRated = 'ALREADY_RATED';

  // spec 008 (NFC truck verification & warehouse loading)
  static const String vehicleMismatch = 'VEHICLE_MISMATCH';
  static const String vehicleNotVerified = 'VEHICLE_NOT_VERIFIED';
  static const String truckUnavailable = 'TRUCK_UNAVAILABLE';
  static const String tankUnavailable = 'TANK_UNAVAILABLE';
  static const String tankCapacityExceeded = 'TANK_CAPACITY_EXCEEDED';
  static const String tankGradeUnsupported = 'TANK_GRADE_UNSUPPORTED';
  static const String cardAlreadyPaired = 'CARD_ALREADY_PAIRED';
  static const String tankCodeInUse = 'TANK_CODE_IN_USE';
  static const String duplicatePlate = 'DUPLICATE_PLATE';
  static const String noWarehouseForGrade = 'NO_WAREHOUSE_FOR_GRADE';
  static const String alreadyDeparted = 'ALREADY_DEPARTED';
  // The right truck, read from outside the assigned warehouse's geofence
  // (FR-030a) — a refusal about WHERE the driver is, not about what they
  // presented, and never to be shown with the wrong-truck wording.
  static const String notAtWarehouse = 'NOT_AT_WAREHOUSE';
  // A loading verification reached the platform with no position fix
  // (FR-030c): the device could not say where it was, so the attempt could
  // not be judged and nothing was recorded against the delivery.
  static const String locationRequired = 'LOCATION_REQUIRED';
}
