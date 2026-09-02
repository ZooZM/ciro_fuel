import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/payment_method.dart';
import '../repositories/orders_repository.dart';

class CreateOrder {
  const CreateOrder(this._repository);

  final OrdersRepository _repository;

  /// [paymentMethod] defaults to DIRECT backend-side when omitted (spec 004
  /// FR-021) — passed explicitly once the create-order form has a selector.
  /// [stationId]/[quoteToken] (spec 005 US2) commit the order to the
  /// itemised price the client was quoted — always supplied together by the
  /// real create-order flow (T063).
  Future<Either<Failure, Order>> call({
    required FuelType fuelType,
    required int quantityLiters,
    GeoPoint? deliveryLocation,
    PaymentMethod? paymentMethod,
    String? stationId,
    String? quoteToken,
  }) => _repository.createOrder(
    fuelType: fuelType,
    quantityLiters: quantityLiters,
    deliveryLocation: deliveryLocation,
    paymentMethod: paymentMethod,
    stationId: stationId,
    quoteToken: quoteToken,
  );
}
