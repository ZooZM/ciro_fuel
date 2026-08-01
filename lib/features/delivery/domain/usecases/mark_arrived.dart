import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/delivery_repository.dart';

class MarkArrived {
  const MarkArrived(this._repository);

  final DeliveryRepository _repository;

  Future<Either<Failure, void>> call(String orderId) =>
      _repository.markArrived(orderId);
}
