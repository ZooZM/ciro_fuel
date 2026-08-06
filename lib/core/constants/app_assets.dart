/// The single place asset paths are spelled out (Constitution Principle I).
///
/// Several folders shipped from design contain spaces (`assets/sign in/`,
/// `assets/social media/`) and one filename has a trailing space before its
/// extension. Those quirks are contained here rather than being repeated —
/// and mistyped — across the widget tree.
abstract final class AppAssets {
  static const String _signIn = 'assets/sign in';
  static const String _logo = 'assets/logo';
  static const String _icons = 'assets/icons';
  static const String _biometric = 'assets/biometric';
  static const String _social = 'assets/social media';

  // Sign-in scene
  static const String loginBackground = '$_signIn/background .jpg';
  static const String loginWave = '$_signIn/Wave.svg';

  // Brand
  static const String logo = '$_logo/Logo.svg';

  // UI icons
  static const String phoneIcon = '$_icons/phone.svg';
  static const String lockIcon = '$_icons/locked.svg';
  static const String shieldIcon = '$_icons/protection.svg';
  static const String supportIcon = '$_icons/customer service.svg';

  // Biometrics
  static const String faceIdIcon = '$_biometric/Face ID.svg';
  static const String fingerprintIcon = '$_biometric/Android Fingerprint.svg';

  // Federated identity providers
  static const String appleIcon = '$_social/apple.svg';
  static const String googleIcon = '$_social/google.svg';

  /// Root passed to `EasyLocalization(path: ...)`.
  static const String translationsPath = 'assets/translations';
}
