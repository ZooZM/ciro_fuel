import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/enums/invoice_state.dart';
import '../../../../shared/enums/payment_method.dart';
import '../../domain/usecases/get_invoices.dart';
import 'invoices_state.dart';

/// Drives the client invoices list screen (spec 005 T078) — mirrors
/// `OrdersCubit` exactly (load/refresh/loadMore/setFilter), the proven
/// pattern for every other cursor-paginated list in the app.
class InvoicesCubit extends Cubit<InvoicesState> {
  InvoicesCubit({required GetInvoices getInvoices})
    : _getInvoices = getInvoices,
      super(const InvoicesState.loading());

  final GetInvoices _getInvoices;
  InvoiceState? _stateFilter;
  PaymentMethod? _methodFilter;

  Future<void> load() async {
    emit(const InvoicesState.loading());
    final result = await _getInvoices(
      method: _methodFilter,
      state: _stateFilter,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(InvoicesState.failure(failure)),
      (page) => emit(InvoicesState.loaded(page.items, nextCursor: page.nextCursor)),
    );
  }

  Future<void> refresh() => load();

  Future<void> loadMore() async {
    final current = state;
    if (current is! InvoicesLoaded) return;
    if (current.nextCursor == null) return;
    if (current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true, loadMoreFailed: false));
    final result = await _getInvoices(
      method: _methodFilter,
      state: _stateFilter,
      cursor: current.nextCursor,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false, loadMoreFailed: true)),
      (page) => emit(
        InvoicesState.loaded(
          [...current.invoices, ...page.items],
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  /// Changes the state filter (the screen's tabs) and reloads from page
  /// one — a filter change must never merely narrow the pages already
  /// fetched (FR-048d).
  Future<void> setStateFilter(InvoiceState? state) {
    _stateFilter = state;
    return load();
  }

  void clear() {
    _stateFilter = null;
    _methodFilter = null;
    emit(const InvoicesState.loading());
  }
}
