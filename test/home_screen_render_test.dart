import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/home/presentation/view/client_home_screen.dart';

import 'helpers/localized_harness.dart';

void main() {
  testWidgets('lays out on a phone screen without overflowing', (tester) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1206, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      const ClientHomeScreen(),
      theme: ThemeData(fontFamily: 'Tajawal', useMaterial3: true),
    );

    expect(tester.takeException(), isNull);

    // Station card, the at-a-glance counters, and the order card. The station
    // name and driver are placeholder data, so they stay Arabic in both
    // locales; the labels around them come from the catalogue.
    expect(find.text('محطة الرحاب'), findsOneWidget);
    expect(find.text('تغيير المحطة'), findsOneWidget);
    expect(find.text('نظرة سريعة'), findsOneWidget);
    // findsWidgets, not findsOneWidget: 'قيد التوصيل' is both a counter label
    // and the current order's status badge.
    for (final label in ['تم التوصيل', 'قيد التوصيل', 'قيد التجهيز', 'ملغاة']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.text('أحمد السبيعي'), findsOneWidget);
  });

  testWidgets('renders English copy and flips to LTR under the en locale', (
    tester,
  ) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1206, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      const ClientHomeScreen(),
      locale: const Locale('en'),
      theme: ThemeData(fontFamily: 'Tajawal', useMaterial3: true),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Change station'), findsOneWidget);
    expect(find.text('At a glance'), findsOneWidget);
    // No screen forces its own direction any more, so the locale decides.
    expect(
      Directionality.of(tester.element(find.byType(ClientHomeScreen))),
      TextDirection.ltr,
    );
  });
}
