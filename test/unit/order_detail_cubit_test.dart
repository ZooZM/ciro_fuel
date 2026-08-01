import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_current_otp.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_order.dart';
import 'package:mobile_app/features/orders/presentation/cubit/order_detail_cubit.dart';
import 'package:mobile_app/features/orders/presentation/cubit/order_detail_state.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetOrder extends Mock implements GetOrder {}

class _MockGetCurrentOtp extends Mock implements GetCurrentOtp {}

class _MockTrackingSocket extends Mock implements TrackingSocket {}

void main() {
  late _MockGetOrder getOrder;
  late _MockGetCurrentOtp getCurrentOtp;
  late _MockTrackingSocket socket;
  void Function(Map<String, dynamic>)? statusHandler;

  const orderId = 'order-1';
  final baseTime = DateTime.utc(2026, 1, 1, 12);

  Order orderAt(OrderStatus status, DateTime statusChangedAt) => Order(
    id: orderId,
    status: status,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    statusChangedAt: statusChangedAt,
  );

  setUp(() {
    getOrder = _MockGetOrder();
    getCurrentOtp = _MockGetCurrentOtp();
    socket = _MockTrackingSocket();
    statusHandler = null;
    when(() => socket.onStatus(any())).thenAnswer((invocation) {
      statusHandler =
          invocation.positionalArguments[0] as void Function(Map<String, dynamic>);
    });
    when(() => socket.onOtp(any())).thenAnswer((_) {});
  });

  OrderDetailCubit build() => OrderDetailCubit(
    orderId: orderId,
    getOrder: getOrder,
    getCurrentOtp: getCurrentOtp,
    socket: socket,
  );

  blocTest<OrderDetailCubit, OrderDetailState>(
    'load() succeeds and emits the fetched order',
    setUp: () {
      when(
        () => getOrder(orderId),
      ).thenAnswer((_) async => Right(orderAt(OrderStatus.approved, baseTime)));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const OrderDetailState.loading(),
      OrderDetailState.loaded(orderAt(OrderStatus.approved, baseTime)),
    ],
  );

  blocTest<OrderDetailCubit, OrderDetailState>(
    'a newer order:status push triggers a full REST re-fetch, picking up fields '
    'the push itself does not carry (e.g. finalPrice)',
    setUp: () {
      var call = 0;
      when(() => getOrder(orderId)).thenAnswer((_) async {
        call++;
        // First load: pre-approval, no price. Re-fetch after the push:
        // now-approved with a price the {orderId, to, at} push never carried.
        return Right(
          call == 1
              ? orderAt(OrderStatus.pendingApproval, baseTime)
              : orderAt(OrderStatus.approved, baseTime.add(const Duration(minutes: 1))),
        );
      });
    },
    build: build,
    act: (cubit) async {
      await cubit.load();
      statusHandler!({
        'orderId': orderId,
        'to': 'APPROVED',
        'at': baseTime.add(const Duration(minutes: 1)).toIso8601String(),
      });
    },
    wait: const Duration(milliseconds: 10),
    expect: () => [
      const OrderDetailState.loading(),
      OrderDetailState.loaded(orderAt(OrderStatus.pendingApproval, baseTime)),
      const OrderDetailState.loading(),
      OrderDetailState.loaded(
        orderAt(OrderStatus.approved, baseTime.add(const Duration(minutes: 1))),
      ),
    ],
    verify: (_) => verify(() => getOrder(orderId)).called(2),
  );

  blocTest<OrderDetailCubit, OrderDetailState>(
    'an out-of-order (older-or-equal timestamp) push triggers no re-fetch',
    setUp: () {
      when(
        () => getOrder(orderId),
      ).thenAnswer((_) async => Right(orderAt(OrderStatus.pendingPayment, baseTime)));
    },
    build: build,
    act: (cubit) async {
      await cubit.load();
      statusHandler!({
        'orderId': orderId,
        'to': 'APPROVED',
        'at': baseTime.subtract(const Duration(seconds: 1)).toIso8601String(),
      });
    },
    expect: () => [
      const OrderDetailState.loading(),
      OrderDetailState.loaded(orderAt(OrderStatus.pendingPayment, baseTime)),
    ],
    verify: (_) => verify(() => getOrder(orderId)).called(1),
  );

  blocTest<OrderDetailCubit, OrderDetailState>(
    'load() failure surfaces the mapped Failure',
    setUp: () {
      when(() => getOrder(orderId)).thenAnswer((_) async => const Left(Failure.notFound()));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      OrderDetailState.loading(),
      OrderDetailState.failure(Failure.notFound()),
    ],
  );
}
