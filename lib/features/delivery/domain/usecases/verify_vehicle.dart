import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../core/location/position_reader.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/verification_method.dart';
import '../repositories/delivery_repository.dart';

class VerifyVehicle {
  const VerifyVehicle(this._repository);

  final DeliveryRepository _repository;

  Future<Either<Failure, Order>> call({
    required String orderId,
    required String credential,
    required VerificationMethod method,
    PositionFix? driverLocation,
  }) => _repository.verifyVehicle(
    orderId: orderId,
    credential: credential,
    method: method,
    driverLocation: driverLocation,
  );
}
