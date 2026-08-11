import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/widgets/filter_sheet.dart';
import 'package:mobile_app/shared/enums/fuel_grade.dart';
import 'package:mobile_app/shared/models/filter_selection.dart';
import 'package:mobile_app/shared/models/station_option.dart';

import 'helpers/localized_harness.dart';

/// Every section of the sheet is opt-in, because the three list screens do not
/// filter by the same things. These pin that down, plus the count on the apply
/// button and what the sheet hands back.
void main() {
  final activeStations = [
    for (final s in kStationOptions)
      if (s.isActive) s,
  ];

  Future<void> pumpSheet(
    WidgetTester tester, {
    List<SortOption> sortOptions = const [SortOption.newestFirst],
    List<StationOption> stations = const [],
    bool showFuelType = false,
    bool showDate = false,
    FilterSelection initial = const FilterSelection(),
  }) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      Scaffold(
        body: FilterSheet(
          sortOptions: sortOptions,
          stations: stations,
          showFuelType: showFuelType,
          showDate: showDate,
          initial: initial,
        ),
      ),
      locale: AppLocales.arabic,
    );
  }

  testWidgets('a screen that passes nothing gets only the sort row', (
    tester,
  ) async {
    await pumpSheet(tester);
    expect(find.text('المحطة'), findsNothing);
    expect(find.text('نوع الوقود'), findsNothing);
    expect(find.text('التاريخ'), findsNothing);
    expect(find.text('الترتيب حسب'), findsOneWidget);
  });

  testWidgets('sections appear only when asked for', (tester) async {
    await pumpSheet(
      tester,
      stations: activeStations,
      showFuelType: true,
      showDate: true,
    );
    expect(find.text('المحطة'), findsOneWidget);
    expect(find.text('نوع الوقود'), findsOneWidget);
    expect(find.text('التاريخ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the apply button counts every set filter', (tester) async {
    await pumpSheet(
      tester,
      stations: activeStations,
      showFuelType: true,
      initial: FilterSelection(
        sort: SortOption.newestFirst,
        stationIds: const {'rehab', 'safa'},
        grade: FuelGrade.gasoline98,
      ),
    );
    // sort + two stations + a grade
    expect(find.text('تطبيق ( 4 )'), findsOneWidget);
  });

  testWidgets('reset clears the count', (tester) async {
    await pumpSheet(
      tester,
      stations: activeStations,
      initial: const FilterSelection(
        sort: SortOption.newestFirst,
        stationIds: {'rehab'},
      ),
    );
    expect(find.text('تطبيق ( 2 )'), findsOneWidget);

    await tester.tap(find.text('إعادة تعيين'));
    await tester.pumpAndSettle();
    expect(find.text('تطبيق ( 0 )'), findsOneWidget);
  });

  testWidgets('tapping the chosen sort again clears it', (tester) async {
    await pumpSheet(
      tester,
      sortOptions: const [SortOption.newestFirst, SortOption.oldestFirst],
      initial: const FilterSelection(sort: SortOption.newestFirst),
    );
    expect(find.text('تطبيق ( 1 )'), findsOneWidget);

    await tester.tap(find.text('الأحدث أولاً'));
    await tester.pumpAndSettle();
    expect(find.text('تطبيق ( 0 )'), findsOneWidget);
  });

  testWidgets('the sheet never takes more than half the screen', (
    tester,
  ) async {
    await pumpSheet(
      tester,
      stations: activeStations,
      showFuelType: true,
      showDate: true,
    );

    final screen =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final sheet = tester.getRect(find.byType(FilterSheet));
    expect(
      sheet.height,
      lessThanOrEqualTo(screen / 2 + 0.5),
      reason: 'the sheet grew past half the screen',
    );
  });

  testWidgets('applying hands the selection back', (tester) async {
    FilterSelection? returned;

    await loadTajawal();
    await pumpLocalized(
      tester,
      Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              returned = await FilterSheet.show(
                context,
                sortOptions: const [SortOption.newestFirst],
                stations: activeStations,
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
      locale: AppLocales.arabic,
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('الأحدث أولاً'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تطبيق ( 1 )'));
    await tester.pumpAndSettle();

    expect(returned, isNotNull);
    expect(returned!.sort, SortOption.newestFirst);
  });
}
