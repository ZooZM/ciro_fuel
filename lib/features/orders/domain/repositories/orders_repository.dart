import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../entities/otp_challenge.dart';

abstract interface class OrdersRepository {
  Future<Either<Failure, Order>> createOrder({
    required FuelType fuelType,
    required int quantityLiters,
    GeoPoint? deliveryLocation,
  });

  Future<Either<Failure, List<Order>>> getOrders({int page = 1});

  Future<Either<Failure, Order>> getOrder(String orderId);

  Future<Either<Failure, OtpChallenge>> getCurrentOtp(String orderId);

  Future<Either<Failure, Order>> cancelOrder(String orderId);

  Future<Either<Failure, Order>> redispatch(String orderId);
}
