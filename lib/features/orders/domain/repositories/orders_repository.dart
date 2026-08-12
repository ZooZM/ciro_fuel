import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/payment_method.dart';
import '../entities/otp_challenge.dart';

abstract interface class OrdersRepository {
  Future<Either<Failure, Order>> createOrder({
    required FuelType fuelType,
    required int quantityLiters,
    GeoPoint? deliveryLocation,
    PaymentMethod? paymentMethod,
  });

  /// Backend-scoped to the caller and filterable only by [status] — the
  /// `/orders` list endpoint exposes no pagination.
  Future<Either<Failure, List<Order>>> getOrders({OrderStatus? status});

  Future<Either<Failure, Order>> getOrder(String orderId);

  Future<Either<Failure, OtpChallenge>> getCurrentOtp(String orderId);

  Future<Either<Failure, Order>> cancelOrder(String orderId);

  Future<Either<Failure, Order>> redispatch(String orderId);
}
