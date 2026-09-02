import 'package:dio/dio.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../../shared/enums/otp_purpose.dart';
import '../../../../shared/enums/payment_method.dart';
import '../../domain/entities/otp_challenge.dart';
import '../../domain/entities/price_breakdown.dart';
import '../../../../core/utils/encoded_polyline.dart';
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
    String? stationId,
    String? quoteToken,
  });

  Future<Quote> quote({
    required FuelType fuelType,
    required int quantityLiters,
    required String stationId,
  });

  Future<PaginatedResult<Order>> getOrders({OrderStatus? status, String? cursor});

  Future<Order> getOrder(String orderId);

  /// The driven route from the assigned driver to the destination.
  /// Empty whenever the backend has none to give.
  Future<List<GeoPoint>> getDrivingRoute(String orderId);

  Future<OtpChallenge> getCurrentOtp(String orderId);

  Future<Order> cancelOrder(String orderId);

  Future<Order> redispatch(String orderId);

  Future<OrderRating> submitRating(String orderId, {required int score, String? review});
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
    String? stationId,
    String? quoteToken,
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
        if (stationId != null) 'stationId': stationId,
        if (quoteToken != null) 'quoteToken': quoteToken,
      },
    );
    return OrderMapper.fromJson(response.data!);
  }

  @override
  Future<Quote> quote({
    required FuelType fuelType,
    required int quantityLiters,
    required String stationId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/orders/quote',
      data: {
        'fuelType': fuelType.toWire(),
        'quantityLiters': quantityLiters,
        'stationId': stationId,
      },
    );
    return Quote.fromJson(response.data!);
  }

  /// `GET /orders` is cursor-paginated (feature 005, FR-048), scoped to the
  /// caller (CLIENT → own, DRIVER → assigned). `status` is applied
  /// server-side across the caller's whole set, not merely the fetched page.
  @override
  Future<PaginatedResult<Order>> getOrders({
    OrderStatus? status,
    String? cursor,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/orders',
      queryParameters: {
        if (status != null) 'status': status.toWire(),
        if (cursor != null) 'cursor': cursor,
      },
    );
    return parsePaginatedResponse(response.data!, OrderMapper.fromJson);
  }

  @override
  Future<Order> getOrder(String orderId) async {
    final response = await _dio.get<Map<String, dynamic>>('/orders/$orderId');
    return OrderMapper.fromJson(response.data!);
  }

  @override
  Future<List<GeoPoint>> getDrivingRoute(String orderId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/orders/$orderId/driving-route',
    );
    // `route: null` is the backend's ordinary answer when no driver is
    // assigned, none has reported a position, or Directions is unavailable —
    // an empty route, not a failure.
    final route = response.data?['route'];
    if (route is! Map<String, dynamic>) return const [];
    final polyline = route['polyline'];
    if (polyline is! String || polyline.isEmpty) return const [];
    return EncodedPolyline.decode(polyline);
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

  @override
  Future<OrderRating> submitRating(
    String orderId, {
    required int score,
    String? review,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/orders/$orderId/rating',
      data: {'score': score, if (review != null) 'review': review},
    );
    return OrderRating(
      score: response.data!['score']! as int,
      review: response.data!['review'] as String?,
    );
  }
}
