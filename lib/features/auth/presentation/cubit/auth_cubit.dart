import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/security/biometric_authenticator.dart';
import '../../data/datasources/login_preferences_store.dart';
import '../../domain/entities/country_dial_code.dart';
import '../../domain/usecases/restore_session.dart';
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
    required RestoreSession restoreSession,
    required BiometricAuthenticator biometrics,
    required LoginPreferencesStore preferences,
    required SessionCubit sessionCubit,
  }) : _signIn = signIn,
       _restoreSession = restoreSession,
       _biometrics = biometrics,
       _preferences = preferences,
       _sessionCubit = sessionCubit,
       super(const AuthState.idle());

  final SignIn _signIn;
  final RestoreSession _restoreSession;
  final BiometricAuthenticator _biometrics;
  final LoginPreferencesStore _preferences;
  final SessionCubit _sessionCubit;

  /// [nationalNumber] is raw user input; [country] turns it into the E.164
  /// identifier the API expects, so no call site has to know the format.
  Future<void> submit({
    required CountryDialCode country,
    required String nationalNumber,
    required String password,
    required bool rememberMe,
  }) async {
    emit(const AuthState.submitting());

    final result = await _signIn(
      phone: country.toE164(nationalNumber),
      password: password,
    );

    await result.fold((failure) async => emit(AuthState.failure(failure)), (
      user,
    ) async {
      // Persisted only after the credentials are known good, so a typo
      // never becomes the prefilled number on the next launch.
      await (rememberMe
          ? _preferences.save(
              country: country,
              nationalNumber: CountryDialCode.normalizeNationalNumber(
                nationalNumber,
              ),
            )
          : _preferences.clear());
      _sessionCubit.authenticate(user);
      emit(const AuthState.success());
    });
  }

  /// Unlocks the session already persisted on this device. Requires no
  /// password because none is stored: the scan simply authorises reuse of
  /// the tokens in the Keychain/Keystore, and the server still validates
  /// them via `/auth/me`.
  Future<void> signInWithBiometrics({required String localizedReason}) async {
    final approved = await _biometrics.authenticate(
      localizedReason: localizedReason,
    );
    if (!approved) {
      emit(const AuthState.error(ErrorKeys.biometricFailed));
      return;
    }

    emit(const AuthState.submitting());
    final result = await _restoreSession();
    result.fold(
      // No stored session (or it has since been revoked) — the password
      // form is the only way forward, so say that rather than "wrong scan".
      (_) => emit(const AuthState.error(ErrorKeys.biometricUnavailable)),
      (user) {
        _sessionCubit.authenticate(user);
        emit(const AuthState.success());
      },
    );
  }
}
