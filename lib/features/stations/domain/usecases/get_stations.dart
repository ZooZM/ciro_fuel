import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/station.dart';
import '../repositories/stations_repository.dart';

class GetStations {
  const GetStations(this._repository);

  final StationsRepository _repository;

  Future<Either<Failure, List<Station>>> call() => _repository.getStations();
}
