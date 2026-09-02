import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

class UpdateFullName {
  const UpdateFullName(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ProfileUser>> call(
    String userId,
    String fullName,
  ) => _repository.updateFullName(userId, fullName);
}
