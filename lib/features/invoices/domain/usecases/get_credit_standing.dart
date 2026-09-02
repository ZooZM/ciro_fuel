import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/credit_standing.dart';
import '../repositories/invoices_repository.dart';

class GetCreditStanding {
  const GetCreditStanding(this._repository);

  final InvoicesRepository _repository;

  Future<Either<Failure, CreditStanding>> call() =>
      _repository.getCreditStanding();
}
