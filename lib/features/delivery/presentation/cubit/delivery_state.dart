import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';

part 'delivery_state.freezed.dart';

@freezed
sealed class DeliveryState with _$DeliveryState {
  /// The cubit's own initial state, and re-entered at the start of every
  /// `load()` (spec 007 FR-004/FR-032/FR-044): "still loading" must never
  /// render identically to "confirmed, nothing assigned" — before this
  /// state existed, both were [DeliveryNoActiveOrder], which is exactly
  /// the collapse those requirements forbid.
  const factory DeliveryState.loading() = DeliveryLoading;

  const factory DeliveryState.noActiveOrder() = DeliveryNoActiveOrder;

  const factory DeliveryState.active(
    Order order, {
    @Default(false) bool streaming,
  }) = DeliveryActive;

  const factory DeliveryState.failure(Failure failure) = DeliveryFailureState;
}
