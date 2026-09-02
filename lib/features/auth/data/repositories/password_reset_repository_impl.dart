import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/password_reset_repository.dart';
import '../datasources/password_reset_remote_data_source.dart';

class PasswordResetRepositoryImpl implements PasswordResetRepository {
  PasswordResetRepositoryImpl(this._remoteDataSource);

  final PasswordResetRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PasswordResetRequestResult>> requestReset(String phone) async {
    try {
      return Right(await _remoteDataSource.requestReset(phone));
    } on DioException catch (e) {
      return Left(_failureOf(e));
    }
  }

  @override
  Future<Either<Failure, String>> verifyCode({
    required String phone,
    required String code,
  }) async {
    try {
      return Right(await _remoteDataSource.verifyCode(phone: phone, code: code));
    } on DioException catch (e) {
      return Left(_failureOf(e));
    }
  }

  @override
  Future<Either<Failure, void>> complete({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.complete(resetToken: resetToken, newPassword: newPassword);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_failureOf(e));
    }
  }

  Failure _failureOf(DioException e) =>
      e.error is Failure ? e.error as Failure : const Failure.server();
}
