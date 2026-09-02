import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/order_status.dart';
import '../repositories/orders_repository.dart';

class GetOrders {
  const GetOrders(this._repository);

  final OrdersRepository _repository;

  Future<Either<Failure, PaginatedResult<Order>>> call({
    OrderStatus? status,
    String? cursor,
  }) => _repository.getOrders(status: status, cursor: cursor);
}
