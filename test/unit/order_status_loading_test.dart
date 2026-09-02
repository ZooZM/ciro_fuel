import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/widgets/order_flow.dart';
import 'package:mobile_app/features/orders/presentation/constants/order_presentation.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/payment_method.dart';

import '../helpers/localized_harness.dart';

/// spec 008 T027 (FR-046c): `LOADING` was the widest-blast-radius change in
/// the feature — every exhaustive switch across both personas had to gain a
/// case.
///
/// Dart's exhaustiveness checking already guarantees a case *exists*; it
/// cannot tell a considered answer from a copy-pasted neighbour, and it says
/// nothing about the translation catalogue, which is not part of the type
/// system at all. So this pins the two failure modes a compiler cannot see:
/// a status that renders blank, and a status that silently inherits another
/// stage's meaning.
void main() {
  /// Renders every status's label so the assertions read real, translated
  /// copy rather than the key that produced it.
  Future<Map<OrderStatus, String>> renderedLabels(
    WidgetTester tester,
    Locale locale,
  ) async {
    final labels = <OrderStatus, String>{};
    await pumpLocalized(
      tester,
      Builder(
        builder: (context) {
          for (final status in OrderStatus.values) {
            labels[status] = OrderPresentation.statusLabel(status);
          }
          // Scrollable: twelve labels overflow the test viewport, and a
          // RenderFlex overflow would fail the test for a reason that has
          // nothing to do with the catalogue.
          return Material(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final entry in labels.entries) Text(entry.value),
                ],
              ),
            ),
          );
        },
      ),
      locale: locale,
    );
    return labels;
  }

  testWidgets('every status renders real copy — no raw keys, no blanks', (tester) async {
    for (final locale in [AppLocales.arabic, AppLocales.english]) {
      final labels = await renderedLabels(tester, locale);

      for (final entry in labels.entries) {
        // A missing catalogue entry surfaces as the key itself, which looks
        // like a label to a passing test and like a bug to a driver.
        expect(entry.value, isNotEmpty, reason: '${entry.key} in $locale');
        expect(
          entry.value.startsWith('order_status.'),
          isFalse,
          reason: '${entry.key} has no translation in $locale',
        );
      }

      // Every stage says something different. Two statuses sharing a label
      // is how a delivery appears not to progress.
      expect(labels.values.toSet(), hasLength(OrderStatus.values.length));
    }
  });

  testWidgets('loading says it is loading, distinctly from its neighbours', (tester) async {
    final english = await renderedLabels(tester, AppLocales.english);
    expect(english[OrderStatus.loading], 'Loading fuel');
    // Distinct from the stage on either side of it — the whole reason the
    // status was added rather than folded into one of them.
    expect(english[OrderStatus.loading], isNot(english[OrderStatus.assignedToDriver]));
    expect(english[OrderStatus.loading], isNot(english[OrderStatus.inTransit]));
  });

  test('every status is genuinely translated, not echoed from English', () async {
    // Read from the catalogues rather than rendered twice: easy_localization
    // keeps one controller per test, so a second `pumpLocalized` in another
    // locale returns the first locale's copy — a harness artefact that would
    // make this assertion pass or fail for reasons unrelated to the files.
    final en = jsonDecode(await File('assets/translations/en.json').readAsString())
        as Map<String, dynamic>;
    final ar = jsonDecode(await File('assets/translations/ar.json').readAsString())
        as Map<String, dynamic>;
    final enStatuses = en['order_status'] as Map<String, dynamic>;
    final arStatuses = ar['order_status'] as Map<String, dynamic>;

    for (final key in enStatuses.keys) {
      // An untranslated string is usually an English one copied across —
      // present, non-empty, and wrong for every Arabic-speaking driver.
      expect(arStatuses[key], isNotNull, reason: '$key missing from ar.json');
      expect(arStatuses[key], isNotEmpty, reason: '$key blank in ar.json');
      expect(arStatuses[key], isNot(enStatuses[key]), reason: '$key untranslated');
    }
    expect(arStatuses.keys.toSet(), enStatuses.keys.toSet());
    expect(enStatuses, hasLength(OrderStatus.values.length));
  });

  group('loading is placed deliberately on every derived surface', () {
    test('it is coloured as moving, not as the neutral default', () {
      // Grouped with inTransit: a loading delivery is under way, just not
      // yet toward the customer.
      expect(
        OrderPresentation.statusColor(OrderStatus.loading),
        OrderPresentation.statusColor(OrderStatus.inTransit),
      );
      expect(
        OrderPresentation.statusColor(OrderStatus.loading),
        isNot(OrderPresentation.statusColor(OrderStatus.pendingApproval)),
      );
    });

    test('it occupies the timeline\'s loading stop', () {
      expect(OrderPresentation.flowStep(OrderStatus.loading), OrderFlowStep.loading);
    });

    test('its progress sits strictly between assignment and transit', () {
      final assigned = OrderPresentation.statusProgress(OrderStatus.assignedToDriver);
      final loading = OrderPresentation.statusProgress(OrderStatus.loading);
      final transit = OrderPresentation.statusProgress(OrderStatus.inTransit);

      // Strictly between, or the ring would appear to stall or jump back
      // when a delivery reaches the depot.
      expect(loading, greaterThan(assigned));
      expect(loading, lessThan(transit));
    });

    test('the client\'s card treats it as an active delivery', () {
      for (final method in PaymentMethod.values) {
        expect(
          cardKindFor(OrderStatus.loading, method),
          cardKindFor(OrderStatus.inTransit, method),
          reason: '$method',
        );
      }
    });

    test('it is deliberately NOT trackable', () {
      // The client's map plots progress toward their own station. During
      // loading the truck is at a depot, so drawing it would present the
      // warehouse leg as progress toward the customer.
      expect(OrderPresentation.isTrackable(OrderStatus.loading), isFalse);
      expect(OrderPresentation.isTrackable(OrderStatus.inTransit), isTrue);
    });

    test('it appears under the in-delivery filter, and only there', () {
      expect(OrderFilter.inDelivery.statuses, contains(OrderStatus.loading));
      for (final filter in OrderFilter.values) {
        if (filter == OrderFilter.inDelivery) continue;
        expect(
          filter.statuses,
          isNot(contains(OrderStatus.loading)),
          reason: '${filter.name} should not also claim loading',
        );
      }
    });
  });

  test('the fuel grades the platform actually sends all render', () {
    // Not strictly LOADING's business, but the same class of defect and the
    // same switch: a grade with no case falls through to a default icon or
    // label, which is invisible until a customer asks why their diesel
    // order shows petrol.
    for (final fuelType in FuelType.values) {
      expect(OrderPresentation.fuelLabel(fuelType), isNotEmpty);
    }
  });
}
