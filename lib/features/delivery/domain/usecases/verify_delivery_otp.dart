import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/delivery_repository.dart';

class VerifyDeliveryOtp {
  const VerifyDeliveryOtp(this._repository);

  final DeliveryRepository _repository;

  Future<Either<Failure, void>> call({
    required String orderId,
    required String otp,
  }) => _repository.verifyDeliveryOtp(orderId: orderId, otp: otp);
}
