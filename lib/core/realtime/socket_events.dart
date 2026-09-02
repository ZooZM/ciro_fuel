/// `/tracking` namespace event names and ack-reason strings, verbatim from
/// contracts/backend-integration.md — the only place these literals appear
/// (Principle I).
abstract final class SocketEvents {
  // Client → Server
  static const String orderWatch = 'order:watch';
  static const String orderUnwatch = 'order:unwatch';
  static const String locationUpdate = 'location:update';

  // Server → Client
  static const String orderLocation = 'order:location';
  static const String orderStatus = 'order:status';
  static const String orderOtp = 'order:otp';
  static const String notificationNew = 'notification:new';
  static const String sessionRevoked = 'session:revoked';

  // Connection
  static const String connect = 'connect';
  static const String connectError = 'connect_error';
}

abstract final class SocketAckReasons {
  static const String notFound = 'NOT_FOUND';
  static const String forbiddenRole = 'FORBIDDEN_ROLE';
  static const String notTrackable = 'NOT_TRACKABLE';
  static const String belowThreshold = 'BELOW_THRESHOLD';
  static const String noActiveOrder = 'NO_ACTIVE_ORDER';
  static const String unauthorized = 'UNAUTHORIZED';
}
