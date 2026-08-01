import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/otp_challenge.dart';
import '../repositories/orders_repository.dart';

class GetCurrentOtp {
  const GetCurrentOtp(this._repository);

  final OrdersRepository _repository;

  Future<Either<Failure, OtpChallenge>> call(String orderId) =>
      _repository.getCurrentOtp(orderId);
}
