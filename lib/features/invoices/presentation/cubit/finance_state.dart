import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';

part 'finance_state.freezed.dart';

@freezed
sealed class FinanceState with _$FinanceState {
  const factory FinanceState.loading() = FinanceLoading;
  const factory FinanceState.loaded({
    required double pendingInvoiceAmount,
    required double availableBalanceAmount,
  }) = FinanceLoaded;
  const factory FinanceState.failure(Failure failure) = FinanceLoadFailure;
}
