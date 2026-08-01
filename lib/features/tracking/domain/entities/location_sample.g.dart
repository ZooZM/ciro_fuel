// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocationSample _$LocationSampleFromJson(Map<String, dynamic> json) =>
    _LocationSample(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      receivedAt: json['receivedAt'] == null
          ? null
          : DateTime.parse(json['receivedAt'] as String),
    );

Map<String, dynamic> _$LocationSampleToJson(_LocationSample instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'receivedAt': instance.receivedAt?.toIso8601String(),
    };
