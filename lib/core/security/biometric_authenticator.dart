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

  /// Whether the device can satisfy *any* unlock challenge at all —
  /// biometric or device passcode/PIN/pattern (spec 006 FR-013a).
  ///
  /// Deliberately distinct from [availableMethod]: that method answers
  /// "which icon to show" and collapses to [BiometricMethod.none] the
  /// moment nothing is *enrolled*, even on a device with a passcode set —
  /// which is exactly the case [allowDeviceCredential] in [authenticate]
  /// exists to still let through. `isDeviceSupported()` is `local_auth`'s
  /// own device-capability check (biometric hardware OR a settable device
  /// credential), independent of enrolment, so it is this method — not
  /// [availableMethod] — that the mandatory lock's `unavailable` state
  /// (FR-013a) must gate on. A device that fails this check has no
  /// enrolled biometric AND no passcode: there is nothing for
  /// `allowDeviceCredential: true` to fall back to either.
  Future<bool> isDeviceLockAvailable() async {
    try {
      return await _localAuth.isDeviceSupported();
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  /// Returns `true` only on a confirmed match. A cancel, lockout, or missing
  /// enrolment all return `false` — the caller cannot distinguish them, which
  /// keeps failure copy non-enumerating.
  ///
  /// [allowDeviceCredential] defaults to `false`: unlocking a *stored*
  /// session (login's biometric sign-in) with a device passcode is a
  /// weaker proposition than unlocking a session already *running*, and
  /// that call was made deliberately. The mandatory app lock (spec 006
  /// FR-013) passes `true` — a failed or absent biometric must never
  /// strand a driver mid-delivery, and the device passcode is still
  /// device-level, still not driver-disableable.
  Future<bool> authenticate({
    required String localizedReason,
    bool allowDeviceCredential = false,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          biometricOnly: !allowDeviceCredential,
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
