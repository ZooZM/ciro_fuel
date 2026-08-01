import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_in.dart';
import 'auth_state.dart';
import 'session_cubit.dart';

/// Drives the login form. On success, authenticates [SessionCubit] — the
/// app-wide identity — which is what the router actually reacts to.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required SignIn signIn, required SessionCubit sessionCubit})
    : _signIn = signIn,
      _sessionCubit = sessionCubit,
      super(const AuthState.idle());

  final SignIn _signIn;
  final SessionCubit _sessionCubit;

  Future<void> submit({required String email, required String password}) async {
    emit(const AuthState.submitting());
    final result = await _signIn(email: email, password: password);
    result.fold((failure) => emit(AuthState.failure(failure)), (user) {
      _sessionCubit.authenticate(user);
      emit(const AuthState.success());
    });
  }
}
