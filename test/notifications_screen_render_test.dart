import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/notifications/domain/entities/app_notification.dart';
import 'package:mobile_app/features/notifications/presentation/view/notifications_screen.dart';
import 'package:mobile_app/shared/enums/notification_type.dart';

import 'helpers/localized_harness.dart';
import 'support/orders_test_di.dart';

List<AppNotification> _sampleNotifications() {
  final now = DateTime.now();
  return [
    AppNotification(
      id: 'n1',
      type: NotificationType.orderApprovedFinalPrice,
      orderId: '6a678f6a7bcf5a3ef09ae45a',
      createdAt: now,
    ),
    AppNotification(
      id: 'n2',
      type: NotificationType.orderStatusChanged,
      orderId: '6a678f6a7bcf5a3ef09ae45b',
      createdAt: now.subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];
}

void main() {
  setUp(() => registerOrdersTestDi(notifications: _sampleNotifications()));
  tearDown(resetOrdersTestDi);

  testWidgets('renders all groups on a phone-sized screen without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    await pumpLocalized(tester, const NotificationsScreen());

    expect(tester.takeException(), isNull);

    for (final label in ['الكل', 'غير مقروء']) {
      expect(find.text(label), findsOneWidget, reason: 'chip $label');
    }
    expect(find.text('تحديد الكل كمقروء'), findsOneWidget);
    expect(find.text('اليوم'), findsOneWidget);
    expect(find.text('أمس'), findsOneWidget);
  });

  testWidgets('the unread filter hides already-read notifications', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    await pumpLocalized(tester, const NotificationsScreen());

    // Both the unread (today) and read (yesterday) groups start visible.
    expect(find.text('اليوم'), findsOneWidget);
    expect(find.text('أمس'), findsOneWidget);

    await tester.ensureVisible(find.text('غير مقروء'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('غير مقروء'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('اليوم'), findsOneWidget);
    expect(find.text('أمس'), findsNothing);
  });
}
