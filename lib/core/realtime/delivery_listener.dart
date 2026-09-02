import 'dart:async';

import 'package:easy_localization/easy_localization.dart';

import '../../features/delivery/presentation/cubit/delivery_cubit.dart';
import '../../shared/enums/notification_type.dart';
import '../localization/translation_keys.dart';
import '../notifications/notification_presenter.dart';
import 'tracking_socket.dart';

/// Wires the driver's active-delivery cubit to the realtime signals that can
/// change what it is carrying (spec 007). `DeliveryCubit` does not talk to
/// `TrackingSocket` itself (research R2) — a `registerLazySingleton`
/// constructor runs at whatever unpredictable moment something first
/// resolves it, which could be before the socket even connects, and
/// registering a handler then is a silent no-op — exactly
/// `mobile_app/CLAUDE.md` debt #6's failure mode for `NotificationsCubit`.
///
/// Extracted out of `injector.dart` so this wiring is unit-testable without
/// booting the whole DI graph — a mocked [TrackingSocket] is enough. Mirrors
/// spec 006's `SessionRevocationListener`.
class DeliveryListener {
  DeliveryListener({
    required TrackingSocket trackingSocket,
    required DeliveryCubit deliveryCubit,
    required NotificationPresenter notificationPresenter,
  }) : _trackingSocket = trackingSocket,
       _deliveryCubit = deliveryCubit,
       _notificationPresenter = notificationPresenter;

  final TrackingSocket _trackingSocket;
  final DeliveryCubit _deliveryCubit;
  final NotificationPresenter _notificationPresenter;

  /// Call only once the socket is actually connected — i.e. after awaiting
  /// [TrackingSocket.connect], never right after invoking it. See the class
  /// doc comment for why an earlier attachment is silently inert rather than
  /// merely late.
  void attach() {
    // spec 011 T025 (FR-004a): Android 13+ will not display a notification
    // until the driver has granted `POST_NOTIFICATIONS` at runtime — the
    // manifest declaration alone silently buys nothing. Asked here, at
    // sign-in, rather than at the moment a stop is detected: a permission
    // dialog appearing mid-drive is both worse to answer and too late to be
    // any use, since the alert it gates has already been dropped by then.
    // Fire-and-forget — a refusal is a legitimate outcome the platform-side
    // escalation to the transporter already covers, and must not stop the
    // socket handlers below from being registered.
    unawaited(_notificationPresenter.ensurePermission());

    // research R1: a DRIVER can never join an order room (`order:watch`
    // refuses UserRole.DRIVER with FORBIDDEN_ROLE), so this is the only path
    // by which a status change ever reaches this device. `handleOrderStatus`
    // itself decides whether the push matches the currently active delivery
    // and reloads from the platform — never applies the payload locally
    // (FR-015).
    _trackingSocket.onStatus(_deliveryCubit.handleOrderStatus);

    // FR-002: a delivery assigned while the app is already open must
    // appear without the driver restarting it. `ORDER_ASSIGNED` already
    // reaches this device today (dispatch notifies the assigned driver
    // directly) — it just couldn't be acted on before the NotificationType
    // enum was corrected to the backend's real wire values (research R10).
    // Registering a second handler on `notification:new` is safe:
    // `NotificationsCubit` already has its own for the unread badge/list,
    // and Socket.IO calls every handler registered for an event.
    _trackingSocket.onNotification((payload) {
      final type = NotificationType.fromWire(payload['type'] as String? ?? '');
      if (type == NotificationType.orderAssigned) {
        unawaited(_deliveryCubit.load());
      }
      // spec 011 FR-004a: the platform has noticed this truck has not moved
      // and is asking why. Unlike every other notification type, this one
      // must reach a driver who is *driving* — with the app backgrounded and
      // the phone pocketed — so it is raised as a device-level alert rather
      // than left on the in-app list. Fire-and-forget: a presenter failure
      // (permission refused, for instance) must never break the socket
      // handler, and the platform-side escalation to the transporter is what
      // covers a driver who never sees this.
      if (type == NotificationType.driverStopDetected) {
        final stopId = payload['stopId'] as String? ?? '';
        final orderId = payload['orderId'] as String? ?? '';
        unawaited(
          _notificationPresenter.present(
            title: DriverKeys.stopDetectedTitle.tr(),
            body: DriverKeys.stopDetectedBody.tr(),
            // `orderId:stopId` — the prompt needs both: the order to load,
            // and the specific stop to answer, since the reason endpoint is
            // addressed by stop.
            payload: '$orderId:$stopId',
          ),
        );
      }
    });
  }
}
