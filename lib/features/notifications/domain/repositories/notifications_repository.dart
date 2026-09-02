import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/notifications_page.dart';

abstract interface class NotificationsRepository {
  Future<Either<Failure, NotificationsPage>> getNotifications({
    bool? unread,
    String? cursor,
  });

  Future<Either<Failure, void>> markRead(String id);
}
