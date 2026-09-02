import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_invoice.dart';
import 'invoice_detail_state.dart';

/// One instance per screen visit, keyed by `invoiceId` — same lifecycle as
/// `OrderDetailCubit` (spec 005 T078a). An invoice never changes once
/// issued except its own state transition (settle/void), which the client
/// only ever observes by reopening this screen — there is no realtime push
/// for it, unlike an order.
class InvoiceDetailCubit extends Cubit<InvoiceDetailState> {
  InvoiceDetailCubit({required String invoiceId, required GetInvoice getInvoice})
    : _invoiceId = invoiceId,
      _getInvoice = getInvoice,
      super(const InvoiceDetailState.loading());

  final String _invoiceId;
  final GetInvoice _getInvoice;

  Future<void> load() async {
    emit(const InvoiceDetailState.loading());
    final result = await _getInvoice(_invoiceId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(InvoiceDetailState.failure(failure)),
      (invoice) => emit(InvoiceDetailState.loaded(invoice)),
    );
  }
}
