import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/token_store.dart';
import 'package:mobile_app/core/realtime/delivery_listener.dart';
import 'package:mobile_app/core/notifications/notification_presenter.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/delivery/data/services/location_stream_service.dart';
import 'package:mobile_app/features/delivery/domain/usecases/acknowledge_assignment.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_active_order.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_state.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockTrackingSocket extends Mock implements TrackingSocket {}

class _MockGetActiveOrder extends Mock implements GetActiveOrder {}

class _MockVerifyArrivalOtp extends Mock implements VerifyArrivalOtp {}

class _MockVerifyDeliveryOtp extends Mock implements VerifyDeliveryOtp {}

class _MockLocationStreamService extends Mock
    implements LocationStreamService {}

class _MockAcknowledgeAssignment extends Mock implements AcknowledgeAssignment {}

class _MockNotificationPresenter extends Mock implements NotificationPresenter {}

/// spec 007 research R2 (T009): `DeliveryCubit` no longer talks to
/// `TrackingSocket` itself — `DeliveryListener` owns that subscription, and
/// must be attached only after the socket has actually connected. This test
/// exercises the wiring directly (a mocked socket is enough, per the class
/// doc comment) rather than booting the whole DI graph.
void main() {
  late _MockTrackingSocket trackingSocket;
  late DeliveryCubit deliveryCubit;
  late _MockGetActiveOrder getActiveOrder;
  late _MockNotificationPresenter notificationPresenter;

  final order = Order(
    id: 'o1',
    status: OrderStatus.inTransit,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    statusChangedAt: DateTime.utc(2026, 1, 1, 12),
  );

  setUp(() {
    trackingSocket = _MockTrackingSocket();
    getActiveOrder = _MockGetActiveOrder();
    notificationPresenter = _MockNotificationPresenter();
    when(
      () => notificationPresenter.present(
        title: any(named: 'title'),
        body: any(named: 'body'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async {});
    when(notificationPresenter.ensurePermission).thenAnswer((_) async => true);
    final locationStream = _MockLocationStreamService();
    when(locationStream.start).thenAnswer((_) async => true);
    when(locationStream.stop).thenAnswer((_) async {});
    final acknowledgeAssignment = _MockAcknowledgeAssignment();
    when(
      () => acknowledgeAssignment(any()),
    ).thenAnswer((_) async => const Right(null));
    deliveryCubit = DeliveryCubit(
      getActiveOrder: getActiveOrder,
      verifyArrivalOtp: _MockVerifyArrivalOtp(),
      verifyDeliveryOtp: _MockVerifyDeliveryOtp(),
      locationStream: locationStream,
      acknowledgeAssignment: acknowledgeAssignment,
    );
  });

  tearDown(() => deliveryCubit.close());

  test(
    'attach() registers handleOrderStatus directly on the socket — the handler '
    'fires exactly as the cubit would if it had registered itself',
    () async {
      void Function(Map<String, dynamic>)? captured;
      when(() => trackingSocket.onStatus(any())).thenAnswer((invocation) {
        captured =
            invocation.positionalArguments.first
                as void Function(Map<String, dynamic>);
      });

      DeliveryListener(
        trackingSocket: trackingSocket,
        deliveryCubit: deliveryCubit,
        notificationPresenter: notificationPresenter,
      ).attach();

      verify(() => trackingSocket.onStatus(any())).called(1);
      expect(captured, isNotNull);

      // Prove the captured handler is genuinely wired to the cubit: load an
      // active order, then feed a terminal push for it straight through the
      // handler `attach()` registered — the same path a live socket frame
      // would take — and confirm the cubit reacts.
      when(getActiveOrder.call).thenAnswer((_) async => Right(order));
      await deliveryCubit.load();
      expect(deliveryCubit.state, isA<DeliveryActive>());

      when(getActiveOrder.call).thenAnswer((_) async => const Right(null));
      captured!({'orderId': 'o1', 'to': 'DELIVERED', 'at': '2026-01-01T13:00:00Z'});
      await Future<void>.delayed(Duration.zero);

      expect(deliveryCubit.state, const DeliveryState.noActiveOrder());
    },
  );

  test(
    'ORDER_ASSIGNED reloads the active delivery — a new assignment appears '
    'without the driver restarting (FR-002)',
    () async {
      void Function(Map<String, dynamic>)? captured;
      when(() => trackingSocket.onNotification(any())).thenAnswer((
        invocation,
      ) {
        captured =
            invocation.positionalArguments.first
                as void Function(Map<String, dynamic>);
      });
      when(() => trackingSocket.onStatus(any())).thenAnswer((_) {});

      DeliveryListener(
        trackingSocket: trackingSocket,
        deliveryCubit: deliveryCubit,
        notificationPresenter: notificationPresenter,
      ).attach();

      expect(captured, isNotNull);
      when(getActiveOrder.call).thenAnswer((_) async => Right(order));

      captured!({'type': 'ORDER_ASSIGNED', 'orderId': 'o1'});
      await Future<void>.delayed(Duration.zero);

      expect(deliveryCubit.state, isA<DeliveryActive>());
    },
  );

  // spec 011 T017 (FR-004a): the whole point of the presenter seam — a
  // DRIVER_STOP_DETECTED notification must raise a DEVICE-LEVEL alert,
  // because the driver is driving and will never look at the in-app list.
  // Asserting this without a device or a plugin is exactly what the seam
  // buys.
  test(
    'DRIVER_STOP_DETECTED raises a device-level alert carrying the stop id',
    () async {
      void Function(Map<String, dynamic>)? captured;
      when(() => trackingSocket.onNotification(any())).thenAnswer((invocation) {
        captured =
            invocation.positionalArguments.first
                as void Function(Map<String, dynamic>);
      });
      when(() => trackingSocket.onStatus(any())).thenAnswer((_) {});

      DeliveryListener(
        trackingSocket: trackingSocket,
        deliveryCubit: deliveryCubit,
        notificationPresenter: notificationPresenter,
      ).attach();

      captured!({
        'type': 'DRIVER_STOP_DETECTED',
        'orderId': 'o1',
        'stopId': 'stop-123',
      });
      await Future<void>.delayed(Duration.zero);

      final call = verify(
        () => notificationPresenter.present(
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: captureAny(named: 'payload'),
        ),
      )..called(1);
      // Both ids travel: the order to load, and the specific stop to answer
      // — the reason endpoint is addressed by stop, so the id is not
      // optional decoration.
      expect(call.captured.single, 'o1:stop-123');
    },
  );

  // spec 011 T025 (FR-004a): on Android 13+ an ungranted POST_NOTIFICATIONS
  // permission means every alert this feature raises is dropped without a
  // trace — the code looks correct, the notification simply never appears.
  test(
    'attach() requests notification permission — without it every stop alert '
    'is silently dropped on Android 13+',
    () async {
      when(() => trackingSocket.onNotification(any())).thenAnswer((_) {});
      when(() => trackingSocket.onStatus(any())).thenAnswer((_) {});

      DeliveryListener(
        trackingSocket: trackingSocket,
        deliveryCubit: deliveryCubit,
        notificationPresenter: notificationPresenter,
      ).attach();

      verify(notificationPresenter.ensurePermission).called(1);
    },
  );

  test(
    'a notification of any other type raises no device-level alert',
    () async {
      void Function(Map<String, dynamic>)? captured;
      when(() => trackingSocket.onNotification(any())).thenAnswer((invocation) {
        captured =
            invocation.positionalArguments.first
                as void Function(Map<String, dynamic>);
      });
      when(() => trackingSocket.onStatus(any())).thenAnswer((_) {});

      DeliveryListener(
        trackingSocket: trackingSocket,
        deliveryCubit: deliveryCubit,
        notificationPresenter: notificationPresenter,
      ).attach();

      captured!({'type': 'OTP_ISSUED', 'orderId': 'o1'});
      await Future<void>.delayed(Duration.zero);

      // Every other type belongs on the in-app list. Interrupting a driving
      // driver for all of them would train them to ignore the one that
      // matters.
      verifyNever(
        () => notificationPresenter.present(
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: any(named: 'payload'),
        ),
      );
    },
  );

  test(
    'a notification of a different type does not reload',
    () async {
      void Function(Map<String, dynamic>)? captured;
      when(() => trackingSocket.onNotification(any())).thenAnswer((
        invocation,
      ) {
        captured =
            invocation.positionalArguments.first
                as void Function(Map<String, dynamic>);
      });
      when(() => trackingSocket.onStatus(any())).thenAnswer((_) {});

      DeliveryListener(
        trackingSocket: trackingSocket,
        deliveryCubit: deliveryCubit,
        notificationPresenter: notificationPresenter,
      ).attach();

      captured!({'type': 'OTP_ISSUED', 'orderId': 'o1'});
      await Future<void>.delayed(Duration.zero);

      verifyNever(getActiveOrder.call);
    },
  );

  test(
    'a handler attached before the socket ever connects would not fire — the '
    'exact silent no-op this feature exists to avoid (mobile_app/CLAUDE.md debt #6)',
    () {
      // TrackingSocket's registration methods are all `_socket?.on(...)`:
      // with no underlying socket (as before `connect()` resolves), the
      // call is a no-op and never reaches onStatus at all. A real,
      // never-connected TrackingSocket makes this concrete without needing
      // to mock it — there is nothing to verify a call against, which is
      // the point. Its constructor never touches secure storage, only
      // `connect()` does, so a plain `TokenStore()` needs no platform mock
      // here.
      final unconnected = TrackingSocket(tokenStore: TokenStore());
      // No exception, no registration, nothing captured — attach() against
      // an unconnected socket is silently inert. DeliveryListener must
      // therefore only ever be attached after `connect()` has resolved,
      // never before, or it fails exactly this invisibly.
      expect(
        () => DeliveryListener(
          trackingSocket: unconnected,
          deliveryCubit: deliveryCubit,
          notificationPresenter: notificationPresenter,
        ).attach(),
        returnsNormally,
      );
    },
  );
}
