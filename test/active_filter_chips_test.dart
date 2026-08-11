import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/widgets/search_filter_bar.dart';
import 'package:mobile_app/shared/models/filter_selection.dart';
import 'package:mobile_app/shared/models/station_option.dart';

import 'helpers/localized_harness.dart';

/// The applied filters are only visible as the chips under the search bar, and
/// a chip must drop its own filter without disturbing the others.
void main() {
  Future<FilterSelection?> pumpBar(
    WidgetTester tester,
    FilterSelection filters,
  ) async {
    FilterSelection? applied;
    await pumpLocalized(
      tester,
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SearchFilterBar(
            filterStations: kStationOptions,
            showDateFilter: true,
            filters: filters,
            onFiltersChanged: (f) => applied = f,
          ),
        ),
      ),
    );
    return applied;
  }

  testWidgets('draws nothing while no filter is applied', (tester) async {
    await pumpBar(tester, const FilterSelection());

    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('one chip per applied filter', (tester) async {
    await pumpBar(
      tester,
      FilterSelection(
        stationIds: const {'safa', 'rehab'},
        date: DateTime(2024, 3, 15),
      ),
    );

    expect(find.text('محطة الصفا'), findsOneWidget);
    expect(find.text('محطة الرحاب'), findsOneWidget);
    // Two stations and a date.
    expect(find.byIcon(Icons.close), findsNWidgets(3));
  });

  testWidgets('a chip drops only its own filter', (tester) async {
    FilterSelection? applied;
    await pumpLocalized(
      tester,
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SearchFilterBar(
            filterStations: kStationOptions,
            showDateFilter: true,
            filters: FilterSelection(
              stationIds: const {'safa', 'rehab'},
              date: DateTime(2024, 3, 15),
            ),
            onFiltersChanged: (f) => applied = f,
          ),
        ),
      ),
    );

    await tester.tap(find.text('محطة الصفا'));
    await tester.pumpAndSettle();

    expect(applied, isNotNull);
    expect(applied!.stationIds, {'rehab'});
    expect(applied!.date, DateTime(2024, 3, 15));
  });
}
