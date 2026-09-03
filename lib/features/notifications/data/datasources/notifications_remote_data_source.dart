import 'package:dio/dio.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notifications_page.dart';

abstract interface class NotificationsRemoteDataSource {
  Future<NotificationsPage> getNotifications({bool? unread, String? cursor});

  Future<void> markRead(String id);

  /// Returns the count actually marked read (`{ updated }`).
  Future<int> markAllRead();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  NotificationsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<NotificationsPage> getNotifications({
    bool? unread,
    String? cursor,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/notifications',
      queryParameters: {'unread': ?unread, if (cursor != null) 'cursor': cursor},
    );
    final data = response.data!;
    final items = (data['items'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(AppNotification.fromJson)
        .toList();
    return NotificationsPage(
      items: items,
      nextCursor: data['nextCursor'] as String?,
      unreadCount: data['unreadCount']! as int,
    );
  }

  @override
  Future<void> markRead(String id) =>
      _dio.patch<void>('/notifications/$id/read');

  @override
  Future<int> markAllRead() async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/notifications/read-all',
    );
    return (response.data?['updated'] as int?) ?? 0;
  }
}
