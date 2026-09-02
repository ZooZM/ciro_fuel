import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/phone_verification_repository.dart';

class ConfirmPhoneVerification {
  const ConfirmPhoneVerification(this._repository);

  final PhoneVerificationRepository _repository;

  Future<Either<Failure, void>> call(String code) =>
      _repository.confirmVerification(code);
}
