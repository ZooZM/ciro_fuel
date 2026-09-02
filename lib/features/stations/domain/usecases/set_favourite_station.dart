import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/station.dart';
import '../repositories/stations_repository.dart';

class SetFavouriteStation {
  const SetFavouriteStation(this._repository);

  final StationsRepository _repository;

  Future<Either<Failure, Station>> call(
    String stationId,
    bool isFavourite,
  ) => _repository.setFavourite(stationId, isFavourite);
}
