import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/network/paginated_response.dart';
import 'package:mobile_app/features/orders/domain/repositories/orders_repository.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_orders.dart';
import 'package:mobile_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mobile_app/features/orders/presentation/cubit/orders_state.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

import '../support/orders_test_di.dart' show OfflineTrackingSocket;

class _MockOrdersRepository extends Mock implements OrdersRepository {}

Order _order(String id) => Order(
  id: id,
  status: OrderStatus.pendingApproval,
  fuelType: FuelType.diesel,
  quantityLiters: 500,
  statusChangedAt: DateTime.utc(2026, 1, 1),
);

void main() {
  late _MockOrdersRepository repository;
  late GetOrders getOrders;

  setUp(() {
    repository = _MockOrdersRepository();
    getOrders = GetOrders(repository);
  });

  // Never connected, so the cubit's `order:status` subscription is an inert
  // registration and pagination is exercised on its own.
  OrdersCubit build() =>
      OrdersCubit(getOrders: getOrders, socket: OfflineTrackingSocket());

  group('loadMore', () {
    blocTest<OrdersCubit, OrdersState>(
      'is a no-op when nextCursor is null (no further page)',
      setUp: () {
        when(
          () => repository.getOrders(status: null, cursor: null),
        ).thenAnswer(
          (_) async =>
              Right(PaginatedResult(items: [_order('a')], nextCursor: null)),
        );
      },
      build: build,
      act: (cubit) async {
        await cubit.load();
        await cubit.loadMore();
      },
      verify: (_) {
        // Exactly the one call load() made — loadMore() placed none of its own.
        verify(
          () => repository.getOrders(
            status: any(named: 'status'),
            cursor: any(named: 'cursor'),
          ),
        ).called(1);
      },
      expect: () => [
        const OrdersState.loading(),
        OrdersState.loaded([_order('a')], nextCursor: null),
      ],
    );

    blocTest<OrdersCubit, OrdersState>(
      'is a no-op when a load is already in flight',
      setUp: () {
        when(
          () => repository.getOrders(status: null, cursor: null),
        ).thenAnswer(
          (_) async => Right(
            PaginatedResult(items: [_order('a')], nextCursor: 'cursor-1'),
          ),
        );
        // Never resolves within this test — simulates an in-flight page.
        when(
          () => repository.getOrders(status: null, cursor: 'cursor-1'),
        ).thenAnswer((_) => Completer<Either<Failure, PaginatedResult<Order>>>().future);
      },
      build: build,
      act: (cubit) async {
        await cubit.load();
        // Fire twice without awaiting the first — the second must be a no-op.
        unawaited(cubit.loadMore());
        await cubit.loadMore();
      },
      verify: (_) {
        verify(
          () => repository.getOrders(status: null, cursor: 'cursor-1'),
        ).called(1); // exactly once, not twice
      },
    );

    blocTest<OrdersCubit, OrdersState>(
      'appends the next page to the existing list and advances the cursor',
      setUp: () {
        when(
          () => repository.getOrders(status: null, cursor: null),
        ).thenAnswer(
          (_) async => Right(
            PaginatedResult(items: [_order('a')], nextCursor: 'cursor-1'),
          ),
        );
        when(
          () => repository.getOrders(status: null, cursor: 'cursor-1'),
        ).thenAnswer(
          (_) async =>
              Right(PaginatedResult(items: [_order('b')], nextCursor: null)),
        );
      },
      build: build,
      act: (cubit) async {
        await cubit.load();
        await cubit.loadMore();
      },
      expect: () => [
        const OrdersState.loading(),
        OrdersState.loaded([_order('a')], nextCursor: 'cursor-1'),
        OrdersState.loaded(
          [_order('a')],
          nextCursor: 'cursor-1',
          isLoadingMore: true,
        ),
        OrdersState.loaded([_order('a'), _order('b')], nextCursor: null),
      ],
    );

    blocTest<OrdersCubit, OrdersState>(
      'a failed page leaves the already-loaded orders on screen with loadMoreFailed set (FR-048e)',
      setUp: () {
        when(
          () => repository.getOrders(status: null, cursor: null),
        ).thenAnswer(
          (_) async => Right(
            PaginatedResult(items: [_order('a')], nextCursor: 'cursor-1'),
          ),
        );
        when(
          () => repository.getOrders(status: null, cursor: 'cursor-1'),
        ).thenAnswer((_) async => const Left(Failure.network()));
      },
      build: build,
      act: (cubit) async {
        await cubit.load();
        await cubit.loadMore();
      },
      expect: () => [
        const OrdersState.loading(),
        OrdersState.loaded([_order('a')], nextCursor: 'cursor-1'),
        OrdersState.loaded(
          [_order('a')],
          nextCursor: 'cursor-1',
          isLoadingMore: true,
        ),
        OrdersState.loaded(
          [_order('a')],
          nextCursor: 'cursor-1',
          loadMoreFailed: true,
        ),
      ],
    );
  });

  group('refresh', () {
    blocTest<OrdersCubit, OrdersState>(
      'discards the cursor and reloads page one rather than merging (FR-048g)',
      setUp: () {
        when(
          () => repository.getOrders(status: null, cursor: null),
        ).thenAnswer(
          (_) async => Right(
            PaginatedResult(items: [_order('a')], nextCursor: 'cursor-1'),
          ),
        );
      },
      build: build,
      act: (cubit) async {
        await cubit.load();
        await cubit.refresh();
      },
      verify: (_) {
        // Every call goes through page one (cursor: null) — refresh never
        // supplies the stored cursor.
        verify(
          () => repository.getOrders(status: null, cursor: null),
        ).called(2);
      },
    );
  });

  group('setStatusFilter', () {
    blocTest<OrdersCubit, OrdersState>(
      'reloads from page one under the new filter rather than narrowing loaded pages (FR-048d)',
      setUp: () {
        when(
          () => repository.getOrders(status: null, cursor: null),
        ).thenAnswer(
          (_) async => Right(
            PaginatedResult(items: [_order('a')], nextCursor: 'cursor-1'),
          ),
        );
        when(
          () => repository.getOrders(
            status: OrderStatus.delivered,
            cursor: null,
          ),
        ).thenAnswer(
          (_) async =>
              Right(PaginatedResult(items: [_order('b')], nextCursor: null)),
        );
      },
      build: build,
      act: (cubit) async {
        await cubit.load();
        await cubit.setStatusFilter(OrderStatus.delivered);
      },
      expect: () => [
        const OrdersState.loading(),
        OrdersState.loaded([_order('a')], nextCursor: 'cursor-1'),
        const OrdersState.loading(),
        OrdersState.loaded([_order('b')], nextCursor: null),
      ],
    );
  });
}
