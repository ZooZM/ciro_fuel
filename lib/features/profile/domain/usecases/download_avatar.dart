import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/profile_repository.dart';

class DownloadAvatar {
  const DownloadAvatar(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, List<int>>> call(String fileId) =>
      _repository.downloadFile(fileId);
}
