import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';

part 'orders_state.freezed.dart';

@freezed
sealed class OrdersState with _$OrdersState {
  const factory OrdersState.loading() = OrdersLoading;
  const factory OrdersState.loaded(List<Order> orders) = OrdersLoaded;
  const factory OrdersState.failure(Failure failure) = OrdersLoadFailure;
}
