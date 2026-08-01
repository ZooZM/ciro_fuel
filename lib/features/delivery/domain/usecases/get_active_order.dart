import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../repositories/delivery_repository.dart';

class GetActiveOrder {
  const GetActiveOrder(this._repository);

  final DeliveryRepository _repository;

  Future<Either<Failure, Order?>> call() => _repository.getActiveOrder();
}
