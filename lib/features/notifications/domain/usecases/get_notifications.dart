import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_notification.dart';
import '../repositories/notifications_repository.dart';

class GetNotifications {
  const GetNotifications(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, List<AppNotification>>> call({bool? unread}) =>
      _repository.getNotifications(unread: unread);
}
