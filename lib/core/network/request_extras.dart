/// Keys into `RequestOptions.extra`, kept named rather than inline literals
/// (Constitution Principle I).
abstract final class RequestExtraKeys {
  /// Skips Bearer injection and 401-triggered refresh (login, refresh itself).
  static const String skipAuth = 'skipAuth';

  /// Marks a request that has already been replayed once after a refresh,
  /// preventing a retry loop.
  static const String retried = 'retried';

  /// The Bearer token is still attached and a 401 from this specific
  /// request is a legitimate business-rule response (spec 005 T101/T102 —
  /// a wrong/expired phone-verification code), not a stale-session signal.
  /// Unlike [skipAuth], the token injection in `onRequest` is unaffected;
  /// only `onError`'s refresh-and-retry dance is skipped, so the caller
  /// sees the real failure instead of a session-expiry side effect.
  static const String skipAuthRefresh = 'skipAuthRefresh';
}

const String kAuthorizationHeader = 'Authorization';
