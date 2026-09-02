import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/phone_verification_request.dart';
import '../repositories/phone_verification_repository.dart';

class RequestPhoneVerification {
  const RequestPhoneVerification(this._repository);

  final PhoneVerificationRepository _repository;

  Future<Either<Failure, PhoneVerificationRequest>> call(String newPhone) =>
      _repository.requestVerification(newPhone);
}
