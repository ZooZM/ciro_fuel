import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/password_reset_repository.dart';

class CompletePasswordReset {
  const CompletePasswordReset(this._repository);

  final PasswordResetRepository _repository;

  Future<Either<Failure, void>> call({
    required String resetToken,
    required String newPassword,
  }) => _repository.complete(resetToken: resetToken, newPassword: newPassword);
}
