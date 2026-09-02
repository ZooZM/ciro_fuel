import '../../../../shared/entities/value_objects.dart';
import '../../domain/entities/station.dart';

/// Bridges the backend's `Station` wire shape (contracts/rest-api-delta.md
/// §2) to the domain entity — GeoJSON `location.coordinates` (`[lng, lat]`)
/// converted the same way `OrderMapper` handles a destination.
abstract final class StationMapper {
  static Station fromJson(Map<String, Object?> json) => Station(
    id: (json['id'] ?? json['_id'])! as String,
    name: json['name'] as String?,
    regionCode: json['regionCode']! as String,
    governorateCode: json['governorateCode']! as String,
    location: _geoPointFromJson(json['location']),
    addressText: json['addressText'] as String? ?? '',
    isDefault: json['isDefault'] as bool? ?? false,
    isFavourite: json['isFavourite'] as bool? ?? false,
  );

  /// Delegates to [GeoPoint.fromJson], which reads every shape the platform
  /// emits — this used to be a second, independent GeoJSON reader.
  static GeoPoint _geoPointFromJson(Object? value) =>
      GeoPoint.fromJson(value! as Map<String, Object?>);
}
