import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/orders/presentation/view/create_order_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/invoice_payment_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/order_detail_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/track_order_screen.dart';

import 'helpers/localized_harness.dart';

/// Every order screen must lay out on a phone without overflowing. Widget tests
/// surface overflow as a thrown FlutterError, so simply pumping each one is the
/// check — `expect(tester.takeException(), isNull)` then reports it per screen.
void main() {
  Future<void> pumpPhone(WidgetTester tester, Widget screen) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await pumpLocalized(
      tester,
      screen,
      theme: ThemeData(fontFamily: 'Tajawal', useMaterial3: true),
    );
  }

  testWidgets('the order form renders', (tester) async {
    await pumpPhone(tester, const CreateOrderScreen());
    expect(tester.takeException(), isNull);
    expect(find.text('طلب وقود جديد'), findsOneWidget);
  });

  for (final state in MockOrderState.values) {
    testWidgets('order detail renders in ${state.name}', (tester) async {
      await pumpPhone(
        tester,
        OrderDetailScreen(orderId: 'x', mockState: state),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('حالة الطلب'), findsOneWidget);
    });
  }

  testWidgets('the sadad invoice renders', (tester) async {
    await pumpPhone(tester, const InvoicePaymentScreen());
    expect(tester.takeException(), isNull);
    expect(find.text('بيانات الفاتورة'), findsOneWidget);
  });

  testWidgets('the tracking screen renders', (tester) async {
    await pumpPhone(tester, const TrackOrderScreen());
    expect(tester.takeException(), isNull);
    expect(find.text('تتبع الطلب'), findsOneWidget);
  });
}
