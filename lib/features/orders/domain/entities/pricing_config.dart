import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/enums/fuel_type.dart';

part 'pricing_config.freezed.dart';

/// One fuel grade's current price (`GET /companies/:id/fuel-prices`).
@freezed
abstract class FuelPrice with _$FuelPrice {
  const factory FuelPrice({
    required FuelType fuelType,
    required double basePricePerLiter,
  }) = _FuelPrice;
}

/// The client's fuel company's delivery fee, service fee and tax rate,
/// plus the tanker capacities it sells in (spec 005 D3/FR-017) —
/// `GET /companies/:id/pricing-config`. `null` fields mean the company
/// hasn't configured pricing yet (FR-011j) — the app must say so, not
/// derive a quote from a default.
@freezed
abstract class PricingConfig with _$PricingConfig {
  const factory PricingConfig({
    required double deliveryFee,
    required double serviceFeePercent,
    required double taxRatePercent,
    required List<int> tankerCapacitiesLiters,
  }) = _PricingConfig;
}
