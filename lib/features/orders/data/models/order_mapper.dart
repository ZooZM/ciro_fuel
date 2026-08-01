import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/order_status.dart';

/// Bridges the backend's `/orders` wire shape to the clean [Order] entity.
/// Prices arrive as decimal SAR amounts (feature 001's fuel pricing is
/// Saudi-market, per clarification); this is the one place that assumption
/// and the amountMinor/decimal conversion live.
abstract final class OrderMapper {
  static Order fromJson(Map<String, Object?> json) => Order(
    id: json['id']! as String,
    status: OrderStatus.fromWire(json['status']! as String),
    fuelType: FuelType.fromWire(json['fuelType']! as String),
    quantityLiters: json['quantityLiters']! as int,
    estimatedPrice: _moneyFromDecimal(json['estimatedPrice']),
    finalPrice: _moneyFromDecimal(json['finalPrice']),
    paymentReference: json['paymentReference'] as String?,
    paymentWindowEndsAt: _dateOrNull(json['paymentWindowEndsAt']),
    assignedDriverId: json['assignedDriverId'] as String?,
    destination: _destinationFromJson(json['deliveryLocation']),
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

  static GeoPoint? _destinationFromJson(Object? value) {
    if (value is! Map) return null;
    final lat = value['lat'];
    final lng = value['lng'];
    if (lat is! num || lng is! num) return null;
    return GeoPoint(lat: lat.toDouble(), lng: lng.toDouble());
  }
}
