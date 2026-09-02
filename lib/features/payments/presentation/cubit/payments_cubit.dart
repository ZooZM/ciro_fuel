import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_payments.dart';
import 'payments_state.dart';

/// Drives the client payments-history screen (spec 005 US4/T076) — mirrors
/// `OrdersCubit`/`InvoicesCubit`.
class PaymentsCubit extends Cubit<PaymentsState> {
  PaymentsCubit({required GetPayments getPayments})
    : _getPayments = getPayments,
      super(const PaymentsState.loading());

  final GetPayments _getPayments;

  Future<void> load() async {
    emit(const PaymentsState.loading());
    final result = await _getPayments();
    if (isClosed) return;
    result.fold(
      (failure) => emit(PaymentsState.failure(failure)),
      (page) => emit(PaymentsState.loaded(page.items, nextCursor: page.nextCursor)),
    );
  }

  Future<void> refresh() => load();

  Future<void> loadMore() async {
    final current = state;
    if (current is! PaymentsLoaded) return;
    if (current.nextCursor == null) return;
    if (current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true, loadMoreFailed: false));
    final result = await _getPayments(cursor: current.nextCursor);
    if (isClosed) return;
    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false, loadMoreFailed: true)),
      (page) => emit(
        PaymentsState.loaded(
          [...current.payments, ...page.items],
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  void clear() => emit(const PaymentsState.loading());
}
