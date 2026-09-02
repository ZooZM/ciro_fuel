// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['_id'] as String,
  orderId: json['orderId'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  gateway: json['gateway'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  '_id': instance.id,
  'orderId': instance.orderId,
  'amount': instance.amount,
  'currency': instance.currency,
  'gateway': instance.gateway,
  'createdAt': instance.createdAt.toIso8601String(),
};
