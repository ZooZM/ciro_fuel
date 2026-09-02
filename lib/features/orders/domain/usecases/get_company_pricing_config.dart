import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/pricing_config.dart';
import '../repositories/company_pricing_repository.dart';

class GetCompanyPricingConfig {
  const GetCompanyPricingConfig(this._repository);

  final CompanyPricingRepository _repository;

  Future<Either<Failure, PricingConfig?>> call(String companyId) =>
      _repository.getPricingConfig(companyId);
}
