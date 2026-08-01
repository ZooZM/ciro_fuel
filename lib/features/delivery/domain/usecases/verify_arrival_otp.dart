import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/delivery_repository.dart';

class VerifyArrivalOtp {
  const VerifyArrivalOtp(this._repository);

  final DeliveryRepository _repository;

  Future<Either<Failure, void>> call({
    required String orderId,
    required String otp,
  }) => _repository.verifyArrivalOtp(orderId: orderId, otp: otp);
}
