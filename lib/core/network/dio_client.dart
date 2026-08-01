import 'package:dio/dio.dart';

import '../config/constants.dart';
import '../config/env.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'token_store.dart';

BaseOptions _baseOptions() => BaseOptions(
  baseUrl: Env.apiBaseUrl,
  connectTimeout: AppDurations.connectTimeout,
  receiveTimeout: AppDurations.receiveTimeout,
  contentType: Headers.jsonContentType,
);

/// Builds the app's primary [Dio] client. A second, interceptor-free `Dio`
/// is used internally to call `/auth/refresh` and to replay retried
/// requests, so the refresh call itself can never re-enter [AuthInterceptor]
/// and recurse (research R5).
Dio buildDioClient({
  required TokenStore tokenStore,
  required Future<void> Function() onSessionExpired,
  Future<void> Function()? onTokenRefreshed,
}) {
  final refreshDio = Dio(_baseOptions());

  final dio = Dio(_baseOptions())
    ..interceptors.addAll([
      AuthInterceptor(
        tokenStore: tokenStore,
        refreshDio: refreshDio,
        onSessionExpired: onSessionExpired,
        onTokenRefreshed: onTokenRefreshed,
      ),
      ErrorInterceptor(),
    ]);

  return dio;
}
