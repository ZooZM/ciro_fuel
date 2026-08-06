import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/error_interceptor.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/delivery/data/datasources/delivery_remote_data_source.dart';
import 'package:mobile_app/features/delivery/data/repositories/delivery_repository_impl.dart';
import 'package:mobile_app/features/delivery/data/services/location_stream_service.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_active_order.dart';
import 'package:mobile_app/features/delivery/domain/usecases/mark_arrived.dart';
import 'package:mobile_app/features/delivery/domain/usecases/request_delivery_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_state.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/otp_verify_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/otp_verify_state.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

/// Simulates the backend's driver-facing order + OTP endpoints. Codes
/// "CORRECT1"/"CORRECT2" succeed; anything else 422s; a wrong arrival
/// attempt past [maxWrongAttempts] 429s (mirrors the real 5/15min throttle,
/// scaled down so the test doesn't need real delays).
class _ScriptedDriverAdapter implements HttpClientAdapter {
  static const maxWrongAttempts = 2;
  int wrongArrivalAttempts = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final headers = {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    };

    if (options.method == 'GET' && options.path == '/orders') {
      return ResponseBody.fromString(
        '{"data":[{"id":"o1","status":"IN_TRANSIT","fuelType":"DIESEL",'
        '"quantityLiters":500,"statusChangedAt":"2026-01-01T12:00:00Z"}]}',
        200,
        headers: headers,
      );
    }
    if (options.method == 'POST' && options.path == '/orders/o1/arrive') {
      return ResponseBody.fromString('{}', 200, headers: headers);
    }
    if (options.method == 'POST' &&
        options.path == '/orders/o1/verify-arrival') {
      final otp = (options.data as Map)['otp'];
      if (otp == 'CORRECT1') {
        return ResponseBody.fromString('{}', 200, headers: headers);
      }
      wrongArrivalAttempts++;
      if (wrongArrivalAttempts > maxWrongAttempts) {
        return ResponseBody.fromString(
          '{"message":"throttled"}',
          429,
          headers: headers,
        );
      }
      return ResponseBody.fromString(
        '{"message":"wrong otp"}',
        422,
        headers: headers,
      );
    }
    if (options.method == 'POST' &&
        options.path == '/orders/o1/request-delivery-otp') {
      return ResponseBody.fromString('{}', 200, headers: headers);
    }
    if (options.method == 'POST' &&
        options.path == '/orders/o1/verify-delivery') {
      final otp = (options.data as Map)['otp'];
      if (otp == 'CORRECT2') {
        return ResponseBody.fromString('{}', 200, headers: headers);
      }
      return ResponseBody.fromString(
        '{"message":"wrong otp"}',
        422,
        headers: headers,
      );
    }
    return ResponseBody.fromString(
      '{"message":"not found"}',
      404,
      headers: headers,
    );
  }

  @override
  void close({bool force = false}) {}
}

class _MockTrackingSocket extends Mock implements TrackingSocket {}

class _MockLocationStreamService extends Mock
    implements LocationStreamService {}

void main() {
  test(
    'assigned -> stream -> arrival OTP -> unloading -> delivery OTP -> delivered',
    () async {
      final adapter = _ScriptedDriverAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter
        ..interceptors.add(ErrorInterceptor());
      final dataSource = DeliveryRemoteDataSourceImpl(dio);
      final repository = DeliveryRepositoryImpl(dataSource);

      final socket = _MockTrackingSocket();
      when(() => socket.onStatus(any())).thenAnswer((_) {});

      final locationStream = _MockLocationStreamService();
      when(locationStream.start).thenAnswer((_) async => true);
      when(locationStream.stop).thenAnswer((_) async {});

      final deliveryCubit = DeliveryCubit(
        getActiveOrder: GetActiveOrder(repository),
        locationStream: locationStream,
        socket: socket,
      );
      final otpCubit = OtpVerifyCubit(
        orderId: 'o1',
        markArrived: MarkArrived(repository),
        verifyArrivalOtp: VerifyArrivalOtp(repository),
        requestDeliveryOtp: RequestDeliveryOtp(repository),
        verifyDeliveryOtp: VerifyDeliveryOtp(repository),
      );
      addTearDown(() {
        deliveryCubit.close();
        otpCubit.close();
      });

      // --- Assigned job appears, location streaming starts ---
      await deliveryCubit.load();
      expect(deliveryCubit.state, isA<DeliveryActive>());
      expect((deliveryCubit.state as DeliveryActive).streaming, isTrue);
      verify(locationStream.start).called(1);

      // --- Driver marks arrived (generates the arrival OTP; never sees it) ---
      await otpCubit.markArrived();
      expect(otpCubit.state, const OtpVerifyState.idle());

      // --- Wrong arrival codes are rejected, then throttled ---
      await otpCubit.submitArrivalOtp('WRONG-A');
      expect(otpCubit.state, const OtpVerifyState.rejected());
      await otpCubit.submitArrivalOtp('WRONG-B');
      expect(otpCubit.state, const OtpVerifyState.rejected());
      await otpCubit.submitArrivalOtp('WRONG-C');
      expect(otpCubit.state, isA<OtpVerifyThrottled>());

      // --- Correct arrival code advances to unloading ---
      await otpCubit.submitArrivalOtp('CORRECT1');
      expect(
        otpCubit.state,
        const OtpVerifyState.advanced(OrderStatus.unloading),
      );

      // --- Driver requests + submits the delivery code ---
      await otpCubit.requestDeliveryOtp();
      expect(otpCubit.state, const OtpVerifyState.idle());

      await otpCubit.submitDeliveryOtp('WRONG-D');
      expect(otpCubit.state, const OtpVerifyState.rejected());

      await otpCubit.submitDeliveryOtp('CORRECT2');
      expect(
        otpCubit.state,
        const OtpVerifyState.advanced(OrderStatus.delivered),
      );

      // No point in this flow ever constructs a type holding the OTP value —
      // OtpVerifyCubit's states above are exhaustively code-free (SC-008).
    },
  );
}
