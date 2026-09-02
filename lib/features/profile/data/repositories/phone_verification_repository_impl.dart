import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/phone_verification_request.dart';
import '../../domain/repositories/phone_verification_repository.dart';
import '../datasources/phone_verification_remote_data_source.dart';

class PhoneVerificationRepositoryImpl implements PhoneVerificationRepository {
  PhoneVerificationRepositoryImpl(this._remoteDataSource);

  final PhoneVerificationRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PhoneVerificationRequest>> requestVerification(
    String newPhone,
  ) async {
    try {
      return Right(await _remoteDataSource.requestVerification(newPhone));
    } on DioException catch (e) {
      return Left(_failureOf(e));
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, void>> confirmVerification(String code) async {
    try {
      await _remoteDataSource.confirmVerification(code);
      return const Right(null);
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
