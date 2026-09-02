import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/datasources/password_reset_remote_data_source.dart';

abstract interface class PasswordResetRepository {
  Future<Either<Failure, PasswordResetRequestResult>> requestReset(String phone);

  Future<Either<Failure, String>> verifyCode({
    required String phone,
    required String code,
  });

  Future<Either<Failure, void>> complete({
    required String resetToken,
    required String newPassword,
  });
}
