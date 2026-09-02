import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/delivery/presentation/view/driver_orders_screen.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';

import '../helpers/localized_harness.dart';
import '../support/orders_test_di.dart';

/// spec 007 T049 (FR-020/FR-020a/FR-020b): `driver_orders_screen.dart` used
/// to label its tabs from `InvoicesKeys` — invoice states copy-pasted onto
/// a driver's delivery list. This pins down the real four categories select
/// exactly the statuses FR-020a assigns them, and that no invoice
/// vocabulary survives anywhere on the screen.
void main() {
  final orders = [
    Order(
      id: 'order-in-transit',
      status: OrderStatus.inTransit,
      fuelType: FuelType.diesel,
      quantityLiters: 100,
      statusChangedAt: DateTime.utc(2026, 1, 1),
    ),
    Order(
      id: 'order-unloading',
      status: OrderStatus.unloading,
      fuelType: FuelType.diesel,
      quantityLiters: 200,
      statusChangedAt: DateTime.utc(2026, 1, 2),
    ),
    Order(
      id: 'order-delivered',
      status: OrderStatus.delivered,
      fuelType: FuelType.diesel,
      quantityLiters: 300,
      statusChangedAt: DateTime.utc(2026, 1, 3),
    ),
    Order(
      id: 'order-cancelled',
      status: OrderStatus.cancelled,
      fuelType: FuelType.diesel,
      quantityLiters: 400,
      statusChangedAt: DateTime.utc(2026, 1, 4),
    ),
  ];

  tearDown(resetOrdersTestDi);

  Future<void> pumpScreen(WidgetTester tester) async {
    registerOrdersTestDi(orders: orders);
    await pumpLocalized(tester, const DriverOrdersScreen(), locale: const Locale('en'));
    await tester.pump();
    await tester.pump();
  }

  testWidgets('All shows every one of this driver\'s deliveries', (tester) async {
    await pumpScreen(tester);
    // Reference numbers are the last 6 uppercase chars of the id.
    expect(find.text('#RANSIT'), findsOneWidget);
    expect(find.text('#OADING'), findsOneWidget);
    expect(find.text('#IVERED'), findsOneWidget);
    expect(find.text('#CELLED'), findsOneWidget);
  });

  testWidgets('In progress shows only IN_TRANSIT and UNLOADING', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('In progress'));
    await tester.pumpAndSettle();

    expect(find.text('#RANSIT'), findsOneWidget);
    expect(find.text('#OADING'), findsOneWidget);
    expect(find.text('#IVERED'), findsNothing);
  });

  testWidgets('Completed shows only DELIVERED', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();

    expect(find.text('#IVERED'), findsOneWidget);
    expect(find.text('#RANSIT'), findsNothing);
    expect(find.text('#OADING'), findsNothing);
  });

  testWidgets('Cancelled shows only CANCELLED', (tester) async {
    await pumpScreen(tester);
    // "Cancelled" is also `OrderPresentation.statusLabel`'s text for the
    // cancelled order already visible under "All" — `.first` hits the tab.
    await tester.tap(find.text('Cancelled').first);
    await tester.pumpAndSettle();

    expect(find.text('#IVERED'), findsNothing);
    expect(find.text('#RANSIT'), findsNothing);
  });

  testWidgets('no invoice vocabulary appears anywhere on the screen', (tester) async {
    await pumpScreen(tester);
    expect(find.text('Deferred'), findsNothing);
    expect(find.text('Paid'), findsNothing);
    expect(find.text('Failed'), findsNothing);
  });
}
