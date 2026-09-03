import 'package:dio/dio.dart';

import '../../../../core/location/position_reader.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../../shared/enums/verification_method.dart';
import '../../../orders/data/models/order_mapper.dart';
import '../../../../shared/enums/stop_reason.dart';
import '../../domain/entities/driver_standing.dart';

abstract interface class DeliveryRemoteDataSource {
  /// `GET /orders` is auto-scoped to the assigned driver by the backend
  /// (feature 001 REST contract); the single-status filter can't express
  /// "in transit OR unloading" server-side, so the active job is picked
  /// client-side from the driver's order list.
  Future<Order?> getActiveOrder();

  /// spec 008: the response's `order` field reflects whatever the backend
  /// actually did — a matched departure attempt advances to LOADING, a
  /// matched loading attempt does not move the order at all (confirmLoading
  /// owns that edge) — so the caller must reload from this, never assume.
  ///
  /// `driverLocation` is the fix taken as the card was read. Optional on
  /// the wire and optional here, but the platform refuses a LOADING attempt
  /// that arrives without one (FR-030c) — and the stage is not the app's to
  /// decide, so callers send it whenever the device has one.
  Future<Order> verifyVehicle({
    required String orderId,
    required String credential,
    required VerificationMethod method,
    PositionFix? driverLocation,
  });

  Future<Order> confirmLoading(String orderId);

  Future<void> markArrived(String orderId);

  /// spec 010 FR-010: fired from the active-delivery load path, once, the
  /// first time this order is genuinely displayed to the driver.
  Future<void> acknowledgeAssignment(String orderId);

  Future<void> verifyArrivalOtp({required String orderId, required String otp});

  Future<void> requestDeliveryOtp(String orderId);

  Future<void> verifyDeliveryOtp({
    required String orderId,
    required String otp,
  });

  /// spec 011 FR-008a: announce a stop before the platform has to ask.
  Future<void> declareStop({
    required String orderId,
    required StopReason reason,
    String? reasonText,
    required int expectedDurationMinutes,
  });

  /// feature 013 US5a: report the driver cannot reach the destination.
  Future<void> reportBlocked({
    required String orderId,
    required StopReason reason,
    String? reasonText,
  });

  /// spec 011 FR-007: answer a stop the platform detected.
  Future<void> submitStopReason({
    required String orderId,
    required String stopId,
    required StopReason reason,
    String? reasonText,
  });

  Future<DriverStanding> getDriverSummary();
}

class DeliveryRemoteDataSourceImpl implements DeliveryRemoteDataSource {
  DeliveryRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Order?> getActiveOrder() async {
    // `GET /orders` returns `{ items, nextCursor }` (cursor pagination,
    // spec 005) — it always has; the `'data'` key this used to read never
    // existed. First page only is sufficient: the list sorts by
    // `updatedAt` descending, page size is a fixed 20, and a driver holds
    // at most one delivery at a time (the unique partial index on
    // `activeOrderId`), so an in-progress delivery has necessarily
    // transitioned recently enough to appear here (spec 007 research R3).
    final response = await _dio.get<Map<String, dynamic>>('/orders');
    final page = parsePaginatedResponse(response.data!, OrderMapper.fromJson);
    for (final order in page.items) {
      // spec 008: a driver has real work to do starting at ASSIGNED_TO_DRIVER
      // (verify the vehicle) — not just once the truck is already IN_TRANSIT.
      // Excluding assignedToDriver/loading here would mean the departure
      // verification and loading-confirmation screens are never reachable
      // at all, since nothing would ever surface the order to drive them.
      if (order.status == OrderStatus.assignedToDriver ||
          order.status == OrderStatus.loading ||
          order.status == OrderStatus.inTransit ||
          order.status == OrderStatus.unloading) {
        return order;
      }
    }
    return null;
  }

  @override
  Future<Order> verifyVehicle({
    required String orderId,
    required String credential,
    required VerificationMethod method,
    PositionFix? driverLocation,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/orders/$orderId/verify-vehicle',
      data: {
        'credential': credential,
        'method': method.toWire(),
        if (driverLocation != null)
          'driverLocation': {
            'longitude': driverLocation.longitude,
            'latitude': driverLocation.latitude,
          },
      },
    );
    // A matched attempt (whichever stage) always advances or confirms
    // something — the controller nests the order under `order` here,
    // unlike confirmLoading's own bare-document response, since this
    // endpoint also returns `warehouseSummary` alongside it.
    return OrderMapper.fromJson(
      (response.data!['order'] as Map).cast<String, Object?>(),
    );
  }

  @override
  Future<Order> confirmLoading(String orderId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/orders/$orderId/confirm-loading',
    );
    return OrderMapper.fromJson(response.data!.cast<String, Object?>());
  }

  @override
  Future<void> markArrived(String orderId) =>
      _dio.post<void>('/orders/$orderId/arrive');

  @override
  Future<void> acknowledgeAssignment(String orderId) =>
      _dio.post<void>('/orders/$orderId/acknowledge-assignment');

  @override
  Future<void> declareStop({
    required String orderId,
    required StopReason reason,
    String? reasonText,
    required int expectedDurationMinutes,
  }) => _dio.post<void>(
    '/orders/$orderId/stops/declare',
    data: {
      'reason': reason.toWire(),
      // Sent only when present: the backend requires it for OTHER and
      // rejects an empty string, so an unconditional key would turn every
      // one-tap answer into a 400.
      if (reasonText != null && reasonText.isNotEmpty) 'reasonText': reasonText,
      'expectedDurationMinutes': expectedDurationMinutes,
    },
  );

  @override
  Future<void> reportBlocked({
    required String orderId,
    required StopReason reason,
    String? reasonText,
  }) => _dio.post<void>(
    '/orders/$orderId/stops/blocked',
    data: {
      'reason': reason.toWire(),
      if (reasonText != null && reasonText.isNotEmpty) 'reasonText': reasonText,
    },
  );

  @override
  Future<void> submitStopReason({
    required String orderId,
    required String stopId,
    required StopReason reason,
    String? reasonText,
  }) => _dio.post<void>(
    '/orders/$orderId/stops/$stopId/reason',
    data: {
      'reason': reason.toWire(),
      if (reasonText != null && reasonText.isNotEmpty) 'reasonText': reasonText,
    },
  );

  @override
  Future<void> verifyArrivalOtp({
    required String orderId,
    required String otp,
  }) => _dio.post<void>('/orders/$orderId/verify-arrival', data: {'otp': otp});

  @override
  Future<void> requestDeliveryOtp(String orderId) =>
      _dio.post<void>('/orders/$orderId/request-delivery-otp');

  @override
  Future<void> verifyDeliveryOtp({
    required String orderId,
    required String otp,
  }) => _dio.post<void>('/orders/$orderId/verify-delivery', data: {'otp': otp});

  @override
  Future<DriverStanding> getDriverSummary() async {
    final response = await _dio.get<Map<String, dynamic>>('/drivers/me/summary');
    return DriverStanding.fromJson(response.data!);
  }
}
