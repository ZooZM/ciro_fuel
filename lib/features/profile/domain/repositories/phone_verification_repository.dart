import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/phone_verification_request.dart';

abstract interface class PhoneVerificationRepository {
  Future<Either<Failure, PhoneVerificationRequest>> requestVerification(
    String newPhone,
  );

  Future<Either<Failure, void>> confirmVerification(String code);
}
