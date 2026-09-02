import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ProfileUser>> getProfile(String userId) async {
    try {
      return Right(await _remoteDataSource.getProfile(userId));
    } on DioException catch (e) {
      return Left(_failureOf(e));
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, ProfileUser>> updateFullName(
    String userId,
    String fullName,
  ) async {
    try {
      return Right(await _remoteDataSource.updateFullName(userId, fullName));
    } on DioException catch (e) {
      return Left(_failureOf(e));
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, ProfileUser>> uploadProfilePicture(
    String userId,
    String filePath,
  ) async {
    try {
      return Right(
        await _remoteDataSource.uploadProfilePicture(userId, filePath),
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
  Future<Either<Failure, List<int>>> downloadFile(String fileId) async {
    try {
      return Right(await _remoteDataSource.downloadFile(fileId));
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
