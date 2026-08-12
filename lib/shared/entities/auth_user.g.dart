// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStation _$UserStationFromJson(Map<String, dynamic> json) => _UserStation(
  addressText: json['addressText'] as String,
  name: json['name'] as String?,
  location: json['location'] == null
      ? null
      : GeoPoint.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserStationToJson(_UserStation instance) =>
    <String, dynamic>{
      'addressText': instance.addressText,
      'name': instance.name,
      'location': instance.location,
    };

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String,
  role: const UserRoleConverter().fromJson(json['role'] as String),
  companyId: json['companyId'] as String,
  fullName: json['fullName'] as String,
  station: json['station'] == null
      ? null
      : UserStation.fromJson(json['station'] as Map<String, dynamic>),
  creditLimit: (json['creditLimit'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'role': const UserRoleConverter().toJson(instance.role),
  'companyId': instance.companyId,
  'fullName': instance.fullName,
  'station': instance.station,
  'creditLimit': instance.creditLimit,
};
