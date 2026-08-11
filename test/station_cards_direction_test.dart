import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/features/home/presentation/widgets/current_station_card.dart';
import 'package:mobile_app/features/orders/presentation/widgets/create_order/station_section.dart';

import 'helpers/localized_harness.dart';

/// Two cards show a "current station": the dashboard's [CurrentStationCard]
/// and the order form's [StationSection]. Both were laid out Arabic-first with
/// the copy pinned to the card's *outer* edge (`CrossAxisAlignment.end`),
/// which under English pushed it away from its own icon and up against the
/// glyph the row heads with. Both must hug the icon, and the row must mirror
/// as a whole.
///
/// Both head with a chevron by default. The dashboard card swaps it for the
/// favourite star on the stations screen, where there is nowhere left for a
/// chevron to point.
void main() {
  Future<void> pumpCard(WidgetTester tester, Widget card, Locale locale) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16), child: card),
        ),
      ),
      locale: locale,
    );
  }

  Finder stationName(String needle) => find.byWidgetPredicate(
    (w) => w is RichText && w.text.toPlainText().contains(needle),
  );

  /// The chevron the order form heads with, whichever directional arrow the
  /// design settled on: what matters is where it lands, not which glyph it is.
  Finder directionalChevron() => find.byWidgetPredicate(
    (w) => w is Icon && (w.icon?.matchTextDirection ?? false),
  );

  _bothCardsHeadWithBackChevron();

  testWidgets('the dashboard card swaps the chevron for the star on demand', (
    tester,
  ) async {
    await pumpCard(
      tester,
      const CurrentStationCard(
        name: 'Al Rehab Station',
        address: 'Jeddah',
        onChangeStation: _noop,
        headsWithStar: true,
      ),
      AppLocales.english,
    );

    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(
      find.byIcon(Icons.arrow_back_ios),
      findsNothing,
      reason: 'the chevron belongs to the dashboard, not the stations screen',
    );
  });

  final cards = <String, (Widget, Finder Function())>{
    'CurrentStationCard': (
      const CurrentStationCard(
        name: 'Al Rehab Station',
        address: 'Jeddah - Old Makkah Road',
        onChangeStation: _noop,
      ),
      directionalChevron,
    ),
    'StationSection': (
      const StationSection(
        stationName: 'Al Rehab Station',
        stationAddress: 'Jeddah - Old Makkah Road',
      ),
      directionalChevron,
    ),
  };

  cards.forEach((label, entry) {
    final (card, headerGlyph) = entry;

    testWidgets('$label: copy hugs the icon, clear of the glyph (English)', (
      tester,
    ) async {
      await pumpCard(tester, card, AppLocales.english);
      final glyph = tester.getRect(headerGlyph().first);
      final name = tester.getRect(stationName('Al Rehab').first);

      expect(glyph.left, lessThan(name.left), reason: 'LTR leads with it');
      expect(glyph.overlaps(name), isFalse, reason: 'copy hits the glyph');
    });

    testWidgets('$label: the whole row mirrors (Arabic)', (tester) async {
      await pumpCard(tester, card, AppLocales.arabic);
      final glyph = tester.getRect(headerGlyph().first);
      final name = tester.getRect(stationName('Al Rehab').first);

      expect(glyph.right, greaterThan(name.right), reason: 'RTL mirrors it');
      expect(glyph.overlaps(name), isFalse);
    });
  });
}

/// Both cards head with `arrow_back_ios`, not `arrow_forward_ios`. The two are
/// mirror images and both carry `matchTextDirection`, so swapping one for the
/// other flips the glyph in *both* locales — which is the whole point of the
/// choice, and easy to undo by accident.
void _bothCardsHeadWithBackChevron() {
  testWidgets('both station cards head with arrow_back_ios', (tester) async {
    for (final card in const [
      CurrentStationCard(
        name: 'Al Rehab Station',
        address: 'Jeddah',
        onChangeStation: _noop,
      ),
      StationSection(stationName: 'Al Rehab Station', stationAddress: 'Jeddah'),
    ]) {
      await loadTajawal();
      await pumpLocalized(
        tester,
        Scaffold(body: SingleChildScrollView(child: card)),
        locale: AppLocales.arabic,
      );

      final header = tester
          .widgetList<Icon>(
            find.byWidgetPredicate(
              (w) => w is Icon && (w.icon?.matchTextDirection ?? false),
            ),
          )
          .first;
      expect(
        header.icon,
        Icons.arrow_back_ios,
        reason: '${card.runtimeType} header chevron points the wrong way',
      );
    }
  });
}

void _noop() {}
