// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_standing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreditStanding _$CreditStandingFromJson(Map<String, dynamic> json) =>
    _CreditStanding(
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
      consumed: (json['consumed'] as num?)?.toDouble(),
      available: (json['available'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CreditStandingToJson(_CreditStanding instance) =>
    <String, dynamic>{
      'creditLimit': instance.creditLimit,
      'consumed': instance.consumed,
      'available': instance.available,
    };
