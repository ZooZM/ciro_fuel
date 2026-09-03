import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/notifications_repository.dart';

/// feature 013 US3 (FR-025): one call marks every notification read for the
/// signed-in user. Returns the count actually transitioned — a press with
/// nothing unread succeeds with `0`, never an error.
class MarkAllNotificationsRead {
  const MarkAllNotificationsRead(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, int>> call() => _repository.markAllRead();
}
