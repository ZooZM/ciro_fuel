import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Which biometric affordance to advertise on screen. The login screen shows
/// a Face ID glyph or a fingerprint glyph accordingly, and hides the control
/// entirely for [BiometricMethod.none].
enum BiometricMethod { none, face, fingerprint }

/// Thin wrapper over `local_auth`.
///
/// Biometrics here gate an *already persisted* session rather than replacing
/// the password: nothing about the credential is stored on device, so a
/// successful scan only unlocks what the Keychain/Keystore already holds
/// (see [TokenStore]). A platform failure is never fatal — it degrades to
/// "unavailable" and the password form remains the path in.
class BiometricAuthenticator {
  BiometricAuthenticator({LocalAuthentication? localAuth})
    : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  Future<BiometricMethod> availableMethod() async {
    try {
      if (!await _localAuth.isDeviceSupported()) return BiometricMethod.none;
      if (!await _localAuth.canCheckBiometrics) return BiometricMethod.none;

      final enrolled = await _localAuth.getAvailableBiometrics();
      if (enrolled.contains(BiometricType.face)) return BiometricMethod.face;
      if (enrolled.contains(BiometricType.fingerprint) ||
          enrolled.contains(BiometricType.strong)) {
        return BiometricMethod.fingerprint;
      }
      return BiometricMethod.none;
    } on PlatformException {
      return BiometricMethod.none;
    } on MissingPluginException {
      // No local_auth implementation on this platform (or under test).
      return BiometricMethod.none;
    }
  }

  /// Returns `true` only on a confirmed match. A cancel, lockout, or missing
  /// enrolment all return `false` — the caller cannot distinguish them, which
  /// keeps failure copy non-enumerating.
  Future<bool> authenticate({required String localizedReason}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
