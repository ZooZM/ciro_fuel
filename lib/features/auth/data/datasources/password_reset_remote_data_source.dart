import 'package:dio/dio.dart';

import '../../../../core/network/request_extras.dart';

/// `POST /auth/password-reset/{request,verify,complete}` (spec 006 US3).
/// All three calls set `skipAuth`: recovery runs with no session, so
/// there is no Bearer token to attach and a 401 here would never be a
/// stale-session signal worth triggering `AuthInterceptor`'s refresh
/// dance over.
abstract interface class PasswordResetRemoteDataSource {
  /// [phone] is an E.164 identifier. The response is deliberately the
  /// same shape whether or not the number belongs to an account (FR-021)
  /// — this method has no way to tell, by design.
  Future<PasswordResetRequestResult> requestReset(String phone);

  /// Returns the opaque, single-use token `complete` needs.
  Future<String> verifyCode({required String phone, required String code});

  Future<void> complete({required String resetToken, required String newPassword});
}

class PasswordResetRequestResult {
  const PasswordResetRequestResult({
    required this.expiresInMinutes,
    required this.attemptsAllowed,
  });

  final int expiresInMinutes;
  final int attemptsAllowed;
}

class PasswordResetRemoteDataSourceImpl implements PasswordResetRemoteDataSource {
  PasswordResetRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<PasswordResetRequestResult> requestReset(String phone) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/password-reset/request',
      data: {'phone': phone},
      options: Options(extra: {RequestExtraKeys.skipAuth: true}),
    );
    final data = response.data!;
    return PasswordResetRequestResult(
      expiresInMinutes: data['expiresInMinutes'] as int,
      attemptsAllowed: data['attemptsAllowed'] as int,
    );
  }

  @override
  Future<String> verifyCode({required String phone, required String code}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/password-reset/verify',
      data: {'phone': phone, 'code': code},
      options: Options(extra: {RequestExtraKeys.skipAuth: true}),
    );
    return response.data!['resetToken'] as String;
  }

  @override
  Future<void> complete({
    required String resetToken,
    required String newPassword,
  }) async {
    await _dio.post<void>(
      '/auth/password-reset/complete',
      data: {'resetToken': resetToken, 'newPassword': newPassword},
      options: Options(extra: {RequestExtraKeys.skipAuth: true}),
    );
  }
}
