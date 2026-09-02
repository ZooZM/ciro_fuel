import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/datasources/password_reset_remote_data_source.dart';
import '../repositories/password_reset_repository.dart';

class RequestPasswordReset {
  const RequestPasswordReset(this._repository);

  final PasswordResetRepository _repository;

  Future<Either<Failure, PasswordResetRequestResult>> call(String phone) =>
      _repository.requestReset(phone);
}
