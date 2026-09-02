import 'package:dartz/dartz.dart' hide Order;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/features/delivery/domain/usecases/mark_arrived.dart';
import 'package:mobile_app/features/delivery/domain/usecases/request_delivery_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart'
    as delivery;
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart'
    as delivery;
import 'package:mobile_app/features/delivery/presentation/cubit/otp_verify_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/view/delivery_detail_screen.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/localized_harness.dart';
import '../support/orders_test_di.dart';

class _MockMarkArrived extends Mock implements MarkArrived {}

class _MockRequestDeliveryOtp extends Mock implements RequestDeliveryOtp {}

class _MockVerifyArrivalOtp extends Mock implements delivery.VerifyArrivalOtp {}

class _MockVerifyDeliveryOtp extends Mock implements delivery.VerifyDeliveryOtp {}

/// spec 007 T062 (FR-024/FR-025): `delivery_detail_screen.dart` used to
/// drive its progress display from a tap-cycled `_OrderMockState` — any
/// tap on the app-bar icon advanced the stage regardless of the real
/// order. Now it is a plain `StatelessWidget` tree over `OrderDetailCubit`;
/// this pins down that (a) nothing on the screen still does that, and (b)
/// each real status renders the phase FR-024 assigns it.
void main() {
  Order orderAt(OrderStatus status) => Order(
    id: 'order-stage-1',
    status: status,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    etaMinutes: 12,
    clientSummary: const ClientSummary(fullName: 'Sara Al-Qahtani', phone: '+966511111111'),
    statusChangedAt: DateTime.utc(2026, 1, 1, 12),
  );

  setUp(() {
    getIt.registerFactoryParam<OtpVerifyCubit, String, void>(
      (orderId, _) => OtpVerifyCubit(
        orderId: orderId,
        markArrived: _MockMarkArrived(),
        verifyArrivalOtp: _MockVerifyArrivalOtp(),
        requestDeliveryOtp: _MockRequestDeliveryOtp(),
        verifyDeliveryOtp: _MockVerifyDeliveryOtp(),
      ),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<OtpVerifyCubit>()) {
      getIt.unregister<OtpVerifyCubit>();
    }
    resetOrdersTestDi();
  });

  Future<void> pumpDetail(WidgetTester tester, Order order) async {
    registerOrdersTestDi(orders: [order]);
    await pumpLocalized(
      tester,
      DeliveryDetailScreen(orderId: order.id),
      locale: const Locale('en'),
    );
    // `pumpLocalized`'s own settle only waits for the translation catalogue,
    // not for `OrderDetailCubit.load()`'s Future (started, not awaited, by
    // the screen's `create: (_) => getIt<OrderDetailCubit>(...)..load()`)
    // to resolve and rebuild past the initial `loading()` frame.
    await tester.pump();
    await tester.pump();
  }

  // The status chip and the stepper's own step labels both read from the
  // same `OrderPresentation.statusLabel`, so the current status's word
  // appears twice on screen (chip + its stepper step) — `findsWidgets`
  // rather than a fixed count, since only CANCELLED (no stepper at all)
  // is the one-match case.
  for (final entry in {
    OrderStatus.inTransit: 'In transit',
    OrderStatus.unloading: 'Unloading',
    OrderStatus.delivered: 'Delivered',
    OrderStatus.cancelled: 'Cancelled',
  }.entries) {
    testWidgets('${entry.key} renders its own status label', (tester) async {
      await pumpDetail(tester, orderAt(entry.key));
      expect(find.text(entry.value), findsWidgets);
    });
  }

  testWidgets('tapping the progress card and stepper leaves the stage unchanged', (
    tester,
  ) async {
    await pumpDetail(tester, orderAt(OrderStatus.inTransit));
    expect(find.text('In transit'), findsWidgets);

    // None of these are real actions — just decorative content the old
    // `_cycleMockState` app-bar button used to react to regardless of
    // where the driver actually tapped.
    await tester.tap(find.text('In transit').first);
    await tester.pump();
    await tester.tap(find.text('Unloading'));
    await tester.pump();
    await tester.tap(find.text('Delivered'));
    await tester.pump();

    // Still the same real status — no local state advanced any of it.
    expect(find.text('In transit'), findsWidgets);
    expect(find.text('Delivered'), findsOneWidget); // stepper label only, not the chip
  });

  testWidgets('a terminal status offers no arrive/request-code action', (tester) async {
    await pumpDetail(tester, orderAt(OrderStatus.delivered));
    expect(find.text('I Have Arrived'), findsNothing);
    expect(find.text('Request Delivery Code'), findsNothing);
  });
}
