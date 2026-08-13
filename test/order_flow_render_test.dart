import 'package:easy_localization/easy_localization.dart';
// `Localization` and `Translations` are what `.tr()` reads from, but
// easy_localization only re-exports the widget that populates them. Seeding
// them directly is the only way to translate a tree the EasyLocalization
// widget is not wrapped around.
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/features/orders/presentation/view/create_order_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/invoice_payment_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/order_detail_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/track_order_screen.dart';

import 'helpers/localized_harness.dart';
import 'support/orders_test_di.dart';

/// Every order screen must lay out on a phone without overflowing. Widget tests
/// surface overflow as a thrown FlutterError, so simply pumping each one is the
/// check — `expect(tester.takeException(), isNull)` then reports it per screen.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Every label on these screens comes from `assets/translations/*.json`,
    // so the harness has to load them — otherwise the screens render raw
    // keys and every `find.text` below misses.
    //
    // The translations go straight into `Localization`, rather than being
    // pumped as an `EasyLocalization` widget: that widget reads its JSON off
    // disk asynchronously, and real file I/O never completes inside the
    // fake-async zone a widget test pumps in.
    final arabic = await const RootBundleAssetLoader().load(
      AppAssets.translationsPath,
      AppLocales.arabic,
    );
    Localization.load(AppLocales.arabic, translations: Translations(arabic));
  });

  // CreateOrderScreen resolves CreateOrder from getIt on construction
  // (spec 004 T090's real submit wiring).
  setUp(registerOrdersTestDi);
  tearDown(resetOrdersTestDi);

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
