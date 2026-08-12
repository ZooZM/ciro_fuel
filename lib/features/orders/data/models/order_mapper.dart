import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../../shared/enums/payment_method.dart';

/// Bridges the backend's `/orders` wire shape to the clean [Order] entity.
/// Prices arrive as decimal SAR amounts (feature 001's fuel pricing is
/// Saudi-market, per clarification); this is the one place that assumption
/// and the amountMinor/decimal conversion live.
abstract final class OrderMapper {
  static Order fromJson(Map<String, Object?> json) => Order(
    // Mongo serialises its primary key as `_id`; `id` is accepted too so a
    // future serializer change (or a hand-written fixture) keeps working.
    id: (json['_id'] ?? json['id'])! as String,
    status: OrderStatus.fromWire(json['status']! as String),
    fuelType: FuelType.fromWire(json['fuelType']! as String),
    quantityLiters: json['quantityLiters']! as int,
    estimatedPrice: _moneyFromDecimal(json['estimatedPrice']),
    finalPrice: _moneyFromDecimal(json['finalPrice']),
    paymentMethod: json['paymentMethod'] != null
        ? PaymentMethod.fromWire(json['paymentMethod']! as String)
        : null,
    invoiceId: json['invoiceId'] as String?,
    paymentDeadline: _dateOrNull(json['paymentDeadline']),
    driverId: json['driverId'] as String?,
    driverSummary: _driverSummaryFromJson(json['driverSummary']),
    etaMinutes: json['etaMinutes'] as int?,
    destination: _destinationFromJson(json['deliveryLocation']),
    deliveryAddressText: json['deliveryAddressText'] as String?,
    statusChangedAt: DateTime.parse(
      (json['statusChangedAt'] ?? json['updatedAt']) as String,
    ),
  );

  static Money? _moneyFromDecimal(Object? value) {
    if (value == null) return null;
    final amount = (value as num).toDouble();
    return Money(amountMinor: (amount * 100).round(), currency: 'SAR');
  }

  static DateTime? _dateOrNull(Object? value) =>
      value == null ? null : DateTime.parse(value as String);

  static DriverSummary? _driverSummaryFromJson(Object? value) {
    if (value is! Map) return null;
    final fullName = value['fullName'];
    final phone = value['phone'];
    final plateNumber = value['plateNumber'];
    if (fullName is! String || phone is! String || plateNumber is! String) {
      return null;
    }
    return DriverSummary(
      fullName: fullName,
      phone: phone,
      plateNumber: plateNumber,
    );
  }

  /// The backend stores locations as GeoJSON — `{type: 'Point', coordinates:
  /// [longitude, latitude]}`, longitude FIRST per the spec. A plain
  /// `{lat, lng}` map is still accepted for fixtures and any endpoint that
  /// returns the flattened shape.
  static GeoPoint? _destinationFromJson(Object? value) {
    if (value is! Map) return null;

    final coordinates = value['coordinates'];
    if (coordinates is List && coordinates.length >= 2) {
      final lng = coordinates[0];
      final lat = coordinates[1];
      if (lat is! num || lng is! num) return null;
      return GeoPoint(lat: lat.toDouble(), lng: lng.toDouble());
    }

    final lat = value['lat'] ?? value['latitude'];
    final lng = value['lng'] ?? value['longitude'];
    if (lat is! num || lng is! num) return null;
    return GeoPoint(lat: lat.toDouble(), lng: lng.toDouble());
  }
}
