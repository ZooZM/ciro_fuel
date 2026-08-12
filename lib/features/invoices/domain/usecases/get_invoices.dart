import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/invoice.dart';
import '../repositories/invoices_repository.dart';

class GetInvoices {
  const GetInvoices(this._repository);

  final InvoicesRepository _repository;

  Future<Either<Failure, List<Invoice>>> call() => _repository.getInvoices();
}
