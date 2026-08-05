import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/entities/auth_user.dart';
import '../../../../shared/enums/user_role.dart';
import '../../domain/usecases/sign_in.dart';
import 'auth_state.dart';
import 'session_cubit.dart';

/// TODO: Remove this dev bypass once the backend is available.
/// While true, any non-empty credentials sign in as a local CLIENT user so
/// the UI can be walked through without a server. Flip to false to restore
/// the real `/auth/login` call.
const bool kDevLoginBypass = true;

const AuthUser _kDevUser = AuthUser(
  id: 'dev-user-001',
  role: UserRole.client,
  companyId: 'dev-company-001',
  fullName: 'مستخدم تجريبي',
);

/// Drives the login form. On success, authenticates [SessionCubit] — the
/// app-wide identity — which is what the router actually reacts to.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required SignIn signIn,
    required SessionCubit sessionCubit,
    bool devBypass = kDevLoginBypass,
  }) : _signIn = signIn,
       _sessionCubit = sessionCubit,
       _devBypass = devBypass,
       super(const AuthState.idle());

  final SignIn _signIn;
  final SessionCubit _sessionCubit;

  /// Overridable so tests can exercise the real `/auth/login` path regardless
  /// of the [kDevLoginBypass] default.
  final bool _devBypass;

  Future<void> submit({required String email, required String password}) async {
    emit(const AuthState.submitting());

    if (_devBypass) {
      _sessionCubit.authenticate(_kDevUser);
      emit(const AuthState.success());
      return;
    }

    final result = await _signIn(email: email, password: password);
    result.fold((failure) => emit(AuthState.failure(failure)), (user) {
      _sessionCubit.authenticate(user);
      emit(const AuthState.success());
    });
  }
}
