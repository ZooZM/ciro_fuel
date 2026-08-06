import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.idle() = AuthIdle;
  const factory AuthState.submitting() = AuthSubmitting;
  const factory AuthState.success() = AuthLoginSuccess;

  /// Carries the raw [Failure]; the login screen maps it to a
  /// non-enumerating message (FR-007) via [authFailureMessageKey].
  const factory AuthState.failure(Failure failure) = AuthLoginFailure;

  /// A locally-originated problem that never reached the API — a declined
  /// biometric scan, or a biometric attempt with no session on this device.
  /// [messageKey] is a translation key from `ErrorKeys`.
  const factory AuthState.error(String messageKey) = AuthLoginError;
}
