import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/security/biometric_authenticator.dart';
import '../../data/datasources/login_preferences_store.dart';
import '../../domain/entities/country_dial_code.dart';
import 'login_form_state.dart';

/// Owns the login screen's view state so the widget itself stays stateless
/// apart from its text controllers — no `setState`, and every toggle is
/// independently testable.
class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit({
    required BiometricAuthenticator biometrics,
    required LoginPreferencesStore preferences,
  }) : _biometrics = biometrics,
       _preferences = preferences,
       super(const LoginFormState());

  final BiometricAuthenticator _biometrics;
  final LoginPreferencesStore _preferences;

  /// Resolves what the device and the last session allow. Both lookups are
  /// best-effort: a failure just leaves the form in its default shape.
  Future<void> initialize() async {
    final remembered = await _preferences.read();
    final method = await _biometrics.availableMethod();
    if (isClosed) return;

    // `rememberMe` is deliberately left at its default (on, as drawn in the
    // frame) rather than inferred from whether a number was found — a first
    // launch has nothing stored yet, which says nothing about intent.
    emit(
      state.copyWith(
        biometricMethod: method,
        country: remembered?.country ?? state.country,
        rememberedNumber: remembered?.nationalNumber,
      ),
    );
  }

  void selectCountry(CountryDialCode country) =>
      emit(state.copyWith(country: country));

  void toggleRememberMe() =>
      emit(state.copyWith(rememberMe: !state.rememberMe));

  void togglePasswordVisibility() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
}
