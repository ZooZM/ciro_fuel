import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/notifications_page.dart';

abstract interface class NotificationsRepository {
  Future<Either<Failure, NotificationsPage>> getNotifications({
    bool? unread,
    String? cursor,
  });

  Future<Either<Failure, void>> markRead(String id);

  /// feature 013 US3 (FR-025): marks every notification read for the
  /// calling user in one request, returning how many were transitioned.
  Future<Either<Failure, int>> markAllRead();
}
