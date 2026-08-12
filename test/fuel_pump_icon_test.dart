import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/widgets/fuel_pump_icon.dart';

/// The pump artwork is drawn body-left / nozzle-right, which is how it reads
/// under English, and mirrors under Arabic. Two things have to travel with
/// that flip and one must not: the face anchor follows the body to the other
/// side, while the grade stays real, upright text — mirroring the whole widget
/// would print the digits backwards.
void main() {
  const size = 56.0;

  Future<void> pump(WidgetTester tester, TextDirection direction) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: direction,
          child: const Scaffold(
            body: Center(
              child: FuelPumpIcon(
                grade: '95',
                color: Colors.purple,
                size: size,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  double flipOf(WidgetTester tester) {
    final t = tester.widget<Transform>(
      find
          .ancestor(
            of: find.byType(FittedBox).first,
            matching: find.byType(Transform),
          )
          .first,
    );
    return t.transform.getRow(0)[0];
  }

  testWidgets('the artwork keeps its drawn facing under English', (
    tester,
  ) async {
    await pump(tester, TextDirection.ltr);
    expect(flipOf(tester), 1.0, reason: 'LTR is the artwork as drawn');
  });

  testWidgets('the artwork mirrors under Arabic', (tester) async {
    await pump(tester, TextDirection.rtl);
    expect(flipOf(tester), -1.0, reason: 'RTL has to mirror the pump');
  });

  for (final (name, direction, onLeft) in [
    ('English', TextDirection.ltr, true),
    ('Arabic', TextDirection.rtl, false),
  ]) {
    testWidgets('the grade follows the body under $name', (tester) async {
      await pump(tester, direction);

      final grade = tester.getRect(find.text('95'));
      final icon = tester.getRect(find.byType(FuelPumpIcon));

      expect(icon.contains(grade.center), isTrue);
      expect(
        grade.center.dx < icon.center.dx,
        onLeft,
        reason: 'the grade must sit on the pump body, not the nozzle',
      );

      // Upright text either way: the digits are outside the flipped subtree.
      expect(find.text('95'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
