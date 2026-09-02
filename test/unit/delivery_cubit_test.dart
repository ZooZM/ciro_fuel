import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/features/delivery/data/services/location_stream_service.dart';
import 'package:mobile_app/features/delivery/domain/usecases/acknowledge_assignment.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_active_order.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_state.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetActiveOrder extends Mock implements GetActiveOrder {}

class _MockVerifyArrivalOtp extends Mock implements VerifyArrivalOtp {}

class _MockVerifyDeliveryOtp extends Mock implements VerifyDeliveryOtp {}

class _MockLocationStreamService extends Mock
    implements LocationStreamService {}

class _MockAcknowledgeAssignment extends Mock implements AcknowledgeAssignment {}

void main() {
  late _MockGetActiveOrder getActiveOrder;
  late _MockVerifyArrivalOtp verifyArrival;
  late _MockVerifyDeliveryOtp verifyDelivery;
  late _MockLocationStreamService locationStream;
  late _MockAcknowledgeAssignment acknowledgeAssignment;

  final order = Order(
    id: 'o1',
    status: OrderStatus.inTransit,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    statusChangedAt: DateTime.utc(2026, 1, 1, 12),
  );

  setUp(() {
    getActiveOrder = _MockGetActiveOrder();
    verifyArrival = _MockVerifyArrivalOtp();
    verifyDelivery = _MockVerifyDeliveryOtp();
    locationStream = _MockLocationStreamService();
    acknowledgeAssignment = _MockAcknowledgeAssignment();
    when(locationStream.stop).thenAnswer((_) async {});
    when(
      () => acknowledgeAssignment(any()),
    ).thenAnswer((_) async => const Right(null));
  });

  DeliveryCubit build() => DeliveryCubit(
    getActiveOrder: getActiveOrder,
    verifyArrivalOtp: verifyArrival,
    verifyDeliveryOtp: verifyDelivery,
    locationStream: locationStream,
    acknowledgeAssignment: acknowledgeAssignment,
  );

  blocTest<DeliveryCubit, DeliveryState>(
    'no active order emits noActiveOrder and stops any stream',
    setUp: () {
      when(getActiveOrder.call).thenAnswer((_) async => const Right(null));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [DeliveryState.noActiveOrder()],
    // Cubit.close() (called by blocTest's teardown) also stops the stream
    // defensively, so load()'s own stop is the 1st of 2 total calls.
    verify: (_) => verify(locationStream.stop).called(2),
  );

  blocTest<DeliveryCubit, DeliveryState>(
    'an active order starts the location stream and reflects whether it actually started',
    setUp: () {
      when(getActiveOrder.call).thenAnswer((_) async => Right(order));
      when(locationStream.start).thenAnswer((_) async => true);
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [DeliveryState.active(order, streaming: true)],
  );

  // spec 010 FR-010/FR-017: fired exactly once per not-yet-acknowledged
  // order load — the explicit signal the backend's escalation waits on,
  // never inferred from anything else about this cubit's own state.
  blocTest<DeliveryCubit, DeliveryState>(
    'an unacknowledged active order fires acknowledgeAssignment',
    setUp: () {
      when(getActiveOrder.call).thenAnswer((_) async => Right(order));
      when(locationStream.start).thenAnswer((_) async => true);
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [DeliveryState.active(order, streaming: true)],
    verify: (_) => verify(() => acknowledgeAssignment('o1')).called(1),
  );

  blocTest<DeliveryCubit, DeliveryState>(
    'an already-acknowledged order never fires acknowledgeAssignment again',
    setUp: () {
      when(
        getActiveOrder.call,
      ).thenAnswer((_) async => Right(order.copyWith(assignmentAcknowledgedAt: DateTime.utc(2026, 1, 1, 12, 1))));
      when(locationStream.start).thenAnswer((_) async => true);
    },
    build: build,
    act: (cubit) => cubit.load(),
    verify: (_) => verifyNever(() => acknowledgeAssignment(any())),
  );

  blocTest<DeliveryCubit, DeliveryState>(
    'a denied location permission still surfaces the order, but not streaming',
    setUp: () {
      when(getActiveOrder.call).thenAnswer((_) async => Right(order));
      when(locationStream.start).thenAnswer((_) async => false);
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [DeliveryState.active(order)],
  );

  blocTest<DeliveryCubit, DeliveryState>(
    'load() failure surfaces the mapped Failure',
    setUp: () {
      when(
        getActiveOrder.call,
      ).thenAnswer((_) async => const Left(Failure.network()));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [DeliveryState.failure(Failure.network())],
  );

  blocTest<DeliveryCubit, DeliveryState>(
    'a status push for the active order — via handleOrderStatus, as DeliveryListener drives it — reloads',
    setUp: () {
      var call = 0;
      when(getActiveOrder.call).thenAnswer((_) async {
        call++;
        return call == 1 ? Right(order) : const Right(null);
      });
      when(locationStream.start).thenAnswer((_) async => true);
    },
    build: build,
    act: (cubit) async {
      await cubit.load();
      cubit.handleOrderStatus({
        'orderId': 'o1',
        'to': 'DELIVERED',
        'at': '2026-01-01T13:00:00Z',
      });
    },
    wait: const Duration(milliseconds: 10),
    expect: () => [
      DeliveryState.active(order, streaming: true),
      const DeliveryState.noActiveOrder(),
    ],
    // One stop from the reload's "no active order" branch, one from
    // Cubit.close() at teardown.
    verify: (_) => verify(locationStream.stop).called(2),
  );

  blocTest<DeliveryCubit, DeliveryState>(
    'a status push for a DIFFERENT order is ignored — FR-026 scopes the reload to the active delivery',
    setUp: () {
      when(getActiveOrder.call).thenAnswer((_) async => Right(order));
      when(locationStream.start).thenAnswer((_) async => true);
    },
    build: build,
    act: (cubit) async {
      await cubit.load();
      cubit.handleOrderStatus({
        'orderId': 'some-other-order',
        'to': 'DELIVERED',
        'at': '2026-01-01T13:00:00Z',
      });
    },
    wait: const Duration(milliseconds: 10),
    expect: () => [DeliveryState.active(order, streaming: true)],
  );

  blocTest<DeliveryCubit, DeliveryState>(
    'a status push while there is no active delivery is a no-op',
    setUp: () {
      when(getActiveOrder.call).thenAnswer((_) async => const Right(null));
    },
    build: build,
    act: (cubit) async {
      await cubit.load();
      cubit.handleOrderStatus({
        'orderId': 'o1',
        'to': 'IN_TRANSIT',
        'at': '2026-01-01T13:00:00Z',
      });
    },
    wait: const Duration(milliseconds: 10),
    expect: () => const [DeliveryState.noActiveOrder()],
  );

  group('confirmHandover routes by the order\'s own status', () {
    // The driver presents one code either way; which transition it completes
    // is the platform's call, not the screen's. Getting this backwards would
    // mark an order delivered when the truck had only just arrived.
    setUp(() {
      when(locationStream.start).thenAnswer((_) async => true);
      when(
        () => verifyArrival(orderId: any(named: 'orderId'), otp: any(named: 'otp')),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => verifyDelivery(orderId: any(named: 'orderId'), otp: any(named: 'otp')),
      ).thenAnswer((_) async => const Right(null));
    });

    test('IN_TRANSIT verifies arrival, never delivery', () async {
      when(getActiveOrder.call).thenAnswer((_) async => Right(order));
      final cubit = build();
      await cubit.load();

      expect(await cubit.confirmHandover('863564'), isNull);
      verify(() => verifyArrival(orderId: 'o1', otp: '863564')).called(1);
      verifyNever(
        () => verifyDelivery(orderId: any(named: 'orderId'), otp: any(named: 'otp')),
      );
      await cubit.close();
    });

    test('UNLOADING verifies delivery, never arrival', () async {
      when(getActiveOrder.call).thenAnswer(
        (_) async => Right(order.copyWith(status: OrderStatus.unloading)),
      );
      final cubit = build();
      await cubit.load();

      expect(await cubit.confirmHandover('863564'), isNull);
      verify(() => verifyDelivery(orderId: 'o1', otp: '863564')).called(1);
      verifyNever(
        () => verifyArrival(orderId: any(named: 'orderId'), otp: any(named: 'otp')),
      );
      await cubit.close();
    });

    test('a rejected code is returned and the order is not advanced', () async {
      when(getActiveOrder.call).thenAnswer((_) async => Right(order));
      when(
        () => verifyArrival(orderId: any(named: 'orderId'), otp: any(named: 'otp')),
      ).thenAnswer((_) async => const Left(Failure.validation('Invalid OTP')));

      final cubit = build();
      await cubit.load();

      final failure = await cubit.confirmHandover('000000');
      expect(failure, isA<ValidationFailure>());
      await cubit.close();
    });

    test('with no active order it refuses rather than calling anything', () async {
      when(getActiveOrder.call).thenAnswer((_) async => const Right(null));
      when(locationStream.stop).thenAnswer((_) async {});
      final cubit = build();
      await cubit.load();

      expect(await cubit.confirmHandover('863564'), isA<ValidationFailure>());
      verifyNever(
        () => verifyArrival(orderId: any(named: 'orderId'), otp: any(named: 'otp')),
      );
      await cubit.close();
    });

    // spec 007 T037/FR-016: a connectivity failure during a handover step
    // must report and leave the delivery visibly unchanged — never advance
    // locally. `confirmHandover` never emits on failure (only `load()`,
    // called explicitly by the caller on success, ever does), so any
    // failure — network included — already leaves the cubit's state alone;
    // this pins that down for the specific failure FR-016 names.
    test('an offline failure is returned and the order is not advanced', () async {
      when(getActiveOrder.call).thenAnswer((_) async => Right(order));
      when(
        () => verifyArrival(orderId: any(named: 'orderId'), otp: any(named: 'otp')),
      ).thenAnswer((_) async => const Left(Failure.network()));

      final cubit = build();
      await cubit.load();
      final stateBefore = cubit.state;

      final failure = await cubit.confirmHandover('863564');
      expect(failure, isA<NetworkFailure>());
      expect(cubit.state, stateBefore);
      await cubit.close();
    });
  });
}
