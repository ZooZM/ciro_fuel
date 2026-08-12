import 'package:dio/dio.dart';

import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../../shared/enums/otp_purpose.dart';
import '../../../../shared/enums/payment_method.dart';
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
    PaymentMethod? paymentMethod,
  });

  Future<List<Order>> getOrders({OrderStatus? status});

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
    PaymentMethod? paymentMethod,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/orders',
      data: {
        'fuelType': fuelType.toWire(),
        'quantityLiters': quantityLiters,
        // Backend GeoPointDto field names — `lat`/`lng` fail validation.
        if (deliveryLocation != null)
          'deliveryLocation': {
            'longitude': deliveryLocation.lng,
            'latitude': deliveryLocation.lat,
          },
        if (paymentMethod != null) 'paymentMethod': paymentMethod.toWire(),
      },
    );
    return OrderMapper.fromJson(response.data!);
  }

  /// `GET /orders` returns a bare JSON array, already scoped to the caller
  /// (CLIENT → own, DRIVER → assigned). It takes no `page` parameter — the
  /// only supported filter is `status` — so pagination is not requested here.
  @override
  Future<List<Order>> getOrders({OrderStatus? status}) async {
    final response = await _dio.get<List<dynamic>>(
      '/orders',
      queryParameters: {if (status != null) 'status': status.toWire()},
    );
    return response.data!
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
