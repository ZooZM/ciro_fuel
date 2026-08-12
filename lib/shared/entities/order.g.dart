// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriverSummary _$DriverSummaryFromJson(Map<String, dynamic> json) =>
    _DriverSummary(
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      plateNumber: json['plateNumber'] as String,
    );

Map<String, dynamic> _$DriverSummaryToJson(_DriverSummary instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phone': instance.phone,
      'plateNumber': instance.plateNumber,
    };

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  status: const OrderStatusConverter().fromJson(json['status'] as String),
  fuelType: const FuelTypeConverter().fromJson(json['fuelType'] as String),
  quantityLiters: (json['quantityLiters'] as num).toInt(),
  estimatedPrice: json['estimatedPrice'] == null
      ? null
      : Money.fromJson(json['estimatedPrice'] as Map<String, dynamic>),
  finalPrice: json['finalPrice'] == null
      ? null
      : Money.fromJson(json['finalPrice'] as Map<String, dynamic>),
  paymentMethod: _$JsonConverterFromJson<String, PaymentMethod>(
    json['paymentMethod'],
    const PaymentMethodConverter().fromJson,
  ),
  invoiceId: json['invoiceId'] as String?,
  paymentDeadline: json['paymentDeadline'] == null
      ? null
      : DateTime.parse(json['paymentDeadline'] as String),
  driverId: json['driverId'] as String?,
  driverSummary: json['driverSummary'] == null
      ? null
      : DriverSummary.fromJson(json['driverSummary'] as Map<String, dynamic>),
  etaMinutes: (json['etaMinutes'] as num?)?.toInt(),
  destination: json['destination'] == null
      ? null
      : GeoPoint.fromJson(json['destination'] as Map<String, dynamic>),
  deliveryAddressText: json['deliveryAddressText'] as String?,
  statusChangedAt: DateTime.parse(json['statusChangedAt'] as String),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'status': const OrderStatusConverter().toJson(instance.status),
  'fuelType': const FuelTypeConverter().toJson(instance.fuelType),
  'quantityLiters': instance.quantityLiters,
  'estimatedPrice': instance.estimatedPrice,
  'finalPrice': instance.finalPrice,
  'paymentMethod': _$JsonConverterToJson<String, PaymentMethod>(
    instance.paymentMethod,
    const PaymentMethodConverter().toJson,
  ),
  'invoiceId': instance.invoiceId,
  'paymentDeadline': instance.paymentDeadline?.toIso8601String(),
  'driverId': instance.driverId,
  'driverSummary': instance.driverSummary,
  'etaMinutes': instance.etaMinutes,
  'destination': instance.destination,
  'deliveryAddressText': instance.deliveryAddressText,
  'statusChangedAt': instance.statusChangedAt.toIso8601String(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
