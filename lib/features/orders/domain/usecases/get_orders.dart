import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../repositories/orders_repository.dart';

class GetOrders {
  const GetOrders(this._repository);

  final OrdersRepository _repository;

  Future<Either<Failure, List<Order>>> call({int page = 1}) =>
      _repository.getOrders(page: page);
}
