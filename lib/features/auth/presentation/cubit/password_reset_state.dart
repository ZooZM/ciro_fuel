import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';

part 'password_reset_state.freezed.dart';

/// Drives `ForgotPasswordScreen` (phone entry → code entry, spec 006 US3)
/// and, separately, `ResetPasswordScreen` (a fresh instance of this same
/// cubit, needing only the `resetToken` carried via route `extra` — see
/// `PhoneVerificationCubit` for the identical one-cubit-per-screen
/// precedent).
@freezed
sealed class PasswordResetState with _$PasswordResetState {
  const factory PasswordResetState.idle() = PasswordResetIdle;

  const factory PasswordResetState.requesting() = PasswordResetRequesting;

  /// Reached after a request — **always**, whether or not the phone
  /// belongs to an account (FR-021): the screen must never be able to
  /// infer existence from which state it lands in.
  const factory PasswordResetState.codeSent({
    required String phone,
    required int expiresInMinutes,
  }) = PasswordResetCodeSent;

  const factory PasswordResetState.verifying() = PasswordResetVerifying;

  /// The code was accepted. [resetToken] is what the screen carries into
  /// `ResetPasswordScreen` via route `extra`.
  const factory PasswordResetState.verified(String resetToken) = PasswordResetVerified;

  const factory PasswordResetState.completing() = PasswordResetCompleting;

  /// The password was changed. The screen returns to login — `complete`
  /// never signs the driver in itself.
  const factory PasswordResetState.completed() = PasswordResetCompleted;

  /// One state for every failure at any step. The screen maps
  /// `RESET_CODE_INVALID` to one generic message regardless of whether it
  /// was wrong, expired, superseded, or attempt-locked-out (FR-024), and
  /// reads `RESET_RATE_LIMITED`'s wait from `Failure.extra`.
  const factory PasswordResetState.failure(Failure failure) = PasswordResetFailureState;
}
