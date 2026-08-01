// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      type: const NotificationTypeConverter().fromJson(json['type'] as String),
      orderId: json['orderId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': const NotificationTypeConverter().toJson(instance.type),
      'orderId': instance.orderId,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
    };
