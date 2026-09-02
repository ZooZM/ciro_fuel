import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_standing.freezed.dart';
part 'driver_standing.g.dart';

/// `GET /drivers/me/summary` (spec 007 FR-028/FR-029/FR-032/FR-034/FR-035)
/// — the header's real data source, replacing the fabricated `4.8`
/// rating and `5` orders-today count. [ratingAverage] is absent (never
/// `0`) until the driver has been rated at least once (FR-031) — that is
/// a distinct state from a real low score, all the way from this entity
/// to the screen.
@freezed
abstract class DriverStanding with _$DriverStanding {
  const factory DriverStanding({
    double? ratingAverage,
    required int ratingCount,
    required int deliveriesToday,
    required bool readyForWork,
  }) = _DriverStanding;

  factory DriverStanding.fromJson(Map<String, Object?> json) =>
      _$DriverStandingFromJson(json);
}
