import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/station.dart';

abstract interface class StationsRepository {
  Future<Either<Failure, List<Station>>> getStations();

  Future<Either<Failure, Station>> setFavourite(String stationId, bool isFavourite);
}
