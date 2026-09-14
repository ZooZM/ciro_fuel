import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../repositories/orders_repository.dart';

/// The station owner confirms the final total once the order has been routed
/// and the haul priced.
///
/// The delivery leg is priced by the transport company that performs it, and
/// that company is not chosen until the fuel company routes the order — so the
/// total the customer is asked to agree to does not exist when they place it.
/// They are notified when it does, review it, and either confirm here or refuse
/// by cancelling.
///
/// DEFERRED and CREDIT orders only. A DIRECT order is confirmed by PAYING it,
/// through the existing gateway flow; the platform refuses this call for one
/// rather than offering a second, cheaper way past the same gate.
class AcceptFinalPrice {
  const AcceptFinalPrice(this._repository);

  final OrdersRepository _repository;

  Future<Either<Failure, Order>> call(String orderId) =>
      _repository.acceptFinalPrice(orderId);
}
