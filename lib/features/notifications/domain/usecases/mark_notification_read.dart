import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/notifications_repository.dart';

class MarkNotificationRead {
  const MarkNotificationRead(this._repository);

  final NotificationsRepository _repository;

  Future<Either<Failure, void>> call(String id) => _repository.markRead(id);
}
