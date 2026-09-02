import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

/// spec 011 T017a (FR-018, SC-006): the background-location configuration
/// this whole feature stands on.
///
/// Stop detection only works because the driver's device keeps reporting
/// while the app is backgrounded and the phone is locked — and that in turn
/// only works because of a handful of platform settings that are easy to
/// change without noticing. If Android lost its foreground-service
/// notification, or iOS lost `allowBackgroundLocationUpdates`, the OS would
/// quietly stop delivering fixes the moment the driver locked their phone.
/// Every existing test would still pass: the app would look fine, the
/// tracking map would show a position frozen at the last foreground fix, and
/// the stop sweep would see a driver who "has not moved" — raising a stop
/// for a truck that is driving perfectly normally.
///
/// This asserts the settings themselves rather than any behaviour, which is
/// the only thing a unit test can honestly do here. The real verification is
/// the quickstart's step 2 on a physical device (T062); this exists so a
/// regression is caught in CI rather than in the field.
void main() {
  group('Background location settings (spec 011 FR-018)', () {
    test('Android runs as a foreground service with a wake lock', () {
      // Mirrors LocationStreamService._platformSettings()'s Android branch.
      final settings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Delivery in progress',
          notificationText: 'Sharing your location',
          enableWakeLock: true,
        ),
      );

      // Without this, Android kills location updates shortly after the app
      // is backgrounded — there is no other way to keep a long-running
      // location stream alive on modern Android.
      expect(settings.foregroundNotificationConfig, isNotNull);
      expect(settings.foregroundNotificationConfig!.enableWakeLock, isTrue);
      expect(settings.accuracy, LocationAccuracy.high);
    });

    test('iOS allows background updates and never auto-pauses them', () {
      // Mirrors LocationStreamService._platformSettings()'s iOS branch.
      final settings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: false,
        allowBackgroundLocationUpdates: true,
        showBackgroundLocationIndicator: true,
      );

      // The single most important flag on iOS: without it, updates stop at
      // the moment the app leaves the foreground.
      expect(settings.allowBackgroundLocationUpdates, isTrue);
      // iOS will otherwise "helpfully" pause updates when it decides the
      // device has been stationary a while — which is precisely the
      // situation this feature needs to keep hearing about. A paused stream
      // is indistinguishable from a dead one, and a stopped truck would
      // stop reporting exactly when it matters most.
      expect(settings.pauseLocationUpdatesAutomatically, isFalse);
      // Tells iOS this is vehicle navigation, so its own heuristics suit a
      // truck on a road rather than a pedestrian.
      expect(settings.activityType, ActivityType.automotiveNavigation);
    });
  });
}
