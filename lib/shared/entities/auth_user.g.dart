// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String,
  role: const UserRoleConverter().fromJson(json['role'] as String),
  companyId: json['companyId'] as String,
  fullName: json['fullName'] as String,
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'role': const UserRoleConverter().toJson(instance.role),
  'companyId': instance.companyId,
  'fullName': instance.fullName,
};
