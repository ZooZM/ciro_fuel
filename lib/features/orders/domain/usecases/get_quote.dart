import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../entities/price_breakdown.dart';
import '../repositories/orders_repository.dart';

class GetQuote {
  const GetQuote(this._repository);

  final OrdersRepository _repository;

  Future<Either<Failure, Quote>> call({
    required FuelType fuelType,
    required int quantityLiters,
    required String stationId,
  }) => _repository.quote(
    fuelType: fuelType,
    quantityLiters: quantityLiters,
    stationId: stationId,
  );
}
