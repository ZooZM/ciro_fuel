import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/complete_password_reset.dart';
import '../../domain/usecases/request_password_reset.dart';
import '../../domain/usecases/verify_reset_code.dart';
import 'password_reset_state.dart';

/// One instance per screen visit (mirrors `PhoneVerificationCubit`) — a
/// fresh instance for `ForgotPasswordScreen` (phone entry + code entry +
/// resend) and another for `ResetPasswordScreen` (new password), which
/// needs nothing from the first beyond the `resetToken` already carried
/// via route `extra`.
class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit({
    required RequestPasswordReset requestReset,
    required VerifyResetCode verifyCode,
    required CompletePasswordReset completeReset,
  }) : _requestReset = requestReset,
       _verifyCode = verifyCode,
       _completeReset = completeReset,
       super(const PasswordResetState.idle());

  final RequestPasswordReset _requestReset;
  final VerifyResetCode _verifyCode;
  final CompletePasswordReset _completeReset;

  /// Also used for resend — requesting again is the same action, and the
  /// response is identical either way (FR-021).
  Future<void> requestReset(String phone) async {
    emit(const PasswordResetState.requesting());
    final result = await _requestReset(phone);
    result.fold(
      (failure) => emit(PasswordResetState.failure(failure)),
      (data) => emit(
        PasswordResetState.codeSent(phone: phone, expiresInMinutes: data.expiresInMinutes),
      ),
    );
  }

  Future<void> verifyCode({required String phone, required String code}) async {
    emit(const PasswordResetState.verifying());
    final result = await _verifyCode(phone: phone, code: code);
    result.fold(
      (failure) => emit(PasswordResetState.failure(failure)),
      (resetToken) => emit(PasswordResetState.verified(resetToken)),
    );
  }

  Future<void> completeReset({
    required String resetToken,
    required String newPassword,
  }) async {
    emit(const PasswordResetState.completing());
    final result = await _completeReset(resetToken: resetToken, newPassword: newPassword);
    result.fold(
      (failure) => emit(PasswordResetState.failure(failure)),
      (_) => emit(const PasswordResetState.completed()),
    );
  }

  /// Back to phone entry — "change number" on the code-entry step.
  void restart() => emit(const PasswordResetState.idle());
}
