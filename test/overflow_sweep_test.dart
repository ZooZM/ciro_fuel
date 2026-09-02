import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/delivery_time_card.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/invoices/presentation/view/client_invoices_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/create_order_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/order_detail_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/orders_list_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/track_order_screen.dart';
import 'package:mobile_app/features/payments/presentation/view/client_payments_screen.dart';
import 'package:mobile_app/features/orders/presentation/widgets/create_order/create_order_data.dart';
import 'package:mobile_app/features/orders/presentation/widgets/create_order/delivery_section.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/payment_method.dart';

import 'helpers/localized_harness.dart';
import 'support/orders_test_di.dart';

/// Flutter reports a layout overflow by throwing, so pumping each screen and
/// asking for the pending exception is the check.
///
/// Both locales, because the English copy is materially longer than the Arabic
/// it was laid out against — every overflow found so far showed up only there.
void main() {
  // OrdersListScreen and OrderDetailScreen now resolve real cubits from
  // getIt (spec 005) rather than rendering mock data standalone.
  setUp(() {
    registerOrdersTestDi();
    registerFinanceTestDi();
    registerPaymentsTestDi();
  });
  tearDown(() {
    resetOrdersTestDi();
    resetFinanceTestDi();
    resetPaymentsTestDi();
  });

  Widget wrap(Widget child) => Scaffold(
    body: SafeArea(
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );

  final cases = <String, Widget>{
    'create order': BlocProvider<SessionCubit>.value(
      value: sampleAuthenticatedSessionCubit(),
      child: const CreateOrderScreen(),
    ),
    'orders list': const OrdersListScreen(),
    'track order': const TrackOrderScreen(orderId: '6a678f6a7bcf5a3ef09ae45a'),
    'invoices list': const ClientInvoicesScreen(),
    'payments list': const ClientPaymentsScreen(),
    'delivery time card': wrap(const DeliveryTimeCard()),
    'delivery section': wrap(
      DeliverySection(
        selected: DeliveryOption.today,
        onChanged: (_) {},
        onScheduleTap: () {},
      ),
    ),
  };

  for (final entry in cases.entries) {
    for (final (localeName, locale) in [
      ('Arabic', AppLocales.arabic),
      ('English', AppLocales.english),
    ]) {
      testWidgets('${entry.key} lays out under $localeName', (tester) async {
        await loadTajawal();
        // A common small-ish phone; overflows hide on a roomy canvas.
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await pumpLocalized(
          tester,
          entry.value,
          locale: locale,
          theme: AppTheme.lightTheme,
        );

        expect(
          tester.takeException(),
          isNull,
          reason: '${entry.key} overflows under $localeName',
        );
      });
    }
  }

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

  // One representative order per OrderCardKind (spec 005 T039) — replaces
  // the old sweep over MockOrderState.values.
  final representativeOrders = {
    'pendingApproval': orderWith(OrderStatus.pendingApproval, PaymentMethod.direct),
    'awaitingPayment': orderWith(OrderStatus.pendingPayment, PaymentMethod.direct),
    'confirmed': orderWith(OrderStatus.approved, PaymentMethod.deferred),
    'inTransit': orderWith(OrderStatus.inTransit, PaymentMethod.direct),
    'delivered': orderWith(OrderStatus.delivered, PaymentMethod.direct),
    'cancelled': orderWith(OrderStatus.cancelled, PaymentMethod.direct),
  };

  for (final entry in representativeOrders.entries) {
    testWidgets('order detail (${entry.key}) lays out under English', (
      tester,
    ) async {
      registerOrdersTestDi(orders: [entry.value]);
      await loadTajawal();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await pumpLocalized(
        tester,
        OrderDetailScreen(orderId: entry.value.id),
        locale: AppLocales.english,
        theme: AppTheme.lightTheme,
      );

      expect(tester.takeException(), isNull, reason: '${entry.key} overflows');
    });
  }
}
