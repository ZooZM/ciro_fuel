import 'dart:typed_data';

import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/error_interceptor.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:mobile_app/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:mobile_app/features/orders/domain/gateways/payment_gateway.dart';
import 'package:mobile_app/features/orders/domain/usecases/create_order.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_current_otp.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_order.dart';
import 'package:mobile_app/features/orders/presentation/cubit/order_detail_cubit.dart';
import 'package:mobile_app/features/orders/presentation/cubit/order_detail_state.dart';
import 'package:mobile_app/features/orders/presentation/cubit/payment_cubit.dart';
import 'package:mobile_app/features/orders/presentation/cubit/payment_state.dart';
import 'package:mobile_app/features/tracking/presentation/cubit/tracking_cubit.dart';
import 'package:mobile_app/features/tracking/presentation/cubit/tracking_state.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mocktail/mocktail.dart';

/// Simulates the backend order lifecycle for one order across the whole
/// journey: create -> approve -> pay -> in transit -> arrival OTP. REST
/// (`POST/GET /orders`) is a real Dio pipeline against this scripted
/// adapter; realtime pushes are driven directly through a mocked
/// [TrackingSocket] (no socket.io test server available headlessly) —
/// same boundary choice as auth_session_test.dart.
class _ScriptedOrdersAdapter implements HttpClientAdapter {
  String status = 'PENDING_APPROVAL';
  double? finalPrice;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final headers = {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    };

    if (options.method == 'POST' && options.path == '/orders') {
      return ResponseBody.fromString(_orderJson('o1'), 201, headers: headers);
    }
    if (options.method == 'GET' && options.path == '/orders/o1') {
      return ResponseBody.fromString(_orderJson('o1'), 200, headers: headers);
    }
    if (options.method == 'GET' && options.path == '/orders/o1/otp/current') {
      return ResponseBody.fromString(
        '{"purpose":"ARRIVAL","otp":"482913","expiresAt":"2026-01-01T13:00:00Z"}',
        200,
        headers: headers,
      );
    }
    return ResponseBody.fromString(
      '{"message":"not found"}',
      404,
      headers: headers,
    );
  }

  String _orderJson(String id) =>
      '{"id":"$id","status":"$status","fuelType":"DIESEL","quantityLiters":500,'
      '${finalPrice != null ? '"finalPrice":$finalPrice,' : ''}'
      '"statusChangedAt":"2026-01-01T12:00:00Z"}';

  @override
  void close({bool force = false}) {}
}

class _MockPaymentGateway extends Mock implements PaymentGateway {}

class _MockTrackingSocket extends Mock implements TrackingSocket {}

/// Polls [condition] on a real timer rather than assuming a fixed number of
/// event-loop turns — robust regardless of how many `await` hops the
/// triggered async work (e.g. a REST re-fetch) actually needs.
Future<void> _pollUntil(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw StateError('Condition not met within $timeout');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  test(
    'create -> approve -> pay -> in transit -> arrival code (CLIENT-visible only)',
    () async {
      final adapter = _ScriptedOrdersAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter
        ..interceptors.add(ErrorInterceptor());
      final dataSource = OrdersRemoteDataSourceImpl(dio);
      final repository = OrdersRepositoryImpl(dataSource);

      final gateway = _MockPaymentGateway();
      final socket = _MockTrackingSocket();
      // A real socket dispatches an event to every registered listener; both
      // OrderDetailCubit and PaymentCubit register their own onStatus
      // handler on this shared mock, so all of them must be collected and
      // invoked together — not just the most recently registered one.
      final statusHandlers = <void Function(Map<String, dynamic>)>[];
      final otpHandlers = <void Function(Map<String, dynamic>)>[];
      final locationHandlers = <void Function(Map<String, dynamic>)>[];
      when(() => socket.onStatus(any())).thenAnswer((i) {
        statusHandlers.add(
          i.positionalArguments[0] as void Function(Map<String, dynamic>),
        );
      });
      when(() => socket.onOtp(any())).thenAnswer((i) {
        otpHandlers.add(
          i.positionalArguments[0] as void Function(Map<String, dynamic>),
        );
      });
      when(() => socket.onLocation(any())).thenAnswer((i) {
        locationHandlers.add(
          i.positionalArguments[0] as void Function(Map<String, dynamic>),
        );
      });
      void fireStatus(Map<String, dynamic> payload) {
        for (final handler in statusHandlers) {
          handler(payload);
        }
      }

      void fireOtp(Map<String, dynamic> payload) {
        for (final handler in otpHandlers) {
          handler(payload);
        }
      }

      void fireLocation(Map<String, dynamic> payload) {
        for (final handler in locationHandlers) {
          handler(payload);
        }
      }

      when(() => socket.watchOrder('o1')).thenAnswer((_) async => {'ok': true});

      // --- Create ---
      final createResult = await CreateOrder(repository)(
        fuelType: FuelType.diesel,
        quantityLiters: 500,
      );
      final createdOrder = createResult.getOrElse(
        () => throw StateError('create failed'),
      );
      expect(createdOrder.id, 'o1');
      expect(createdOrder.status.wire, 'PENDING_APPROVAL');

      final detailCubit = OrderDetailCubit(
        orderId: 'o1',
        getOrder: GetOrder(repository),
        getCurrentOtp: GetCurrentOtp(repository),
        socket: socket,
      );
      final paymentCubit = PaymentCubit(
        orderId: 'o1',
        gateway: gateway,
        socket: socket,
        getOrder: GetOrder(repository),
      );
      final trackingCubit = TrackingCubit(socket: socket);
      addTearDown(() {
        detailCubit.close();
        paymentCubit.close();
        trackingCubit.close();
      });

      await detailCubit.load();
      expect(
        (detailCubit.state as OrderDetailLoaded).order.status.wire,
        'PENDING_APPROVAL',
      );

      // --- Backend (COMPANY_ADMIN) approves with a final price ---
      adapter.status = 'APPROVED';
      adapter.finalPrice = 450.5;
      fireStatus({
        'orderId': 'o1',
        'to': 'APPROVED',
        'at': '2026-01-01T12:05:00Z',
      });
      // The push triggers an async REST re-fetch (OrderDetailCubit.load()) —
      // poll for that specific resulting state rather than a fixed delay.
      await _pollUntil(
        () =>
            detailCubit.state is OrderDetailLoaded &&
            (detailCubit.state as OrderDetailLoaded).order.status.wire ==
                'APPROVED',
      );
      final approved = (detailCubit.state as OrderDetailLoaded).order;
      expect(approved.status.wire, 'APPROVED');
      expect(
        approved.finalPrice!.amountMinor,
        45050,
      ); // picked up from REST, not the push

      // --- Pay: gateway succeeds but confirmation waits on the backend ---
      when(
        () => gateway.pay(orderId: 'o1', amount: approved.finalPrice!),
      ).thenAnswer((_) async => const Right(null));
      await paymentCubit.pay(approved.finalPrice!);
      expect(paymentCubit.state, const PaymentState.awaitingConfirmation());

      adapter.status = 'IN_TRANSIT';
      fireStatus({
        'orderId': 'o1',
        'to': 'IN_TRANSIT',
        'at': '2026-01-01T12:10:00Z',
      });
      await Future<void>.delayed(Duration.zero);
      expect(paymentCubit.state, const PaymentState.confirmed());

      // --- Live tracking ---
      await trackingCubit.watch('o1');
      expect(trackingCubit.state, isA<TrackingWatching>());
      fireLocation({
        'orderId': 'o1',
        'lat': 24.7136,
        'lng': 46.6753,
        'recordedAt': '2026-01-01T12:12:00Z',
        'receivedAt': '2026-01-01T12:12:01Z',
      });
      final watching = trackingCubit.state as TrackingWatching;
      expect(watching.location!.lat, 24.7136);

      // --- Arrival OTP: pushed, visible only through this CLIENT cubit ---
      fireOtp({'orderId': 'o1', 'purpose': 'ARRIVAL'});
      await _pollUntil(
        () =>
            detailCubit.state is OrderDetailLoaded &&
            (detailCubit.state as OrderDetailLoaded).activeOtp != null,
      );
      final withOtp = detailCubit.state as OrderDetailLoaded;
      expect(withOtp.activeOtp!.code, '482913');
      // The OTP lives only in this CLIENT-side state — no driver-facing type
      // in this codebase ever holds or renders a code (see delivery feature).
    },
  );
}
