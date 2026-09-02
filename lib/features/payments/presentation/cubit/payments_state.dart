import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/payment.dart';

part 'payments_state.freezed.dart';

@freezed
sealed class PaymentsState with _$PaymentsState {
  const factory PaymentsState.loading() = PaymentsLoading;

  const factory PaymentsState.loaded(
    List<Payment> payments, {
    String? nextCursor,
    @Default(false) bool isLoadingMore,
    @Default(false) bool loadMoreFailed,
  }) = PaymentsLoaded;

  const factory PaymentsState.failure(Failure failure) = PaymentsLoadFailure;
}
