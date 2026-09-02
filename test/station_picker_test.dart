import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/widgets/station_picker.dart';
import 'package:mobile_app/features/home/presentation/widgets/current_station_card.dart';
import 'package:mobile_app/features/orders/presentation/widgets/create_order/station_section.dart';
import 'package:mobile_app/shared/models/station_option.dart';

import 'helpers/localized_harness.dart';

/// "Change station" unfolds the picker in place; the list separates active
/// stations from the rest, only the active ones can be favourited, and picking
/// one moves the selection.
void main() {
  Future<void> pumpCard(WidgetTester tester, {Locale? locale}) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            // More than one station, and a selection (spec 005 T124):
            // CurrentStationCard's default is empty now that it's real
            // production data, not the fixed kStationOptions sample.
            child: CurrentStationCard(
              name: 'محطة الرحاب',
              address: 'جدة',
              onChangeStation: () {},
              stations: kStationOptions,
              selectedStationId: 'rehab',
            ),
          ),
        ),
      ),
      locale: locale ?? AppLocales.arabic,
    );
  }

  /// Scoped to the picker: the card's header carries the current station's
  /// name too, so a bare text finder matches twice.
  Finder inPicker(String text) => find.descendant(
    of: find.byType(StationPicker),
    matching: find.text(text),
  );

  /// Taps the "change station" link, whichever locale is rendering it.
  Future<void> toggle(WidgetTester tester) async {
    await tester.tap(
      find.byWidgetPredicate(
        (w) =>
            w is Text &&
            (w.data == 'تغيير المحطة' || w.data == 'Change station'),
      ),
    );
    await tester.pumpAndSettle();
  }

  orderFormTests();

  testWidgets('the picker is folded away until asked for', (tester) async {
    await pumpCard(tester);
    expect(find.byType(StationPicker), findsNothing);

    await toggle(tester);
    expect(find.byType(StationPicker), findsOneWidget);

    await toggle(tester);
    expect(find.byType(StationPicker), findsNothing);
  });

  testWidgets('inactive stations sit under their own divider', (tester) async {
    await pumpCard(tester);
    await toggle(tester);

    expect(find.text('غير نشط'), findsOneWidget);

    final inactive = kStationOptions.firstWhere((s) => !s.isActive);
    final dividerY = tester.getRect(find.text('غير نشط')).center.dy;
    final rowY = tester.getRect(inPicker(inactive.name)).center.dy;
    expect(rowY, greaterThan(dividerY), reason: 'inactive belongs below');

    for (final active in kStationOptions.where((s) => s.isActive)) {
      expect(
        tester.getRect(inPicker(active.name)).center.dy,
        lessThan(dividerY),
        reason: '${active.name} is active and belongs above',
      );
    }
  });

  testWidgets('only active stations offer a favourite control', (tester) async {
    await pumpCard(tester);
    await toggle(tester);

    final activeCount = kStationOptions.where((s) => s.isActive).length;
    expect(find.byIcon(Icons.star_border_rounded), findsNWidgets(activeCount));
  });

  testWidgets('tapping a station moves the selection', (tester) async {
    await pumpCard(tester);
    await toggle(tester);

    // Exactly one row reads as chosen at a time.
    final safa = kStationOptions.firstWhere((s) => s.id == 'safa');
    await tester.tap(inPicker(safa.name));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(StationPicker), findsOneWidget);
  });

  testWidgets('the favourite star fills in grey, not a brand colour', (
    tester,
  ) async {
    await pumpCard(tester);
    await toggle(tester);

    // Scoped to the picker: the card's own header leads with a filled star of
    // its own, marking the station on file.
    Finder filledStars() => find.descendant(
      of: find.byType(StationPicker),
      matching: find.byIcon(Icons.star_rounded),
    );

    expect(filledStars(), findsNothing);
    await tester.tap(find.byIcon(Icons.star_border_rounded).first);
    await tester.pumpAndSettle();

    final filled = tester.widget<Icon>(filledStars());
    expect(filled.color, AppColors.light.textSecondary);
    expect(filled.color, isNot(AppColors.light.brandOrange));
  });

  for (final (name, locale, onLeft) in [
    ('Arabic', AppLocales.arabic, false),
    ('English', AppLocales.english, true),
  ]) {
    testWidgets('the favourite star leads the row under $name', (tester) async {
      await pumpCard(tester, locale: locale);
      await toggle(tester);

      final star = tester.getRect(find.byIcon(Icons.star_border_rounded).first);
      final row = tester.getRect(find.byType(StationPicker));

      expect(
        star.center.dx < row.center.dx,
        onLeft,
        reason: 'the star belongs on the leading edge',
      );
    });
  }
}

void orderFormTests() {
  Future<void> pumpSection(WidgetTester tester) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      const Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            // More than one station (spec 005 T113/FR-036d): with only one
            // (or none), the "change station" link is absent entirely, not
            // just inert — these tests exercise the multi-station case.
            child: StationSection(stations: kStationOptions),
          ),
        ),
      ),
      locale: AppLocales.arabic,
    );
  }

  testWidgets('the order form swaps its favourites row for the picker', (
    tester,
  ) async {
    await pumpSection(tester);
    expect(find.byType(StationPicker), findsNothing);

    await tester.tap(find.text('تغيير المحطة'));
    await tester.pumpAndSettle();

    expect(find.byType(StationPicker), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the order form leaves inactive stations out', (tester) async {
    await pumpSection(tester);
    await tester.tap(find.text('تغيير المحطة'));
    await tester.pumpAndSettle();

    expect(find.text('غير نشط'), findsNothing);
    final inactive = kStationOptions.firstWhere((s) => !s.isActive);
    expect(
      find.descendant(
        of: find.byType(StationPicker),
        matching: find.text(inactive.name),
      ),
      findsNothing,
      reason: 'an order cannot be placed against an inactive station',
    );
  });

  testWidgets(
    'a single-station client is never offered a choice (spec 005 T113/FR-036d)',
    (tester) async {
      await loadTajawal();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await pumpLocalized(
        tester,
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StationSection(stations: [kStationOptions.first]),
          ),
        ),
        locale: AppLocales.arabic,
      );

      expect(find.text('تغيير المحطة'), findsNothing);
    },
  );
}
