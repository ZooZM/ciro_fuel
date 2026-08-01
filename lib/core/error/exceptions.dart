/// Thrown by data sources on a non-2xx response; caught only by
/// [ErrorInterceptor]/repositories and converted to a [Failure]. Never
/// exposed to Cubits or the UI directly (Principle III).
class ServerException implements Exception {
  const ServerException(this.statusCode, this.message);

  final int statusCode;
  final String message;
}

/// Thrown when the device has no usable connectivity or a request times out.
class NoConnectionException implements Exception {
  const NoConnectionException();
}
