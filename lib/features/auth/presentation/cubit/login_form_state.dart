import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/security/biometric_authenticator.dart';
import '../../domain/entities/country_dial_code.dart';

part 'login_form_state.freezed.dart';

/// Presentation-only state for the login form: what the user has toggled and
/// what the device supports. Credential submission and its outcome live in
/// [AuthState] — nothing here ever touches the network.
@freezed
abstract class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default(CountryDialCode.saudiArabia) CountryDialCode country,
    @Default(true) bool rememberMe,
    @Default(true) bool obscurePassword,
    @Default(BiometricMethod.none) BiometricMethod biometricMethod,

    /// The number restored from a previous "remember me", or `null` when
    /// there is nothing to prefill. The view copies it into its controller
    /// once, on the transition away from `null`.
    String? rememberedNumber,
  }) = _LoginFormState;

  const LoginFormState._();

  bool get supportsBiometrics => biometricMethod != BiometricMethod.none;
}
