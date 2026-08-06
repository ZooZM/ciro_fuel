import 'dart:async';

import 'package:dio/dio.dart';

import 'request_extras.dart';
import 'token_store.dart';

/// Injects the Bearer access token on every authenticated request and
/// transparently renews it once on a 401 (FR-003/004/005, SC-002).
///
/// Uses [QueuedInterceptor] so `onError` calls for concurrently in-flight
/// requests run one at a time. That serialization is what makes the
/// "stale token" check below sufficient on its own: by the time a second
/// failed request's `onError` runs, a refresh triggered by the first has
/// already landed in [TokenStore] (or not), so this interceptor only ever
/// calls `/auth/refresh` once per genuine expiry event — never once per
/// failed request. The [Completer]-based guard in [_refreshOnce] is a
/// defensive backstop for the (currently theoretical) case of two `onError`
/// calls genuinely overlapping. [_sessionExpiredNotified] covers the
/// symmetric case on the failure path, where a cleared [TokenStore] would
/// otherwise defeat the stale-token check for a second queued request.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenStore tokenStore,
    required Dio refreshDio,
    required Future<void> Function() onSessionExpired,
    Future<void> Function()? onTokenRefreshed,
  }) : _tokenStore = tokenStore,
       _refreshDio = refreshDio,
       _onSessionExpired = onSessionExpired,
       _onTokenRefreshed = onTokenRefreshed;

  final TokenStore _tokenStore;
  final Dio _refreshDio;
  final Future<void> Function() _onSessionExpired;

  /// Fired after a *successful* silent refresh — e.g. so the `/tracking`
  /// socket can re-authenticate its handshake with the new token (FR-020,
  /// research R6: the handshake's auth context is fixed at connect time).
  final Future<void> Function()? _onTokenRefreshed;

  Completer<String?>? _refreshInFlight;

  /// Guards against notifying [_onSessionExpired] once per *failed request*
  /// instead of once per *expiry event*: when a refresh fails, [TokenStore]
  /// is cleared, so a second queued request's "stale token" check (which
  /// compares against the current stored token) can no longer detect that
  /// the first request already handled this expiry — it would otherwise
  /// attempt its own doomed refresh and notify again. Reset once a token is
  /// available again (fresh login), so a later, genuine expiry still fires.
  bool _sessionExpiredNotified = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[RequestExtraKeys.skipAuth] != true) {
      final token = await _tokenStore.accessToken;
      if (token != null) {
        options.headers[kAuthorizationHeader] = 'Bearer $token';
        if (_refreshInFlight == null) {
          _sessionExpiredNotified = false;
        }
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried =
        requestOptions.extra[RequestExtraKeys.retried] == true;
    final skipAuth = requestOptions.extra[RequestExtraKeys.skipAuth] == true;

    if (!isUnauthorized || alreadyRetried || skipAuth) {
      return handler.next(err);
    }

    final failedToken = _bearerToken(requestOptions);
    final currentToken = await _tokenStore.accessToken;

    final freshToken = (currentToken != null && currentToken != failedToken)
        ? currentToken
        : await _refreshOnce();

    if (freshToken == null) {
      if (!_sessionExpiredNotified) {
        _sessionExpiredNotified = true;
        await _onSessionExpired();
      }
      return handler.next(err);
    }

    final retryOptions = requestOptions
      ..headers[kAuthorizationHeader] = 'Bearer $freshToken'
      ..extra[RequestExtraKeys.retried] = true;

    try {
      handler.resolve(await _refreshDio.fetch<dynamic>(retryOptions));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  String? _bearerToken(RequestOptions options) {
    final header = options.headers[kAuthorizationHeader] as String?;
    if (header == null) return null;
    return header.replaceFirst('Bearer ', '');
  }

  Future<String?> _refreshOnce() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight.future;

    final completer = Completer<String?>();
    _refreshInFlight = completer;
    unawaited(_performRefresh(completer));
    return completer.future;
  }

  Future<void> _performRefresh(Completer<String?> completer) async {
    try {
      final refreshToken = await _tokenStore.refreshToken;
      if (refreshToken == null) {
        completer.complete(null);
        return;
      }

      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {RequestExtraKeys.skipAuth: true}),
      );

      final data = response.data;
      final accessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;
      if (accessToken == null || newRefreshToken == null) {
        completer.complete(null);
        return;
      }

      await _tokenStore.save(access: accessToken, refresh: newRefreshToken);
      completer.complete(accessToken);
      await _onTokenRefreshed?.call();
    } catch (_) {
      await _tokenStore.clear();
      completer.complete(null);
    } finally {
      _refreshInFlight = null;
    }
  }
}
