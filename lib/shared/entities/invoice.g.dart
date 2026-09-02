// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Invoice _$InvoiceFromJson(Map<String, dynamic> json) => _Invoice(
  id: json['_id'] as String,
  orderId: json['orderId'] as String,
  amount: (json['amount'] as num).toDouble(),
  method: const PaymentMethodConverter().fromJson(json['method'] as String),
  state: const InvoiceStateConverter().fromJson(json['state'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  settledAt: json['settledAt'] == null
      ? null
      : DateTime.parse(json['settledAt'] as String),
  priceBreakdown: json['priceBreakdown'] == null
      ? null
      : PriceBreakdown.fromJson(json['priceBreakdown'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InvoiceToJson(_Invoice instance) => <String, dynamic>{
  '_id': instance.id,
  'orderId': instance.orderId,
  'amount': instance.amount,
  'method': const PaymentMethodConverter().toJson(instance.method),
  'state': const InvoiceStateConverter().toJson(instance.state),
  'createdAt': instance.createdAt.toIso8601String(),
  'settledAt': instance.settledAt?.toIso8601String(),
  'priceBreakdown': instance.priceBreakdown,
};
