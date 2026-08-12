import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_orders.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit({required GetOrders getOrders})
    : _getOrders = getOrders,
      super(const OrdersState.loading());

  final GetOrders _getOrders;

  Future<void> load() async {
    emit(const OrdersState.loading());
    final result = await _getOrders();
    // The screen that owns this cubit can be torn down while the request is
    // still in flight — signing out mid-load is the common case — and emitting
    // on a closed cubit throws.
    if (isClosed) return;
    result.fold(
      (failure) => emit(OrdersState.failure(failure)),
      (orders) => emit(OrdersState.loaded(orders)),
    );
  }
}
