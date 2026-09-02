// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_standing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriverStanding _$DriverStandingFromJson(Map<String, dynamic> json) =>
    _DriverStanding(
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble(),
      ratingCount: (json['ratingCount'] as num).toInt(),
      deliveriesToday: (json['deliveriesToday'] as num).toInt(),
      readyForWork: json['readyForWork'] as bool,
    );

Map<String, dynamic> _$DriverStandingToJson(_DriverStanding instance) =>
    <String, dynamic>{
      'ratingAverage': instance.ratingAverage,
      'ratingCount': instance.ratingCount,
      'deliveriesToday': instance.deliveriesToday,
      'readyForWork': instance.readyForWork,
    };
