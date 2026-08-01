import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.idle() = AuthIdle;
  const factory AuthState.submitting() = AuthSubmitting;
  const factory AuthState.success() = AuthLoginSuccess;

  /// Carries the raw [Failure]; the login screen maps it to a
  /// non-enumerating message (FR-007) via [authFailureMessage].
  const factory AuthState.failure(Failure failure) = AuthLoginFailure;
}
