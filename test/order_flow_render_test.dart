import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/orders/presentation/view/create_order_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/invoice_payment_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/order_detail_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/track_order_screen.dart';

/// Without the real font, text falls back to a fixed-width test face that is
/// far wider than Tajawal, which reports overflows the app would never hit.
Future<void> _loadTajawal() async {
  final loader = FontLoader('Tajawal');
  for (final font in const [
    'assets/fonts/Tajawal-Regular.ttf',
    'assets/fonts/Tajawal-Medium.ttf',
    'assets/fonts/Tajawal-Bold.ttf',
    'assets/fonts/Tajawal-ExtraBold.ttf',
  ]) {
    loader.addFont(rootBundle.load(font));
  }
  await loader.load();
}

/// Every order screen must lay out on a phone without overflowing. Widget tests
/// surface overflow as a thrown FlutterError, so simply pumping each one is the
/// check — `expect(tester.takeException(), isNull)` then reports it per screen.
void main() {
  Future<void> pumpPhone(WidgetTester tester, Widget screen) async {
    await _loadTajawal();
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Tajawal', useMaterial3: true),
        home: screen,
      ),
    );
    await tester.pump();
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
