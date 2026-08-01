import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/delivery_repository.dart';

class RequestDeliveryOtp {
  const RequestDeliveryOtp(this._repository);

  final DeliveryRepository _repository;

  Future<Either<Failure, void>> call(String orderId) =>
      _repository.requestDeliveryOtp(orderId);
}
