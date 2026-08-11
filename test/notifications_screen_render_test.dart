import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/notifications/presentation/view/notifications_screen.dart';

import 'helpers/localized_harness.dart';

void main() {
  testWidgets('renders all groups on a phone-sized screen without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    await pumpLocalized(tester, const NotificationsScreen());

    expect(tester.takeException(), isNull);

    // Chips, the mark-all action, and the group headers should all be present.
    for (final label in ['الكل', 'الطلبات', 'الفواتير', 'النظام']) {
      expect(find.text(label), findsOneWidget, reason: 'chip $label');
    }
    expect(find.text('تحديد الكل كمقروء'), findsOneWidget);
    expect(find.text('اليوم'), findsOneWidget);
    expect(find.text('أمس'), findsOneWidget);
    expect(find.textContaining('تم قبول طلبك'), findsWidgets);
  });

  testWidgets('filtering by الفواتير hides order cards', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    await pumpLocalized(tester, const NotificationsScreen());

    expect(find.textContaining('تم قبول طلبك'), findsWidgets);
    // The chip row scrolls horizontally, and the test font is far wider than
    // Tajawal, so bring the chip into view before tapping it.
    await tester.ensureVisible(find.text('الفواتير'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('الفواتير'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.textContaining('تم قبول طلبك'), findsNothing);
    expect(find.textContaining('فاتورة مستحقة'), findsWidgets);
  });
}
