import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/enums/converters.dart';
import '../../../../shared/enums/otp_purpose.dart';

part 'otp_challenge.freezed.dart';
part 'otp_challenge.g.dart';

/// A plaintext arrival/delivery OTP, populated only on the CLIENT side from
/// the `order:otp` push or `GET /orders/:id/otp/current` (FR-012). This
/// type is never constructed on the DRIVER build (SC-008) — the delivery
/// feature works with plain OTP-entry strings, never this entity.
@freezed
abstract class OtpChallenge with _$OtpChallenge {
  const OtpChallenge._();

  const factory OtpChallenge({
    required String orderId,
    @OtpPurposeConverter() required OtpPurpose purpose,
    required String code,
    required DateTime expiresAt,
  }) = _OtpChallenge;

  factory OtpChallenge.fromJson(Map<String, Object?> json) =>
      _$OtpChallengeFromJson(json);

  /// Overrides freezed's default toString — which would otherwise print
  /// [code] in full — so this entity can never leak the OTP into logs,
  /// crash reports, or `bloc_test`/Bloc-observer state diffs (SC-008).
  @override
  String toString() =>
      'OtpChallenge(orderId: $orderId, purpose: $purpose, code: [REDACTED], expiresAt: $expiresAt)';
}
