import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/pricing_config.dart';

abstract interface class CompanyPricingRepository {
  Future<Either<Failure, List<FuelPrice>>> getFuelPrices(String companyId);

  Future<Either<Failure, PricingConfig?>> getPricingConfig(String companyId);
}
