import 'package:dio/dio.dart';

import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../orders/data/models/order_mapper.dart';

abstract interface class DeliveryRemoteDataSource {
  /// `GET /orders` is auto-scoped to the assigned driver by the backend
  /// (feature 001 REST contract); the single-status filter can't express
  /// "in transit OR unloading" server-side, so the active job is picked
  /// client-side from the driver's order list.
  Future<Order?> getActiveOrder();

  Future<void> markArrived(String orderId);

  Future<void> verifyArrivalOtp({required String orderId, required String otp});

  Future<void> requestDeliveryOtp(String orderId);

  Future<void> verifyDeliveryOtp({required String orderId, required String otp});
}

class DeliveryRemoteDataSourceImpl implements DeliveryRemoteDataSource {
  DeliveryRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Order?> getActiveOrder() async {
    final response = await _dio.get<Map<String, dynamic>>('/orders');
    final items = (response.data!['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(OrderMapper.fromJson);
    for (final order in items) {
      if (order.status == OrderStatus.inTransit ||
          order.status == OrderStatus.unloading) {
        return order;
      }
    }
    return null;
  }

  @override
  Future<void> markArrived(String orderId) =>
      _dio.post<void>('/orders/$orderId/arrive');

  @override
  Future<void> verifyArrivalOtp({
    required String orderId,
    required String otp,
  }) => _dio.post<void>(
    '/orders/$orderId/verify-arrival',
    data: {'otp': otp},
  );

  @override
  Future<void> requestDeliveryOtp(String orderId) =>
      _dio.post<void>('/orders/$orderId/request-delivery-otp');

  @override
  Future<void> verifyDeliveryOtp({
    required String orderId,
    required String otp,
  }) => _dio.post<void>(
    '/orders/$orderId/verify-delivery',
    data: {'otp': otp},
  );
}
