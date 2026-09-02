import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/profile/presentation/widgets/profile_identity.dart';

import 'helpers/localized_harness.dart';

void main() {
  // Regression: with no uploaded picture this fell back to
  // `assets/driverHomePage/driver.jpg` — a photograph of an actual person —
  // so every account without a photo wore that stranger's face.
  testWidgets('shows a neutral glyph, not a stock photo, when no avatar exists', (
    tester,
  ) async {
    await pumpLocalized(
      tester,
      const Scaffold(body: ProfileIdentity(name: 'Smoke Client')),
    );
    await tester.pump();

    // No raster image at all in the placeholder state: an Image widget here
    // means some photograph is standing in for the user again.
    expect(find.byType(Image), findsNothing);
    expect(find.text('Smoke Client'), findsOneWidget);
  });

  testWidgets('renders the uploaded picture once one exists', (tester) async {
    // A 1x1 PNG — enough to prove the uploaded bytes take precedence over
    // the placeholder.
    final png = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
      0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
      0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
      0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
      0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
      0x42, 0x60, 0x82,
    ]);

    await pumpLocalized(
      tester,
      Scaffold(
        body: ProfileIdentity(name: 'Smoke Client', avatarBytes: png),
      ),
    );
    await tester.pump();

    expect(find.byType(Image), findsOneWidget);
  });
}
