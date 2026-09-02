// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'value_objects.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Money _$MoneyFromJson(Map<String, dynamic> json) => _Money(
  amountMinor: (json['amountMinor'] as num).toInt(),
  currency: json['currency'] as String,
);

Map<String, dynamic> _$MoneyToJson(_Money instance) => <String, dynamic>{
  'amountMinor': instance.amountMinor,
  'currency': instance.currency,
};

_PriceBreakdown _$PriceBreakdownFromJson(Map<String, dynamic> json) =>
    _PriceBreakdown(
      fuelLineTotal: (json['fuelLineTotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      serviceFeePercent: (json['serviceFeePercent'] as num).toDouble(),
      taxRatePercent: (json['taxRatePercent'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$PriceBreakdownToJson(_PriceBreakdown instance) =>
    <String, dynamic>{
      'fuelLineTotal': instance.fuelLineTotal,
      'deliveryFee': instance.deliveryFee,
      'serviceFee': instance.serviceFee,
      'tax': instance.tax,
      'total': instance.total,
      'unitPrice': instance.unitPrice,
      'serviceFeePercent': instance.serviceFeePercent,
      'taxRatePercent': instance.taxRatePercent,
      'currency': instance.currency,
    };
