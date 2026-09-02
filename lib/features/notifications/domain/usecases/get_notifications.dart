import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/notifications_page.dart';
import '../repositories/notifications_repository.dart';

class GetNotifications {
  const GetNotifications(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, NotificationsPage>> call({
    bool? unread,
    String? cursor,
  }) => _repository.getNotifications(unread: unread, cursor: cursor);
}
