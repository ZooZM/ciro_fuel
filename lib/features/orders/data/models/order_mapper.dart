import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../../shared/enums/payment_method.dart';
import '../../../../shared/enums/tank_material.dart';

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
    clientSummary: _clientSummaryFromJson(json['clientSummary']),
    etaMinutes: json['etaMinutes'] as int?,
    destination: _destinationFromJson(json['deliveryLocation']),
    // Same GeoJSON shape as deliveryLocation, so it reuses the same parser.
    driverLocation: _destinationFromJson(json['driverLocation']),
    stationName: _stationField(json['station'], 'name'),
    stationAddressText: _stationField(json['station'], 'addressText'),
    deliveryAddressText: json['deliveryAddressText'] as String?,
    statusChangedAt: DateTime.parse(
      (json['statusChangedAt'] ?? json['updatedAt']) as String,
    ),
    priceBreakdown: _priceBreakdownFromJson(json['priceBreakdown']),
    rating: _ratingFromJson(json['rating']),
    truckId: json['truckId'] as String?,
    tankSummary: _tankSummaryFromJson(json['tankSummary']),
    warehouseSummary: _warehouseSummaryFromJson(json['warehouseSummary']),
    loadingConfirmedAt: _dateOrNull(json['loadingConfirmedAt']),
    assignmentAcknowledgedAt: _dateOrNull(json['assignmentAcknowledgedAt']),
    vehicleVerified: json['vehicleVerified'] as bool? ?? false,
  );

  static TankSummary? _tankSummaryFromJson(Object? value) {
    if (value is! Map<String, Object?>) return null;
    final code = value['code'];
    final material = value['material'];
    if (code is! String || material is! String) return null;
    return TankSummary(code: code, material: TankMaterial.fromWire(material));
  }

  static WarehouseSummary? _warehouseSummaryFromJson(Object? value) {
    if (value is! Map<String, Object?>) return null;
    final name = value['name'];
    final addressText = value['addressText'];
    final location = value['location'];
    if (name is! String || addressText is! String || location is! Map<String, Object?>) {
      return null;
    }
    return WarehouseSummary(
      name: name,
      addressText: addressText,
      location: GeoPoint.fromJson(location),
    );
  }

  static OrderRating? _ratingFromJson(Object? value) {
    if (value is! Map<String, Object?>) return null;
    final score = value['score'];
    if (score is! int) return null;
    return OrderRating(score: score, review: value['review'] as String?);
  }

  static PriceBreakdown? _priceBreakdownFromJson(Object? value) {
    if (value is! Map<String, Object?>) return null;
    return PriceBreakdown(
      fuelLineTotal: (value['fuelLineTotal']! as num).toDouble(),
      deliveryFee: (value['deliveryFee']! as num).toDouble(),
      serviceFee: (value['serviceFee']! as num).toDouble(),
      tax: (value['tax']! as num).toDouble(),
      total: (value['total']! as num).toDouble(),
      unitPrice: (value['unitPrice']! as num).toDouble(),
      serviceFeePercent: (value['serviceFeePercent']! as num).toDouble(),
      taxRatePercent: (value['taxRatePercent']! as num).toDouble(),
      currency: value['currency']! as String,
    );
  }

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

  static ClientSummary? _clientSummaryFromJson(Object? value) {
    if (value is! Map) return null;
    final fullName = value['fullName'];
    final phone = value['phone'];
    if (fullName is! String || phone is! String) return null;
    return ClientSummary(fullName: fullName, phone: phone);
  }

  /// Reads one string off the embedded station, which `GET /orders/:id`
  /// includes and the list endpoint does not — absent is normal.
  static String? _stationField(Object? station, String key) {
    if (station is! Map<String, dynamic>) return null;
    final value = station[key];
    return value is String && value.isNotEmpty ? value : null;
  }

  /// Nullable wrapper around [GeoPoint.fromJson] — an absent point is
  /// ordinary here (no driver assigned yet), an unreadable one is not, so
  /// only null passes quietly.
  static GeoPoint? _destinationFromJson(Object? value) =>
      value is Map<String, Object?> ? GeoPoint.fromJson(value) : null;
}
