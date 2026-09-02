import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile_user.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  const GetProfile(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ProfileUser>> call(String userId) =>
      _repository.getProfile(userId);
}
