import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';

part 'orders_state.freezed.dart';

@freezed
sealed class OrdersState with _$OrdersState {
  const factory OrdersState.loading() = OrdersLoading;

  /// [nextCursor] `null` means the end of the list (feature 005, FR-048).
  /// [isLoadingMore] drives the trailing spinner while a further page is in
  /// flight. [loadMoreFailed] is deliberately its own flag rather than
  /// reusing [OrdersLoadFailure] — a failed *next* page must leave every
  /// already-loaded order on screen with a retry (FR-048e), which a
  /// whole-list failure state cannot express.
  const factory OrdersState.loaded(
    List<Order> orders, {
    String? nextCursor,
    @Default(false) bool isLoadingMore,
    @Default(false) bool loadMoreFailed,
  }) = OrdersLoaded;

  const factory OrdersState.failure(Failure failure) = OrdersLoadFailure;
}
