// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OtpChallenge _$OtpChallengeFromJson(Map<String, dynamic> json) =>
    _OtpChallenge(
      orderId: json['orderId'] as String,
      purpose: const OtpPurposeConverter().fromJson(json['purpose'] as String),
      code: json['code'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$OtpChallengeToJson(_OtpChallenge instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'purpose': const OtpPurposeConverter().toJson(instance.purpose),
      'code': instance.code,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };
