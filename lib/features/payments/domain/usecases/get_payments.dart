import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/paginated_response.dart';
import '../entities/payment.dart';
import '../repositories/payments_repository.dart';

class GetPayments {
  const GetPayments(this._repository);

  final PaymentsRepository _repository;

  Future<Either<Failure, PaginatedResult<Payment>>> call({String? cursor}) =>
      _repository.getPayments(cursor: cursor);
}
