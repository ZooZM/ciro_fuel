import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/orders/presentation/view/orders_list_screen.dart';

import 'helpers/localized_harness.dart';
import 'support/orders_test_di.dart';

/// The status pills used to sit in two rows of equal-width `Expanded` cells
/// with a `FittedBox` inside each, so every label was scaled by a different
/// amount and no two pills read at the same size. They size to their own copy
/// now, in a fixed four-then-three split: a `Wrap` reflowed them by width,
/// which put five on the first row under English and stranded two on the
/// second.
void main() {
  // OrdersListScreen resolves OrdersCubit from getIt now (spec 005).
  setUp(registerOrdersTestDi);
  tearDown(resetOrdersTestDi);

  Finder pillLabels() => find.descendant(
    of: find.byKey(OrdersListScreen.pillsKey),
    matching: find.byType(Text),
  );

  Future<void> pumpOrders(WidgetTester tester, Locale locale) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      const OrdersListScreen(),
      locale: locale,
      theme: AppTheme.lightTheme,
    );
  }

  for (final (name, locale) in [
    ('Arabic', AppLocales.arabic),
    ('English', AppLocales.english),
  ]) {
    testWidgets('every status pill reads at one type size under $name', (
      tester,
    ) async {
      await pumpOrders(tester, locale);
      expect(tester.takeException(), isNull);

      final labels = tester.widgetList<Text>(pillLabels());
      expect(labels, hasLength(7));

      final sizes = labels.map((t) => t.style?.fontSize).toSet();
      expect(sizes, hasLength(1), reason: 'pills disagree on type size');

      expect(
        find.descendant(
          of: find.byKey(OrdersListScreen.pillsKey),
          matching: find.byType(FittedBox),
        ),
        findsNothing,
        reason: 'a FittedBox would scale each label differently again',
      );
    });

    testWidgets('no pill label is cropped under $name', (tester) async {
      await pumpOrders(tester, locale);

      // The four-then-three split only works while the set clears a phone
      // width on its own — nothing in the layout shrinks a label to make it
      // fit, so a longer one would overrun the row rather than shorten.
      for (final element in pillLabels().evaluate()) {
        final paragraph = element.renderObject! as RenderParagraph;
        expect(
          paragraph.didExceedMaxLines,
          isFalse,
          reason: '"${(element.widget as Text).data}" is being cropped',
        );
      }
    });

    testWidgets('the pills land in rows of four and three under $name', (
      tester,
    ) async {
      await pumpOrders(tester, locale);

      // Group the labels by their top edge: one entry per row, in order.
      final rows = <int, int>{};
      for (final element in pillLabels().evaluate()) {
        final top = tester.getRect(find.byWidget(element.widget)).top.round();
        rows[top] = (rows[top] ?? 0) + 1;
      }

      final counts = [
        for (final top in rows.keys.toList()..sort()) rows[top]!,
      ];
      expect(counts, [4, 3]);
    });

    testWidgets('the pills fit the width without overflowing under $name', (
      tester,
    ) async {
      await pumpOrders(tester, locale);

      final block = tester.getRect(find.byKey(OrdersListScreen.pillsKey));
      for (final element in pillLabels().evaluate()) {
        final label = tester.getRect(find.byWidget(element.widget));
        expect(
          block.left - 0.5 <= label.left && label.right <= block.right + 0.5,
          isTrue,
          reason: 'a pill runs outside the row',
        );
      }
    });
  }
}
