import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../repositories/orders_repository.dart';

class CreateOrder {
  const CreateOrder(this._repository);

  final OrdersRepository _repository;

  Future<Either<Failure, Order>> call({
    required FuelType fuelType,
    required int quantityLiters,
    GeoPoint? deliveryLocation,
  }) => _repository.createOrder(
    fuelType: fuelType,
    quantityLiters: quantityLiters,
    deliveryLocation: deliveryLocation,
  );
}
