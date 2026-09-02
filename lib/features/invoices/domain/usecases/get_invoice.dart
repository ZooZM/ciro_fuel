import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/invoice.dart';
import '../repositories/invoices_repository.dart';

class GetInvoice {
  const GetInvoice(this._repository);

  final InvoicesRepository _repository;

  Future<Either<Failure, Invoice>> call(String invoiceId) =>
      _repository.getInvoice(invoiceId);
}
