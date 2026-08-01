import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class RestoreSession {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthUser>> call() => _repository.restoreSession();
}
