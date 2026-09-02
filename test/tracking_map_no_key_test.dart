import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/core/config/maps_availability.dart';
import 'package:mobile_app/features/orders/presentation/widgets/track_order/tracking_map.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';

import 'helpers/localized_harness.dart';

// Regression: TrackingMap built a GoogleMap unconditionally, and later
// guarded on `--dart-define=GOOGLE_MAPS_API_KEY`. Neither was right — the
// dart-define configures nothing, since the SDKs read their key from
// Info.plist (iOS) and the manifest (Android). A build could therefore pass
// the guard and still abort inside `+[GMSServices checkServicePreconditions]`
// the moment tracking was opened, reaching the developer only as "Lost
// connection to device". The platform is now the source of truth.
//
// There is deliberately no "renders a map when available" case: constructing
// a real GoogleMap needs a platform view the test host cannot provide, and it
// hangs rather than failing — the very coupling that makes withholding the
// widget the only workable defence.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const widget = TrackingMap(
    destination: GeoPoint(lat: 24.7136, lng: 46.6753),
    driverLocation: GeoPoint(lat: 24.7180, lng: 46.6790),
  );

  tearDown(MapsAvailability.reset);

  testWidgets(
    'builds no map when the platform reports no key',
    (tester) async {
      MapsAvailability.debugOverride = false;

      await pumpLocalized(tester, const Scaffold(body: widget));
      await tester.pump();

      // The assertion that matters: constructing a GoogleMap is what kills
      // the process, so none may exist.
      expect(find.byType(GoogleMap), findsNothing);
      expect(
        find.text('track_order.map_unavailable'),
        findsNothing,
        reason: 'the placeholder copy must be translated, not a raw key',
      );
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test(
    'defaults to unavailable when no host answers the channel',
    () async {
      // A test/desktop host, and the shape of any platform that forgets to
      // implement the handler. Guessing "available" is precisely what aborts
      // the process, so the default must be false.
      MapsAvailability.reset();
      expect(await MapsAvailability.isAvailable(), isFalse);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );
}
