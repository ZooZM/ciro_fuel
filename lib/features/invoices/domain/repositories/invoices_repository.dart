import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/invoice.dart';

abstract interface class InvoicesRepository {
  /// Backend-scoped to the caller (spec 004 T072: a CLIENT sees only their
  /// own invoices, across every payment method) — no further filter needed
  /// for the home dashboard's finance figures.
  Future<Either<Failure, List<Invoice>>> getInvoices();
}
