import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_objects.freezed.dart';
part 'value_objects.g.dart';

@freezed
abstract class Money with _$Money {
  const factory Money({required int amountMinor, required String currency}) =
      _Money;

  factory Money.fromJson(Map<String, Object?> json) => _$MoneyFromJson(json);
}

@freezed
abstract class GeoPoint with _$GeoPoint {
  const factory GeoPoint({required double lat, required double lng}) =
      _GeoPoint;

  /// Accepts every shape the platform emits a point in, because it emits
  /// more than one and always has:
  ///
  /// * `{type: 'Point', coordinates: [lng, lat]}` — GeoJSON, straight out of
  ///   Mongo. **Longitude first**, which is the trap: read positionally and
  ///   the point lands in the wrong hemisphere rather than failing loudly.
  ///   This is what `deliveryLocation`, `driverLocation`, `station.location`
  ///   and `user.station.location` all arrive as.
  /// * `{lat, lng}` — the app's own shape, used by fixtures and tests.
  /// * `{latitude, longitude}` — the REST DTO spelling.
  ///
  /// Hand-written rather than generated: `_$GeoPointFromJson` reads `lat`
  /// and `lng` only, so every generated caller (`Order.fromJson`,
  /// `AuthUser.fromJson`) threw a null-cast on real GeoJSON. It was being
  /// worked around per-mapper, which meant each new call site rediscovered
  /// the same crash. One parser here ends that.
  ///
  /// Throws [FormatException] on a shape it cannot read — a point that
  /// silently defaults to (0, 0) is the Gulf of Guinea, not an error the
  /// caller would ever notice.
  factory GeoPoint.fromJson(Map<String, Object?> json) {
    final coordinates = json['coordinates'];
    if (coordinates is List && coordinates.length >= 2) {
      final lng = coordinates[0];
      final lat = coordinates[1];
      if (lat is num && lng is num) {
        return GeoPoint(lat: lat.toDouble(), lng: lng.toDouble());
      }
    }

    final lat = json['lat'] ?? json['latitude'];
    final lng = json['lng'] ?? json['longitude'];
    if (lat is num && lng is num) {
      return GeoPoint(lat: lat.toDouble(), lng: lng.toDouble());
    }

    throw FormatException('Unrecognised GeoPoint shape: ${json.keys.toList()}');
  }
}

/// The itemised cost of an order or invoice (spec 005 D3/FR-011a) — every
/// figure is the platform's own; the app never computes, infers or
/// apportions any component itself (FR-011b). Shared between [Order] and
/// the create-order [Quote] flow (`features/orders/domain/entities/
/// price_breakdown.dart`) — an order's breakdown and the quote that priced
/// it are the same shape.
@freezed
abstract class PriceBreakdown with _$PriceBreakdown {
  const factory PriceBreakdown({
    required double fuelLineTotal,
    required double deliveryFee,
    required double serviceFee,
    required double tax,
    required double total,
    required double unitPrice,
    required double serviceFeePercent,
    required double taxRatePercent,
    required String currency,
  }) = _PriceBreakdown;

  factory PriceBreakdown.fromJson(Map<String, Object?> json) =>
      _$PriceBreakdownFromJson(json);
}
