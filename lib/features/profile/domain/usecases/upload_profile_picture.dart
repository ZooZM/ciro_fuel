import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

class UploadProfilePicture {
  const UploadProfilePicture(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ProfileUser>> call(
    String userId,
    String filePath,
  ) => _repository.uploadProfilePicture(userId, filePath);
}
