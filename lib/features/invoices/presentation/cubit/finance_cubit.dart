import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/invoice.dart';
import '../../../../shared/enums/invoice_state.dart';
import '../../domain/usecases/get_credit_standing.dart';
import '../../domain/usecases/get_invoices.dart';
import 'finance_state.dart';

/// Drives the home dashboard's finance cards (spec 004 US5/T089).
/// `pendingInvoiceAmount` is summed from `GET /invoices`; `available` is
/// read directly off `GET /users/me/credit` (spec 005 FR-026/T084) — the
/// same endpoint the dedicated credit-limit screen reads, rather than a
/// second, locally re-derived figure that could disagree with it.
class FinanceCubit extends Cubit<FinanceState> {
  FinanceCubit({
    required GetInvoices getInvoices,
    required GetCreditStanding getCreditStanding,
  }) : _getInvoices = getInvoices,
       _getCreditStanding = getCreditStanding,
       super(const FinanceState.loading());

  final GetInvoices _getInvoices;
  final GetCreditStanding _getCreditStanding;

  /// `GET /invoices` is paginated (spec 005 FR-048f); a dashboard total has
  /// to see every invoice regardless, so this walks every page rather than
  /// exposing pagination state to callers — a client's own invoice count is
  /// small enough that a few extra requests here is the right trade against
  /// a second, parallel "give me everything" endpoint.
  Future<Either<Failure, List<Invoice>>> _loadAllInvoices() async {
    final invoices = <Invoice>[];
    String? cursor;
    do {
      final result = await _getInvoices(cursor: cursor);
      final failure = result.fold((f) => f, (_) => null);
      if (failure != null) return Left(failure);
      final page = result.fold((_) => null, (p) => p)!;
      invoices.addAll(page.items);
      cursor = page.nextCursor;
    } while (cursor != null);
    return Right(invoices);
  }

  Future<void> load() async {
    emit(const FinanceState.loading());
    final invoicesResult = await _loadAllInvoices();
    if (isClosed) return;
    final invoicesFailure = invoicesResult.fold((f) => f, (_) => null);
    if (invoicesFailure != null) {
      emit(FinanceState.failure(invoicesFailure));
      return;
    }
    final invoices = invoicesResult.fold((_) => null, (i) => i)!;

    final creditResult = await _getCreditStanding();
    if (isClosed) return;
    final creditFailure = creditResult.fold((f) => f, (_) => null);
    if (creditFailure != null) {
      emit(FinanceState.failure(creditFailure));
      return;
    }
    final standing = creditResult.fold((_) => null, (s) => s)!;

    // Every ISSUED invoice, any method — what the client currently owes or
    // is on the hook for, awaiting settlement.
    final pending = invoices
        .where((i) => i.state == InvoiceState.issued)
        .fold<double>(0, (sum, i) => sum + i.amount);

    emit(
      FinanceState.loaded(
        pendingInvoiceAmount: pending,
        // Null — never coerced to 0 — when the client has no credit
        // facility at all (FR-027); the dashboard card renders that
        // distinctly rather than showing "0 available".
        availableBalanceAmount: standing.available,
      ),
    );
  }

  /// Resets to the initial loading state — called on sign-out now that this
  /// cubit is a session-lifetime singleton (spec 005 FR-047/T028), so the
  /// next client's first load never briefly shows the previous client's
  /// balances.
  void clear() => emit(const FinanceState.loading());
}
