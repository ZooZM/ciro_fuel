import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/station.dart';
import '../../domain/repositories/stations_repository.dart';
import '../datasources/stations_remote_data_source.dart';

class StationsRepositoryImpl implements StationsRepository {
  StationsRepositoryImpl(this._remoteDataSource);

  final StationsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<Station>>> getStations() async {
    try {
      return Right(await _remoteDataSource.getStations());
    } on DioException catch (e) {
      return Left(_failureOf(e));
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, Station>> setFavourite(
    String stationId,
    bool isFavourite,
  ) async {
    try {
      return Right(await _remoteDataSource.setFavourite(stationId, isFavourite));
    } on DioException catch (e) {
      return Left(_failureOf(e));
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }

  Failure _failureOf(DioException e) =>
      e.error is Failure ? e.error as Failure : const Failure.server();
}
