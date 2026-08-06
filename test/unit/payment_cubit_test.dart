import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/orders/domain/gateways/payment_gateway.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_order.dart';
import 'package:mobile_app/features/orders/presentation/cubit/payment_cubit.dart';
import 'package:mobile_app/features/orders/presentation/cubit/payment_state.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockPaymentGateway extends Mock implements PaymentGateway {}

class _MockTrackingSocket extends Mock implements TrackingSocket {}

class _MockGetOrder extends Mock implements GetOrder {}

void main() {
  late _MockPaymentGateway gateway;
  late _MockTrackingSocket socket;
  late _MockGetOrder getOrder;
  void Function(Map<String, dynamic>)? statusHandler;

  const orderId = 'order-1';
  const amount = Money(amountMinor: 45000, currency: 'SAR');

  Order orderWith(OrderStatus status) => Order(
    id: orderId,
    status: status,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    statusChangedAt: DateTime.utc(2026, 1, 1),
  );

  setUp(() {
    gateway = _MockPaymentGateway();
    socket = _MockTrackingSocket();
    getOrder = _MockGetOrder();
    statusHandler = null;
    when(() => socket.onStatus(any())).thenAnswer((invocation) {
      statusHandler =
          invocation.positionalArguments[0]
              as void Function(Map<String, dynamic>);
    });
    // Harmless default so a stray poll tick (real Timer, fast tests) never
    // throws a MissingStubError in tests that don't care about polling.
    when(
      () => getOrder(orderId),
    ).thenAnswer((_) async => Right(orderWith(OrderStatus.pendingPayment)));
  });

  PaymentCubit build({Duration? pollInterval}) => PaymentCubit(
    orderId: orderId,
    gateway: gateway,
    socket: socket,
    getOrder: getOrder,
    pollInterval: pollInterval,
  );

  blocTest<PaymentCubit, PaymentState>(
    'pay() succeeds at the gateway but stays awaitingConfirmation — never asserts confirmed itself',
    setUp: () {
      when(
        () => gateway.pay(orderId: orderId, amount: amount),
      ).thenAnswer((_) async => const Right(null));
    },
    build: build,
    act: (cubit) => cubit.pay(amount),
    expect: () => const [
      PaymentState.initiating(),
      PaymentState.awaitingConfirmation(),
    ],
  );

  blocTest<PaymentCubit, PaymentState>(
    'confirmed is emitted ONLY when the backend pushes order:status -> inTransit',
    setUp: () {
      when(
        () => gateway.pay(orderId: orderId, amount: amount),
      ).thenAnswer((_) async => const Right(null));
    },
    build: build,
    act: (cubit) async {
      await cubit.pay(amount);
      statusHandler!({
        'orderId': orderId,
        'to': 'IN_TRANSIT',
        'at': DateTime.now().toIso8601String(),
      });
    },
    expect: () => const [
      PaymentState.initiating(),
      PaymentState.awaitingConfirmation(),
      PaymentState.confirmed(),
    ],
  );

  blocTest<PaymentCubit, PaymentState>(
    'confirmed is also reached via REST polling — required because order:watch '
    'only succeeds once already IN_TRANSIT/UNLOADING, so the room-scoped '
    'order:status push cannot be relied on for this exact transition',
    setUp: () {
      when(
        () => gateway.pay(orderId: orderId, amount: amount),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => getOrder(orderId),
      ).thenAnswer((_) async => Right(orderWith(OrderStatus.inTransit)));
    },
    build: () => build(pollInterval: const Duration(milliseconds: 5)),
    act: (cubit) => cubit.pay(amount),
    wait: const Duration(milliseconds: 30),
    expect: () => const [
      PaymentState.initiating(),
      PaymentState.awaitingConfirmation(),
      PaymentState.confirmed(),
    ],
  );

  blocTest<PaymentCubit, PaymentState>(
    'a status push for a different order is ignored',
    setUp: () {
      when(
        () => gateway.pay(orderId: orderId, amount: amount),
      ).thenAnswer((_) async => const Right(null));
    },
    build: build,
    act: (cubit) async {
      await cubit.pay(amount);
      statusHandler!({
        'orderId': 'some-other-order',
        'to': 'IN_TRANSIT',
        'at': DateTime.now().toIso8601String(),
      });
    },
    expect: () => const [
      PaymentState.initiating(),
      PaymentState.awaitingConfirmation(),
    ],
  );

  blocTest<PaymentCubit, PaymentState>(
    'reverting to approved while awaiting confirmation surfaces windowExpired',
    setUp: () {
      when(
        () => gateway.pay(orderId: orderId, amount: amount),
      ).thenAnswer((_) async => const Right(null));
    },
    build: build,
    act: (cubit) async {
      await cubit.pay(amount);
      statusHandler!({
        'orderId': orderId,
        'to': 'APPROVED',
        'at': DateTime.now().toIso8601String(),
      });
    },
    expect: () => const [
      PaymentState.initiating(),
      PaymentState.awaitingConfirmation(),
      PaymentState.windowExpired(),
    ],
  );

  blocTest<PaymentCubit, PaymentState>(
    'gateway failure surfaces the mapped Failure',
    setUp: () {
      when(
        () => gateway.pay(orderId: orderId, amount: amount),
      ).thenAnswer((_) async => const Left(Failure.network()));
    },
    build: build,
    act: (cubit) => cubit.pay(amount),
    expect: () => const [
      PaymentState.initiating(),
      PaymentState.failure(Failure.network()),
    ],
  );
}
