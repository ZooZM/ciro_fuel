import 'package:dio/dio.dart';

import '../../domain/entities/app_notification.dart';

abstract interface class NotificationsRemoteDataSource {
  Future<List<AppNotification>> getNotifications({bool? unread});

  Future<void> markRead(String id);
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  NotificationsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<AppNotification>> getNotifications({bool? unread}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/notifications',
      queryParameters: {'unread': ?unread},
    );
    final items = response.data!['data'] as List<dynamic>;
    return items
        .cast<Map<String, dynamic>>()
        .map(AppNotification.fromJson)
        .toList();
  }

  @override
  Future<void> markRead(String id) =>
      _dio.patch<void>('/notifications/$id/read');
}
