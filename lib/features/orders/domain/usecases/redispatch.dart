import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../repositories/orders_repository.dart';

class Redispatch {
  const Redispatch(this._repository);

  final OrdersRepository _repository;

  Future<Either<Failure, Order>> call(String orderId) =>
      _repository.redispatch(orderId);
}
