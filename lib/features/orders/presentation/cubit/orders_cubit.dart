import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/enums/order_status.dart';
import '../../domain/usecases/get_orders.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit({required GetOrders getOrders})
    : _getOrders = getOrders,
      super(const OrdersState.loading());

  final GetOrders _getOrders;
  OrderStatus? _statusFilter;

  Future<void> load() async {
    emit(const OrdersState.loading());
    final result = await _getOrders(status: _statusFilter);
    // The screen that owns this cubit can be torn down while the request is
    // still in flight — signing out mid-load is the common case — and emitting
    // on a closed cubit throws.
    if (isClosed) return;
    result.fold(
      (failure) => emit(OrdersState.failure(failure)),
      (page) => emit(OrdersState.loaded(page.items, nextCursor: page.nextCursor)),
    );
  }

  /// Pull-to-refresh: discards the cursor and reloads page one (FR-048g) —
  /// never merges new records into a partially paged view.
  Future<void> refresh() => load();

  /// A no-op when there is no further page, or a load is already in flight
  /// (spec 005 T033) — safe to call from a scroll listener without the
  /// caller having to guard it itself.
  Future<void> loadMore() async {
    final current = state;
    if (current is! OrdersLoaded) return;
    if (current.nextCursor == null) return;
    if (current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true, loadMoreFailed: false));
    final result = await _getOrders(
      status: _statusFilter,
      cursor: current.nextCursor,
    );
    if (isClosed) return;
    result.fold(
      // A failed page leaves every already-loaded order on screen with a
      // retry (FR-048e) — never discards what was already shown.
      (failure) => emit(current.copyWith(isLoadingMore: false, loadMoreFailed: true)),
      (page) => emit(
        OrdersState.loaded(
          [...current.orders, ...page.items],
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  /// Changes the status filter and reloads from page one — a filter change
  /// must never merely narrow the pages already fetched (FR-048d).
  Future<void> setStatusFilter(OrderStatus? status) {
    _statusFilter = status;
    return load();
  }

  /// Resets to the initial loading state — called on sign-out now that this
  /// cubit is a session-lifetime singleton (spec 005 FR-047/T028), so the
  /// next client's first load never briefly shows the previous client's
  /// orders.
  void clear() {
    _statusFilter = null;
    emit(const OrdersState.loading());
  }
}
