import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/entities/value_objects.dart';

part 'station.freezed.dart';

/// A client's own station (spec 005 D2) — the site fuel is delivered *to*.
/// Registered by the client's fuel company; the client selects among them
/// and may mark favourites, but never creates or renames one (FR-036b) —
/// this feature (US2) reads the list only. US8 (T109) extends this same
/// entity/datasource with the write side (favourite) once it lands.
///
/// No generated `fromJson`: the backend's `location` is GeoJSON
/// (`{type, coordinates: [lng, lat]}`), not this entity's flat
/// [GeoPoint] shape — `StationMapper.fromJson` (the datasource) converts
/// it by hand, the same way `OrderMapper` does for an order's destination.
@freezed
abstract class Station with _$Station {
  const factory Station({
    required String id,
    String? name,
    required String regionCode,
    required String governorateCode,
    required GeoPoint location,
    required String addressText,
    required bool isDefault,
    required bool isFavourite,
  }) = _Station;
}
