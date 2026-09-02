import 'package:easy_localization/easy_localization.dart';
// `Localization` and `Translations` are what `.tr()` reads from, but
// easy_localization only re-exports the widget that populates them. Seeding
// them directly is the only way to translate a tree the EasyLocalization
// widget is not wrapped around.
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/orders/presentation/view/create_order_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/invoice_payment_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/order_detail_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/track_order_screen.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/payment_method.dart';

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
  // (spec 004 T090's real submit wiring), and OrderDetailScreen now
  // resolves CreditCubit too — its credit card reads the platform's own
  // figures rather than the hardcoded ones it used to draw (FR-026).
  setUp(() {
    registerOrdersTestDi();
    registerFinanceTestDi();
  });
  tearDown(() {
    resetOrdersTestDi();
    resetFinanceTestDi();
  });

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
    await pumpPhone(
      tester,
      BlocProvider<SessionCubit>.value(
        value: sampleAuthenticatedSessionCubit(),
        child: const CreateOrderScreen(),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('طلب وقود جديد'), findsOneWidget);
  });

  // One representative order per OrderCardKind (spec 005 T039) — replaces
  // the old sweep over MockOrderState.values now that the screen reads a
  // real order instead of a preview enum.
  Order orderWith(OrderStatus status, PaymentMethod method) => Order(
    // A real-length Mongo ObjectId — OrderPresentation.shortReference
    // assumes at least 6 characters, always true in production.
    id: '6a678f6a7bcf5a3ef09ae45a',
    status: status,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    estimatedPrice: const Money(amountMinor: 125000, currency: 'SAR'),
    paymentMethod: method,
    statusChangedAt: DateTime.utc(2026, 1, 1),
  );

  final representativeOrders = {
    'pendingApproval': orderWith(OrderStatus.pendingApproval, PaymentMethod.direct),
    'awaitingPayment': orderWith(OrderStatus.pendingPayment, PaymentMethod.direct),
    'confirmed': orderWith(OrderStatus.approved, PaymentMethod.deferred),
    'inTransit': orderWith(OrderStatus.inTransit, PaymentMethod.direct),
    'delivered': orderWith(OrderStatus.delivered, PaymentMethod.direct),
    'cancelled': orderWith(OrderStatus.cancelled, PaymentMethod.direct),
  };

  for (final entry in representativeOrders.entries) {
    testWidgets('order detail renders in ${entry.key}', (tester) async {
      registerOrdersTestDi(orders: [entry.value]);
      await pumpPhone(tester, OrderDetailScreen(orderId: entry.value.id));
      expect(tester.takeException(), isNull);
      // The cancelled kind renders no status card at all (matches the
      // pre-005 mock's `canceled` treatment) — nothing else to assert there.
      if (entry.key != 'cancelled') {
        expect(find.text('حالة الطلب'), findsOneWidget);
      }
    });
  }

  testWidgets('the sadad invoice renders', (tester) async {
    await pumpPhone(
      tester,
      const InvoicePaymentScreen(orderId: '6a678f6a7bcf5a3ef09ae45a'),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('بيانات الفاتورة'), findsOneWidget);
  });

  testWidgets('the tracking screen renders', (tester) async {
    await pumpPhone(
      tester,
      const TrackOrderScreen(orderId: '6a678f6a7bcf5a3ef09ae45a'),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('تتبع الطلب'), findsOneWidget);
  });
}
