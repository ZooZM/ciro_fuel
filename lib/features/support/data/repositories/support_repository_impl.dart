import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/support_request.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_data_source.dart';

class SupportRepositoryImpl implements SupportRepository {
  SupportRepositoryImpl(this._remoteDataSource);

  final SupportRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, SupportRequest>> createRequest({
    required String topic,
    required String message,
    String? orderId,
  }) async {
    try {
      return Right(
        await _remoteDataSource.createRequest(
          topic: topic,
          message: message,
          orderId: orderId,
        ),
      );
    } on DioException catch (e) {
      return Left(_failureOf(e));
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, List<SupportRequest>>> getRequests() async {
    try {
      return Right(await _remoteDataSource.getRequests());
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
