import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/delivery_time_card.dart';

import 'helpers/localized_harness.dart';

/// The station artwork is pinned to the card's trailing edge. The copy has to
/// stop short of it — the English address is long enough to have run straight
/// underneath, which the shorter Arabic one never revealed.
void main() {
  Future<void> pumpCard(WidgetTester tester, Locale locale) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: DeliveryTimeCard(),
        ),
      ),
      locale: locale,
      theme: AppTheme.darkTheme,
    );
  }

  for (final (name, locale, needle) in [
    ('Arabic', AppLocales.arabic, 'محطة'),
    ('English', AppLocales.english, 'Station'),
  ]) {
    testWidgets('copy clears the artwork under $name', (tester) async {
      await pumpCard(tester, locale);
      expect(tester.takeException(), isNull);

      // By key, not by type: the date and time lines carry SVG glyphs of
      // their own, so only the forecourt is the thing the copy must clear.
      final art = find.byKey(DeliveryTimeCard.artworkKey);
      expect(art, findsOneWidget);
      final artBox = tester.getRect(art);

      final line = find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains(needle),
      );
      expect(line, findsWidgets, reason: 'station line missing under $name');

      for (final element in line.evaluate()) {
        final textBox = tester.getRect(find.byWidget(element.widget));
        expect(
          textBox.overlaps(artBox.deflate(1)),
          isFalse,
          reason:
              'copy $textBox runs under the artwork $artBox under $name',
        );
      }
    });
  }

  testWidgets('the heading stays centred on the card', (tester) async {
    await pumpCard(tester, AppLocales.english);
    final card = tester.getRect(find.byType(DeliveryTimeCard));
    final heading = find.byWidgetPredicate(
      (w) => w is RichText && w.text.toPlainText() == 'Delivery time',
    );
    expect(heading, findsOneWidget);
    expect(
      tester.getCenter(heading).dx,
      closeTo(card.center.dx, 1.0),
      reason: 'the reserve must not shift the heading off centre',
    );
  });
}
