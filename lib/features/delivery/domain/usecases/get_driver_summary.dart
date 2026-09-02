import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/driver_standing.dart';
import '../repositories/delivery_repository.dart';

class GetDriverSummary {
  const GetDriverSummary(this._repository);

  final DeliveryRepository _repository;

  Future<Either<Failure, DriverStanding>> call() =>
      _repository.getDriverSummary();
}
