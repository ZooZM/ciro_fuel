import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/value_objects.dart';
import '../repositories/orders_repository.dart';

/// The road-following path from the driver to the delivery destination.
///
/// Returns an empty list — not a failure — when the platform has no route to
/// give (no driver, no reported position, or Directions unavailable). The
/// tracking map then draws a direct line, which reads honestly as an
/// approximation rather than a driven path.
class GetDrivingRoute {
  const GetDrivingRoute(this._repository);

  final OrdersRepository _repository;

  Future<Either<Failure, List<GeoPoint>>> call(String orderId) =>
      _repository.getDrivingRoute(orderId);
}
