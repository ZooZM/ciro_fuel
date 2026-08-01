/// Keys into `RequestOptions.extra`, kept named rather than inline literals
/// (Constitution Principle I).
abstract final class RequestExtraKeys {
  /// Skips Bearer injection and 401-triggered refresh (login, refresh itself).
  static const String skipAuth = 'skipAuth';

  /// Marks a request that has already been replayed once after a refresh,
  /// preventing a retry loop.
  static const String retried = 'retried';
}

const String kAuthorizationHeader = 'Authorization';
