import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';

part 'delivery_state.freezed.dart';

@freezed
sealed class DeliveryState with _$DeliveryState {
  const factory DeliveryState.noActiveOrder() = DeliveryNoActiveOrder;

  const factory DeliveryState.active(
    Order order, {
    @Default(false) bool streaming,
  }) = DeliveryActive;

  const factory DeliveryState.failure(Failure failure) = DeliveryFailureState;
}
