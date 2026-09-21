import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/tracking_socket.dart';
import '../../../../shared/enums/order_status.dart';
import '../../domain/usecases/get_orders.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit({required GetOrders getOrders, required TrackingSocket socket})
    : _getOrders = getOrders,
      super(const OrdersState.loading()) {
    // Refresh the list when the platform says an order moved.
    //
    // Hooking the SCREEN's `initState` was not enough: the client's tabs are
    // kept alive, so returning to the orders tab does not remount it and the
    // list went on showing whatever it was built with. The order's own status
    // push is the signal that actually corresponds to "this list is now
    // wrong", and it arrives however the user got here — tab switch, back
    // navigation, or the app simply sitting open.
    //
    // Safe to attach from this lazy singleton's constructor: [TrackingSocket]
    // records handlers in a registry and flushes them onto the socket it
    // builds, so registering before `connect` is the documented path, not a
    // silent no-op.
    socket.onStatus((_) => unawaited(revalidate()));
  }

  final GetOrders _getOrders;
  OrderStatus? _statusFilter;

  /// Guards against a burst. A single approval moves an order three times in
  /// about a second, and three overlapping refreshes could settle in any
  /// order — the last to RESOLVE would win rather than the last to be asked.
  bool _revalidating = false;

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

  /// Refetch page one WITHOUT dropping to [OrdersState.loading] first.
  ///
  /// This cubit is a session-lifetime singleton, and the list screen skipped
  /// reloading on revisit so that navigating back would not throw the list
  /// away and re-fetch it. The cost was that it never noticed anything that
  /// happened elsewhere: place an order, or let one advance a stage, come
  /// back, and the list still showed the state it was built with. Emitting
  /// `loading()` is what the screen was avoiding, not the request — so this
  /// keeps the current items on screen and swaps them once the answer
  /// arrives.
  ///
  /// A failure is deliberately swallowed: the list already on screen is the
  /// last thing the platform actually said, and replacing it with an error
  /// because a background refresh failed would be a downgrade. Pull-to-refresh
  /// remains the explicit path that surfaces failures.
  Future<void> revalidate() async {
    if (state is! OrdersLoaded) return;
    if (_revalidating) return;
    _revalidating = true;
    try {
      final result = await _getOrders(status: _statusFilter);
      if (isClosed) return;
      result.fold(
        (_) {},
        (page) => emit(OrdersState.loaded(page.items, nextCursor: page.nextCursor)),
      );
    } finally {
      _revalidating = false;
    }
  }

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
    _revalidating = false;
    emit(const OrdersState.loading());
  }
}
