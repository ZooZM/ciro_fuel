import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/password_reset_repository.dart';

class VerifyResetCode {
  const VerifyResetCode(this._repository);

  final PasswordResetRepository _repository;

  /// Returns the opaque `resetToken` [CompletePasswordReset] needs.
  Future<Either<Failure, String>> call({
    required String phone,
    required String code,
  }) => _repository.verifyCode(phone: phone, code: code);
}
