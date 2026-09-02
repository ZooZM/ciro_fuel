import 'package:dio/dio.dart';

import '../../../../shared/enums/fuel_type.dart';
import '../../domain/entities/pricing_config.dart';

/// The two company-level reads the create-order flow needs — which grades
/// the client's own fuel company sells (FR-010) and its delivery/service/
/// tax configuration plus tanker ladder (FR-011f/FR-017). Scoped to order
/// creation's needs, not a general company-data layer — nothing else on
/// the client app reads company pricing yet.
abstract interface class CompanyPricingRemoteDataSource {
  Future<List<FuelPrice>> getFuelPrices(String companyId);

  /// `null` when the company has no pricing configuration at all — the
  /// 200 response is simply empty in that case (FR-011j is enforced at
  /// quote time, not here; this call itself never fails for it).
  Future<PricingConfig?> getPricingConfig(String companyId);
}

class CompanyPricingRemoteDataSourceImpl implements CompanyPricingRemoteDataSource {
  CompanyPricingRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<FuelPrice>> getFuelPrices(String companyId) async {
    final response = await _dio.get<List<dynamic>>('/companies/$companyId/fuel-prices');
    return response.data!
        .cast<Map<String, dynamic>>()
        .map(
          (json) => FuelPrice(
            fuelType: FuelType.fromWire(json['fuelType']! as String),
            basePricePerLiter: (json['basePricePerLiter']! as num).toDouble(),
          ),
        )
        .toList();
  }

  @override
  Future<PricingConfig?> getPricingConfig(String companyId) async {
    final response = await _dio.get<Map<String, dynamic>?>(
      '/companies/$companyId/pricing-config',
    );
    final data = response.data;
    if (data == null || data.isEmpty) return null;
    return PricingConfig(
      deliveryFee: (data['deliveryFee']! as num).toDouble(),
      serviceFeePercent: (data['serviceFeePercent']! as num).toDouble(),
      taxRatePercent: (data['taxRatePercent']! as num).toDouble(),
      tankerCapacitiesLiters: (data['tankerCapacitiesLiters']! as List<dynamic>)
          .cast<num>()
          .map((n) => n.toInt())
          .toList(),
    );
  }
}
