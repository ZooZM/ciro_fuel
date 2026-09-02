import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';

part 'phone_verification_state.freezed.dart';

@freezed
sealed class PhoneVerificationState with _$PhoneVerificationState {
  const factory PhoneVerificationState.idle() = PhoneVerificationIdle;

  const factory PhoneVerificationState.sending() = PhoneVerificationSending;

  /// A code was dispatched to [newPhone] — [expiresAt] drives the resend
  /// countdown (verify_phone_screen.dart), not a hardcoded timer.
  const factory PhoneVerificationState.codeSent({
    required String newPhone,
    required DateTime expiresAt,
    required int attemptsRemaining,
  }) = PhoneVerificationCodeSent;

  const factory PhoneVerificationState.confirming() =
      PhoneVerificationConfirming;

  const factory PhoneVerificationState.confirmed() =
      PhoneVerificationConfirmed;

  const factory PhoneVerificationState.failure(Failure failure) =
      PhoneVerificationFailureState;
}
