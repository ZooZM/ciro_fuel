import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/network/paginated_response.dart';
import 'package:mobile_app/features/delivery/presentation/view/driver_orders_screen.dart';
import 'package:mobile_app/features/orders/domain/repositories/orders_repository.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_orders.dart';
import 'package:mobile_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mobile_app/features/orders/presentation/cubit/orders_state.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';

import '../helpers/localized_harness.dart';
import '../support/orders_test_di.dart';

/// A cursor-paginated `GET /orders` fake — unlike `FakeOrdersRepository`
/// (support/orders_test_di.dart), which always returns everything on one
/// page, this actually slices, so `loadMore()`'s cursor handling has
/// something real to walk (spec 007 T050/FR-021).
class _PagedOrdersRepository implements OrdersRepository {
  _PagedOrdersRepository(this._orders, {this.pageSize = 5});

  final List<Order> _orders;
  final int pageSize;

  @override
  Future<Either<Failure, PaginatedResult<Order>>> getOrders({
    OrderStatus? status,
    String? cursor,
  }) async {
    final matching = status == null
        ? _orders
        : _orders.where((o) => o.status == status).toList();
    final start = cursor == null ? 0 : int.parse(cursor);
    final end = (start + pageSize).clamp(0, matching.length);
    final page = matching.sublist(start, end);
    return Right(
      PaginatedResult(
        items: page,
        nextCursor: end < matching.length ? '$end' : null,
      ),
    );
  }

  @override
  Never noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not faked');
}

/// spec 007 T050 (FR-020a/FR-021/FR-022): only this driver's own deliveries
/// ever reach the screen (the repository fake stands in for `GET /orders`,
/// already server-scoped to `driverId` per the backend contract); paging
/// through every page adds no duplicate and skips no order; the empty
/// state renders when the driver has none.
void main() {
  tearDown(resetOrdersTestDi);

  List<Order> ordersSpanning(int count) => [
    for (var i = 0; i < count; i++)
      Order(
        id: 'order-${i.toString().padLeft(3, '0')}',
        status: OrderStatus.delivered,
        fuelType: FuelType.diesel,
        quantityLiters: 100 + i,
        statusChangedAt: DateTime.utc(2026, 1, 1).add(Duration(days: i)),
      ),
  ];

  testWidgets('loading every page adds no duplicates and skips nothing', (tester) async {
    registerOrdersTestDi(); // base DI (notifications/session/etc.)
    final repository = _PagedOrdersRepository(ordersSpanning(12), pageSize: 5);
    getIt.unregister<OrdersCubit>();
    getIt.registerLazySingleton(
      () => OrdersCubit(getOrders: GetOrders(repository)),
    );

    await pumpLocalized(tester, const DriverOrdersScreen(), locale: const Locale('en'));
    await tester.pump();
    await tester.pump();

    final cubit = getIt<OrdersCubit>();
    // Drives the same `loadMore()` the screen's scroll listener calls —
    // exercising the cursor walk without fighting scroll-gesture physics.
    while (true) {
      final state = cubit.state;
      if (state is! OrdersLoaded || state.nextCursor == null) break;
      await cubit.loadMore();
      await tester.pump();
    }

    final finalState = cubit.state as OrdersLoaded;
    final ids = finalState.orders.map((o) => o.id).toList();
    expect(ids.length, 12);
    expect(ids.toSet().length, 12); // no duplicates
    expect(ids, containsAll(ordersSpanning(12).map((o) => o.id)));
  });

  testWidgets('an explicit empty state renders when the driver has no deliveries', (
    tester,
  ) async {
    registerOrdersTestDi(orders: const []);

    await pumpLocalized(tester, const DriverOrdersScreen(), locale: const Locale('en'));
    await tester.pump();
    await tester.pump();

    expect(find.text('No deliveries yet.'), findsOneWidget);
  });
}
