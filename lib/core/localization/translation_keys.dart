/// Typed handles for every key in `assets/translations/*.json`.
///
/// Widgets call `LoginKeys.submit.tr()` instead of `'login.submit'.tr()`, so
/// a renamed or deleted key fails at compile time rather than silently
/// rendering the raw key string at runtime.
abstract final class CommonKeys {
  static const String languageName = 'common.language_name';
  static const String cancel = 'common.cancel';
}

abstract final class LoginKeys {
  static const String welcomeTitle = 'login.welcome_title';
  static const String welcomeSubtitle = 'login.welcome_subtitle';

  static const String phoneLabel = 'login.phone_label';
  static const String phoneHint = 'login.phone_hint';
  static const String phoneRequired = 'login.phone_required';
  static const String phoneInvalid = 'login.phone_invalid';

  static const String passwordHint = 'login.password_hint';
  static const String passwordRequired = 'login.password_required';
  static const String showPassword = 'login.show_password';
  static const String hidePassword = 'login.hide_password';

  static const String rememberMe = 'login.remember_me';
  static const String forgotPassword = 'login.forgot_password';
  static const String submit = 'login.submit';

  static const String alternativesDivider = 'login.alternatives_divider';
  static const String faceId = 'login.face_id';
  static const String fingerprint = 'login.fingerprint';
  static const String biometricReason = 'login.biometric_reason';

  static const String continueWithApple = 'login.continue_with_apple';
  static const String continueWithGoogle = 'login.continue_with_google';
  static const String comingSoon = 'login.coming_soon';

  static const String support = 'login.support';
  static const String securityNote = 'login.security_note';
}

abstract final class ForgotPasswordKeys {
  static const String title = 'forgot_password.title';
  static const String body = 'forgot_password.body';
}

/// User-facing failure copy. Deliberately non-enumerating: none of these
/// reveal whether an account exists or which credential was wrong (FR-007).
abstract final class ErrorKeys {
  static const String invalidCredentials = 'errors.invalid_credentials';
  static const String throttled = 'errors.throttled';
  static const String network = 'errors.network';
  static const String generic = 'errors.generic';
  static const String biometricUnavailable = 'errors.biometric_unavailable';
  static const String biometricFailed = 'errors.biometric_failed';
}
