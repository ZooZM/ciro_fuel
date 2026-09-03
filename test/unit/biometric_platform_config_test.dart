import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// spec 006 (FR-013, FR-013a): the platform configuration the mandatory app
/// lock and the login screen's biometric sign-in stand on.
///
/// [BiometricAuthenticator] catches `PlatformException` and
/// `MissingPluginException` and degrades to "unavailable", which makes almost
/// every biometric failure invisible in Dart — but the two settings below are
/// exactly the ones that failure path cannot cover:
///
/// * **iOS** *terminates the process* on the first Face ID `evaluatePolicy`
///   call when `NSFaceIDUsageDescription` is absent. It is a native abort, not
///   a catchable exception, so the try/catch never runs — the app simply
///   disappears the moment the driver presses the Face ID control. This was a
///   real, shipped crash on the login screen.
/// * **Android** shows the system BiometricPrompt through the AndroidX
///   fragment manager, so `MainActivity` must be a `FragmentActivity`. Under a
///   plain `FlutterActivity` every `authenticate()` call fails with
///   `no_fragment_activity`, which *is* caught — so the lock and the biometric
///   sign-in silently never work, with no crash and no error to follow.
///
/// Both are one-line edits in files no Dart test would otherwise read, and
/// both fail in ways no widget test can see. Asserting the settings themselves
/// is the only thing a unit test can honestly do here; the real verification
/// is a physical device. This exists so a regression is caught in CI rather
/// than by a driver at a depot.
void main() {
  group('Biometric platform configuration (spec 006 FR-013)', () {
    test('iOS declares NSFaceIDUsageDescription', () {
      final plist = File('ios/Runner/Info.plist');
      expect(plist.existsSync(), isTrue, reason: 'ios/Runner/Info.plist is missing');

      final src = plist.readAsStringSync();
      expect(
        src,
        contains('<key>NSFaceIDUsageDescription</key>'),
        reason:
            'Without NSFaceIDUsageDescription, iOS terminates the process the '
            'first time Face ID is evaluated — the login screen crashes when '
            'the driver presses the Face ID control, and no Dart catch block '
            'can intercept it.',
      );

      // A present-but-empty string is the same crash: iOS requires a purpose
      // string, not merely the key.
      final purpose = RegExp(
        r'<key>NSFaceIDUsageDescription</key>\s*<string>(.*?)</string>',
        dotAll: true,
      ).firstMatch(src);
      expect(purpose, isNotNull, reason: 'NSFaceIDUsageDescription has no <string> value');
      expect(
        purpose!.group(1)!.trim(),
        isNotEmpty,
        reason: 'NSFaceIDUsageDescription must carry a non-empty purpose string',
      );
    });

    test('Android hosts local_auth on a FragmentActivity', () {
      final activity = File(
        'android/app/src/main/kotlin/com/ciro/fuel/mobile_app/MainActivity.kt',
      );
      expect(activity.existsSync(), isTrue, reason: 'MainActivity.kt is missing');

      final src = activity.readAsStringSync();
      expect(
        src,
        contains('class MainActivity : FlutterFragmentActivity()'),
        reason:
            'local_auth puts up the system BiometricPrompt through the AndroidX '
            'fragment manager. Under a plain FlutterActivity every authenticate() '
            'call fails with no_fragment_activity — which BiometricAuthenticator '
            'catches, so the app lock and biometric sign-in fail silently.',
      );
      expect(
        src,
        contains('io.flutter.embedding.android.FlutterFragmentActivity'),
        reason: 'FlutterFragmentActivity must actually be imported',
      );
    });

    test('Android manifest declares USE_BIOMETRIC', () {
      final manifest = File('android/app/src/main/AndroidManifest.xml');
      expect(manifest.existsSync(), isTrue, reason: 'AndroidManifest.xml is missing');

      expect(
        manifest.readAsStringSync(),
        contains('android.permission.USE_BIOMETRIC'),
        reason:
            'Declared explicitly rather than relying on the androidx.biometric '
            'manifest merge, so the requirement is visible beside the host '
            'activity it depends on.',
      );
    });
  });
}
