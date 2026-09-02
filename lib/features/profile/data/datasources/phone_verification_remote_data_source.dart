import 'package:dio/dio.dart';

import '../../../../core/network/request_extras.dart';
import '../../domain/entities/phone_verification_request.dart';

/// `POST /users/me/phone/verification` + `.../confirm` (spec 005 T101,
/// contracts/rest-api-delta.md §7).
abstract interface class PhoneVerificationRemoteDataSource {
  Future<PhoneVerificationRequest> requestVerification(String newPhone);

  Future<void> confirmVerification(String code);
}

class PhoneVerificationRemoteDataSourceImpl
    implements PhoneVerificationRemoteDataSource {
  PhoneVerificationRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<PhoneVerificationRequest> requestVerification(
    String newPhone,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/users/me/phone/verification',
      data: {'newPhone': newPhone},
    );
    final data = response.data!;
    return PhoneVerificationRequest(
      expiresAt: DateTime.parse(data['expiresAt'] as String),
      attemptsRemaining: data['attemptsRemaining'] as int,
    );
  }

  @override
  Future<void> confirmVerification(String code) async {
    // A wrong/expired code is a legitimate 401 from this specific endpoint
    // (FR-035, never distinguishing which) — not a stale-session signal.
    // Without this flag, AuthInterceptor would treat it as one, silently
    // burn a token refresh, retry with the same still-wrong code, and only
    // then hand back a session-expired-shaped failure instead of "wrong
    // code" (spec 005 CLAUDE.md FR-043: verify 401 doesn't trigger refresh
    // here rather than assuming it).
    await _dio.post<Map<String, dynamic>>(
      '/users/me/phone/verification/confirm',
      data: {'code': code},
      options: Options(extra: {RequestExtraKeys.skipAuthRefresh: true}),
    );
  }
}
