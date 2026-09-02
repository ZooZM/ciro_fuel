import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile_user.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, ProfileUser>> getProfile(String userId);

  Future<Either<Failure, ProfileUser>> updateFullName(
    String userId,
    String fullName,
  );

  Future<Either<Failure, ProfileUser>> uploadProfilePicture(
    String userId,
    String filePath,
  );

  Future<Either<Failure, List<int>>> downloadFile(String fileId);
}
