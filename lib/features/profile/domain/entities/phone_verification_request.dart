import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification_request.freezed.dart';

/// `POST /users/me/phone/verification`'s 202 body (spec 005 T101) — what's
/// left after the code itself, which never appears in any response
/// (FR-035g).
@freezed
abstract class PhoneVerificationRequest with _$PhoneVerificationRequest {
  const factory PhoneVerificationRequest({
    required DateTime expiresAt,
    required int attemptsRemaining,
  }) = _PhoneVerificationRequest;
}
