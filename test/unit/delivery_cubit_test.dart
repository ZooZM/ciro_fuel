import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/delivery/data/services/location_stream_service.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_active_order.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_state.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetActiveOrder extends Mock implements GetActiveOrder {}

class _MockLocationStreamService extends Mock implements LocationStreamService {}

class _MockTrackingSocket extends Mock implements TrackingSocket {}

void main() {
  late _MockGetActiveOrder getActiveOrder;
  late _MockLocationStreamService locationStream;
  late _MockTrackingSocket socket;
  void Function(Map<String, dynamic>)? statusHandler;

  final order = Order(
    id: 'o1',
    status: OrderStatus.inTransit,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    statusChangedAt: DateTime.utc(2026, 1, 1, 12),
  );

  setUp(() {
    getActiveOrder = _MockGetActiveOrder();
    locationStream = _MockLocationStreamService();
    socket = _MockTrackingSocket();
    statusHandler = null;
    when(() => socket.onStatus(any())).thenAnswer((i) {
      statusHandler = i.positionalArguments[0] as void Function(Map<String, dynamic>);
    });
    when(locationStream.stop).thenAnswer((_) async {});
  });

  DeliveryCubit build() => DeliveryCubit(
    getActiveOrder: getActiveOrder,
    locationStream: locationStream,
    socket: socket,
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
      when(getActiveOrder.call).thenAnswer((_) async => const Left(Failure.network()));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [DeliveryState.failure(Failure.network())],
  );

  blocTest<DeliveryCubit, DeliveryState>(
    'a terminal status push for the active order stops streaming and reloads',
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
      statusHandler!({'orderId': 'o1', 'to': 'DELIVERED', 'at': '2026-01-01T13:00:00Z'});
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
}
