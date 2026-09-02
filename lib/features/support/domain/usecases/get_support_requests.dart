import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/support_request.dart';
import '../repositories/support_repository.dart';

class GetSupportRequests {
  const GetSupportRequests(this._repository);

  final SupportRepository _repository;

  Future<Either<Failure, List<SupportRequest>>> call() => _repository.getRequests();
}
