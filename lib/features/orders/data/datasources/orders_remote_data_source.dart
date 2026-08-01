import 'package:dio/dio.dart';

import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/otp_purpose.dart';
import '../../domain/entities/otp_challenge.dart';
import '../models/order_mapper.dart';

/// No `/orders/:id/pay` endpoint exists (research R3) — payment is
/// native-SDK-initiated; this datasource never asserts payment confirmation,
/// only observes order state.
abstract interface class OrdersRemoteDataSource {
  Future<Order> createOrder({
    required FuelType fuelType,
    required int quantityLiters,
    GeoPoint? deliveryLocation,
  });

  Future<List<Order>> getOrders({int page = 1});

  Future<Order> getOrder(String orderId);

  Future<OtpChallenge> getCurrentOtp(String orderId);

  Future<Order> cancelOrder(String orderId);

  Future<Order> redispatch(String orderId);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Order> createOrder({
    required FuelType fuelType,
    required int quantityLiters,
    GeoPoint? deliveryLocation,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/orders',
      data: {
        'fuelType': fuelType.toWire(),
        'quantityLiters': quantityLiters,
        if (deliveryLocation != null)
          'deliveryLocation': {
            'lat': deliveryLocation.lat,
            'lng': deliveryLocation.lng,
          },
      },
    );
    return OrderMapper.fromJson(response.data!);
  }

  @override
  Future<List<Order>> getOrders({int page = 1}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/orders',
      queryParameters: {'page': page},
    );
    final items = response.data!['data'] as List<dynamic>;
    return items
        .cast<Map<String, dynamic>>()
        .map(OrderMapper.fromJson)
        .toList();
  }

  @override
  Future<Order> getOrder(String orderId) async {
    final response = await _dio.get<Map<String, dynamic>>('/orders/$orderId');
    return OrderMapper.fromJson(response.data!);
  }

  @override
  Future<OtpChallenge> getCurrentOtp(String orderId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/orders/$orderId/otp/current',
    );
    final data = response.data!;
    return OtpChallenge(
      orderId: orderId,
      purpose: OtpPurpose.fromWire(data['purpose'] as String),
      code: data['otp'] as String,
      expiresAt: DateTime.parse(data['expiresAt'] as String),
    );
  }

  @override
  Future<Order> cancelOrder(String orderId) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/orders/$orderId/cancel',
    );
    return OrderMapper.fromJson(response.data!);
  }

  @override
  Future<Order> redispatch(String orderId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/orders/$orderId/redispatch',
    );
    return OrderMapper.fromJson(response.data!);
  }
}
