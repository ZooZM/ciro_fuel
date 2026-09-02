import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/delivery/domain/usecases/mark_arrived.dart';
import 'package:mobile_app/features/delivery/domain/usecases/request_delivery_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart'
    as delivery;
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart'
    as delivery;
import 'package:mobile_app/features/delivery/presentation/cubit/otp_verify_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/view/delivery_detail_screen.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_current_otp.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_order.dart';
import 'package:mobile_app/features/orders/presentation/cubit/order_detail_cubit.dart';
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

class _MockTrackingSocket extends Mock implements TrackingSocket {}

/// spec 007 T063 (FR-026/FR-027b): `delivery_detail_screen.dart` against
/// the real `DeliveryDetailScreen` widget — its own `OrderDetailCubit`
/// (spec 005) already listens for `order:status`, so this pins down that
/// the screen actually rebuilds off it, and that the call action honours
/// `clientSummary`'s absence rather than rendering a dead button.
void main() {
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

  testWidgets('a status push while the detail is open moves the displayed stage', (
    tester,
  ) async {
    final order = Order(
      id: 'order-live-1',
      status: OrderStatus.inTransit,
      fuelType: FuelType.diesel,
      quantityLiters: 500,
      clientSummary: const ClientSummary(fullName: 'Noura', phone: '+966522222222'),
      statusChangedAt: DateTime.utc(2026, 1, 1, 12),
    );
    // Mutated in place once the push arrives — `FakeOrdersRepository.getOrder`
    // re-reads from this same list on every call, exactly like the real
    // endpoint would return the order's new status on the cubit's reload.
    final orders = [order];
    registerOrdersTestDi(orders: orders);

    final socket = _MockTrackingSocket();
    void Function(Map<String, dynamic>)? statusHandler;
    when(() => socket.onStatus(any())).thenAnswer((invocation) {
      statusHandler =
          invocation.positionalArguments[0] as void Function(Map<String, dynamic>);
    });
    when(() => socket.onOtp(any())).thenAnswer((_) {});
    getIt.unregister<TrackingSocket>();
    getIt.registerLazySingleton<TrackingSocket>(() => socket);
    getIt.unregister<OrderDetailCubit>();
    getIt.registerFactoryParam<OrderDetailCubit, String, void>(
      (orderId, _) => OrderDetailCubit(
        orderId: orderId,
        getOrder: getIt<GetOrder>(),
        getCurrentOtp: getIt<GetCurrentOtp>(),
        socket: getIt<TrackingSocket>(),
      ),
    );

    await pumpLocalized(
      tester,
      DeliveryDetailScreen(orderId: order.id),
      locale: const Locale('en'),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('In transit'), findsWidgets);

    orders[0] = order.copyWith(
      status: OrderStatus.unloading,
      statusChangedAt: DateTime.utc(2026, 1, 1, 13),
    );
    statusHandler!({
      'orderId': order.id,
      'from': 'IN_TRANSIT',
      'to': 'UNLOADING',
      'at': '2026-01-01T13:00:00Z',
    });
    await tester.pump();
    await tester.pump();

    expect(find.text('Unloading'), findsWidgets);
    expect(find.text('Request Delivery Code'), findsOneWidget);
  });

  testWidgets('the call action is absent for an order with no clientSummary (FR-027b)', (
    tester,
  ) async {
    final order = Order(
      id: 'order-no-contact-1',
      status: OrderStatus.inTransit,
      fuelType: FuelType.diesel,
      quantityLiters: 500,
      statusChangedAt: DateTime.utc(2026, 1, 1, 12),
    );
    registerOrdersTestDi(orders: [order]);

    await pumpLocalized(
      tester,
      DeliveryDetailScreen(orderId: order.id),
      locale: const Locale('en'),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Contact Customer'), findsNothing);
    // The rest of the action row is unaffected by the missing contact.
    expect(find.text('I Have Arrived'), findsOneWidget);
  });
}
