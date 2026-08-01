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

_GeoPoint _$GeoPointFromJson(Map<String, dynamic> json) => _GeoPoint(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
);

Map<String, dynamic> _$GeoPointToJson(_GeoPoint instance) => <String, dynamic>{
  'lat': instance.lat,
  'lng': instance.lng,
};
