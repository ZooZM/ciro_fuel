import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../shared/entities/invoice.dart';
import '../../../../shared/enums/invoice_state.dart';
import '../../../../shared/enums/payment_method.dart';
import '../entities/credit_standing.dart';

abstract interface class InvoicesRepository {
  /// Backend-scoped to the caller (spec 004 T072: a CLIENT sees only their
  /// own invoices, across every payment method), paginated
  /// outstanding-before-settled then newest-first (spec 005 FR-048f).
  Future<Either<Failure, PaginatedResult<Invoice>>> getInvoices({
    PaymentMethod? method,
    InvoiceState? state,
    String? cursor,
  });

  Future<Either<Failure, Invoice>> getInvoice(String invoiceId);

  Future<Either<Failure, CreditStanding>> getCreditStanding();
}
