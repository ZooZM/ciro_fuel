// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_breakdown.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quote _$QuoteFromJson(Map<String, dynamic> json) => _Quote(
  breakdown: PriceBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>),
  quoteToken: json['quoteToken'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$QuoteToJson(_Quote instance) => <String, dynamic>{
  'breakdown': instance.breakdown,
  'quoteToken': instance.quoteToken,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
