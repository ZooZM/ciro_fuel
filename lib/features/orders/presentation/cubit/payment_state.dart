import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';

part 'payment_state.freezed.dart';

@freezed
sealed class PaymentState with _$PaymentState {
  const factory PaymentState.idle() = PaymentIdle;
  const factory PaymentState.initiating() = PaymentInitiating;
  const factory PaymentState.awaitingConfirmation() = PaymentAwaitingConfirmation;

  /// Set ONLY on the backend's `order:status → inTransit` push
  /// (research R3/R7) — never asserted locally from the gateway's return.
  const factory PaymentState.confirmed() = PaymentConfirmed;

  const factory PaymentState.windowExpired() = PaymentWindowExpired;
  const factory PaymentState.failure(Failure failure) = PaymentFailureState;
}
