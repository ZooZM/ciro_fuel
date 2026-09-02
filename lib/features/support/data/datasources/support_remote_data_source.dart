import 'package:dio/dio.dart';

import '../../domain/entities/support_request.dart';
import '../models/support_request_mapper.dart';

/// `POST/GET /support/requests` (spec 005 T119, contracts/rest-api-delta.md
/// §8). The FUEL_COMPANY_ADMIN acknowledge route is web-dashboard
/// territory, not this app's.
abstract interface class SupportRemoteDataSource {
  Future<SupportRequest> createRequest({
    required String topic,
    required String message,
    String? orderId,
  });

  Future<List<SupportRequest>> getRequests();
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  SupportRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<SupportRequest> createRequest({
    required String topic,
    required String message,
    String? orderId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/support/requests',
      data: {
        'topic': topic,
        'message': message,
        if (orderId != null) 'orderId': orderId,
      },
    );
    return SupportRequestMapper.fromJson(response.data!);
  }

  @override
  Future<List<SupportRequest>> getRequests() async {
    final response = await _dio.get<Map<String, dynamic>>('/support/requests');
    final items = response.data!['items'] as List<dynamic>;
    return items.cast<Map<String, dynamic>>().map(SupportRequestMapper.fromJson).toList();
  }
}
