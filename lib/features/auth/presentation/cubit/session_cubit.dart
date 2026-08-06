import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/entities/auth_user.dart';
import 'session_state.dart';

/// Drives which experience the app shows (login vs CLIENT vs DRIVER home)
/// and is the single source [AppRouter] redirects from. Session I/O
/// (reading [TokenStore], calling `/auth/me`) happens during DI setup, not
/// inside this Cubit — it only holds the resulting state.
class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(const SessionState.unknown());

  void authenticate(AuthUser user) => emit(SessionState.authenticated(user));

  /// Idempotent: calling this while already unauthenticated does not
  /// re-emit, guaranteeing the router redirect fires once per real
  /// expiry event (FR-006).
  void signOut({String? reason}) {
    if (state is! SessionUnauthenticated) {
      emit(SessionState.unauthenticated(reason: reason));
    }
  }
}
