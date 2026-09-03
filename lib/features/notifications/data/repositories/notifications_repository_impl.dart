import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/notifications_page.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remoteDataSource);

  final NotificationsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, NotificationsPage>> getNotifications({
    bool? unread,
    String? cursor,
  }) => _guard(
    () => _remoteDataSource.getNotifications(unread: unread, cursor: cursor),
  );

  @override
  Future<Either<Failure, void>> markRead(String id) =>
      _guard(() => _remoteDataSource.markRead(id));

  @override
  Future<Either<Failure, int>> markAllRead() =>
      _guard(_remoteDataSource.markAllRead);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(
        e.error is Failure ? e.error as Failure : const Failure.server(),
      );
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }
}
