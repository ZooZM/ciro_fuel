import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/pricing_config.dart';
import '../repositories/company_pricing_repository.dart';

class GetFuelPrices {
  const GetFuelPrices(this._repository);

  final CompanyPricingRepository _repository;

  Future<Either<Failure, List<FuelPrice>>> call(String companyId) =>
      _repository.getFuelPrices(companyId);
}
