// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
  paymentReference: json['paymentReference'] as String?,
  paymentWindowEndsAt: json['paymentWindowEndsAt'] == null
      ? null
      : DateTime.parse(json['paymentWindowEndsAt'] as String),
  assignedDriverId: json['assignedDriverId'] as String?,
  destination: json['destination'] == null
      ? null
      : GeoPoint.fromJson(json['destination'] as Map<String, dynamic>),
  statusChangedAt: DateTime.parse(json['statusChangedAt'] as String),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'status': const OrderStatusConverter().toJson(instance.status),
  'fuelType': const FuelTypeConverter().toJson(instance.fuelType),
  'quantityLiters': instance.quantityLiters,
  'estimatedPrice': instance.estimatedPrice,
  'finalPrice': instance.finalPrice,
  'paymentReference': instance.paymentReference,
  'paymentWindowEndsAt': instance.paymentWindowEndsAt?.toIso8601String(),
  'assignedDriverId': instance.assignedDriverId,
  'destination': instance.destination,
  'statusChangedAt': instance.statusChangedAt.toIso8601String(),
};
