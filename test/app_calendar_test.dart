import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_calendar.dart';

import 'helpers/localized_harness.dart';

/// The grid is built from the month's own first weekday, so an off-by-one in
/// the leading blanks would silently shift every date in the month.
void main() {
  Future<void> pumpCalendar(
    WidgetTester tester, {
    DateTime? month,
    DateTime? selected,
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<DateTime>? onSelect,
    Locale? locale,
  }) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1080, 1800);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      Scaffold(
        body: Center(
          child: AppCalendar(
            initialMonth: month ?? DateTime(2020, 6),
            selected: selected,
            firstDate: firstDate,
            lastDate: lastDate,
            onSelect: onSelect ?? (_) {},
          ),
        ),
      ),
      locale: locale ?? AppLocales.english,
      theme: AppTheme.lightTheme,
    );
  }

  /// The column a day sits in, 0-based from the reading-direction start.
  int columnOf(WidgetTester tester, String day) {
    final grid = tester.getRect(find.byType(AppCalendar));
    final cell = tester.getRect(find.text(day));
    final fromStart =
        Directionality.of(tester.element(find.byType(AppCalendar))) ==
            TextDirection.rtl
        ? grid.right - cell.center.dx
        : cell.center.dx - grid.left;
    return ((fromStart / (grid.width / 7)) - 0.5).round().clamp(0, 6);
  }

  testWidgets('the month starts on its real weekday', (tester) async {
    // 1 June 2020 was a Monday: one blank under Sunday, so the 1st is column 1.
    await pumpCalendar(tester);
    expect(columnOf(tester, '1'), 1);
    expect(columnOf(tester, '7'), 0, reason: '7 June 2020 was a Sunday');
    expect(find.text('30'), findsOneWidget);
    expect(find.text('31'), findsNothing, reason: 'June has 30 days');
  });

  testWidgets('a month starting on Sunday has no leading blank', (
    tester,
  ) async {
    // 1 November 2020 was a Sunday.
    await pumpCalendar(tester, month: DateTime(2020, 11));
    expect(columnOf(tester, '1'), 0);
  });

  testWidgets('February in a leap year runs to 29', (tester) async {
    await pumpCalendar(tester, month: DateTime(2024, 2));
    expect(find.text('29'), findsOneWidget);
    expect(find.text('30'), findsNothing);
  });

  testWidgets('stepping the month moves to the next one', (tester) async {
    await pumpCalendar(tester);
    expect(find.text('June 2020'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(find.text('July 2020'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text('May 2020'), findsOneWidget);
  });

  testWidgets('a day outside the bounds cannot be picked', (tester) async {
    DateTime? picked;
    await pumpCalendar(
      tester,
      firstDate: DateTime(2020, 6, 10),
      onSelect: (d) => picked = d,
    );

    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();
    expect(picked, isNull, reason: '3 June is before firstDate');

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();
    expect(picked, DateTime(2020, 6, 15));
  });

  testWidgets('the grid mirrors under Arabic', (tester) async {
    await pumpCalendar(tester, locale: AppLocales.arabic);
    // Same columns as English — the whole row is mirrored, not reordered.
    expect(columnOf(tester, '1'), 1);
    expect(columnOf(tester, '7'), 0);
  });
}
