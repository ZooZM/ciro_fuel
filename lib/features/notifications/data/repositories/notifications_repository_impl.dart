import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remoteDataSource);

  final NotificationsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    bool? unread,
  }) => _guard(() => _remoteDataSource.getNotifications(unread: unread));

  @override
  Future<Either<Failure, void>> markRead(String id) =>
      _guard(() => _remoteDataSource.markRead(id));

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(e.error is Failure ? e.error as Failure : const Failure.server());
    }
  }
}
