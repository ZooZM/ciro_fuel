import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/entities/auth_user.dart';

part 'session_state.freezed.dart';

@freezed
sealed class SessionState with _$SessionState {
  /// Not yet determined — app is still checking the persisted session.
  const factory SessionState.unknown() = SessionUnknown;

  const factory SessionState.authenticated(AuthUser user) =
      SessionAuthenticated;

  /// `reason` is a user-facing, non-enumerating message (FR-006/007), or
  /// null for a plain "sign in" landing (e.g. first launch).
  const factory SessionState.unauthenticated({String? reason}) =
      SessionUnauthenticated;
}
