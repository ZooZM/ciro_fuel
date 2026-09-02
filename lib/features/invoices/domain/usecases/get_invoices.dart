import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../shared/entities/invoice.dart';
import '../../../../shared/enums/invoice_state.dart';
import '../../../../shared/enums/payment_method.dart';
import '../repositories/invoices_repository.dart';

class GetInvoices {
  const GetInvoices(this._repository);

  final InvoicesRepository _repository;

  Future<Either<Failure, PaginatedResult<Invoice>>> call({
    PaymentMethod? method,
    InvoiceState? state,
    String? cursor,
  }) => _repository.getInvoices(method: method, state: state, cursor: cursor);
}
