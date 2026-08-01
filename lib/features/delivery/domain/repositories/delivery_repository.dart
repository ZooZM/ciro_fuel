import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';

abstract interface class DeliveryRepository {
  Future<Either<Failure, Order?>> getActiveOrder();

  Future<Either<Failure, void>> markArrived(String orderId);

  Future<Either<Failure, void>> verifyArrivalOtp({
    required String orderId,
    required String otp,
  });

  Future<Either<Failure, void>> requestDeliveryOtp(String orderId);

  Future<Either<Failure, void>> verifyDeliveryOtp({
    required String orderId,
    required String otp,
  });
}
