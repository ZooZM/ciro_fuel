import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../../domain/entities/otp_challenge.dart';

part 'order_detail_state.freezed.dart';

@freezed
sealed class OrderDetailState with _$OrderDetailState {
  const factory OrderDetailState.loading() = OrderDetailLoading;

  /// `activeOtp` is populated only on the CLIENT build, from the `order:otp`
  /// push or a `GET .../otp/current` pull (FR-012).
  const factory OrderDetailState.loaded(Order order, {OtpChallenge? activeOtp}) =
      OrderDetailLoaded;

  const factory OrderDetailState.failure(Failure failure) = OrderDetailFailureState;
}
