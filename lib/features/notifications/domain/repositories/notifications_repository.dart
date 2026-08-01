import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_notification.dart';

abstract interface class NotificationsRepository {
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    bool? unread,
  });

  Future<Either<Failure, void>> markRead(String id);
}
