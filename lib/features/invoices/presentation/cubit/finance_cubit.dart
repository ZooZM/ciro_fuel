import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/enums/invoice_state.dart';
import '../../../../shared/enums/payment_method.dart';
import '../../domain/usecases/get_invoices.dart';
import 'finance_state.dart';

/// Drives the home dashboard's finance cards (spec 004 US5/T089) —
/// `pendingInvoiceAmount` and `availableBalanceAmount` are derived here,
/// client-side, from the same two backend facts the server itself uses
/// (`GET /invoices` and the client's own `creditLimit`), never fabricated
/// or hand-typed.
class FinanceCubit extends Cubit<FinanceState> {
  FinanceCubit({required GetInvoices getInvoices})
    : _getInvoices = getInvoices,
      super(const FinanceState.loading());

  final GetInvoices _getInvoices;

  /// [creditLimit] comes from the signed-in client's own profile
  /// (`AuthUser.creditLimit`, `/auth/me`) — null/0 for a client the Fuel
  /// Company has not extended credit to.
  Future<void> load({double? creditLimit}) async {
    emit(const FinanceState.loading());
    final result = await _getInvoices();
    if (isClosed) return;
    result.fold((failure) => emit(FinanceState.failure(failure)), (invoices) {
      // Every ISSUED invoice, any method — what the client currently owes
      // or is on the hook for, awaiting settlement.
      final pending = invoices
          .where((i) => i.state == InvoiceState.issued)
          .fold<double>(0, (sum, i) => sum + i.amount);

      // Mirrors the backend's own derivation exactly (spec 004 FR-024a):
      // creditLimit minus outstanding ISSUED credit invoices — never an
      // independently tracked balance.
      final outstandingCredit = invoices
          .where(
            (i) =>
                i.state == InvoiceState.issued &&
                i.method == PaymentMethod.credit,
          )
          .fold<double>(0, (sum, i) => sum + i.amount);
      final available = (creditLimit ?? 0) - outstandingCredit;

      emit(
        FinanceState.loaded(
          pendingInvoiceAmount: pending,
          availableBalanceAmount: available,
        ),
      );
    });
  }
}
