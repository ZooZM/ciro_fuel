import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../features/delivery/presentation/widgets/stop_reason_sheet.dart';
import '../router/app_router.dart';
import '../router/app_routes.dart';
import 'notification_presenter.dart';

/// spec 011 T028 (FR-004a): what happens when the driver taps the stop alert.
///
/// The alert is the whole point of the device-level notification — a driver
/// who sees it on a locked screen must reach the reason prompt for *that*
/// stop in one tap, not land on a home screen and go looking. The payload
/// carries both ids for exactly this reason: the order to open, and the
/// specific stop to answer, since the platform addresses reasons by stop and
/// a delivery can accumulate several across a journey.
///
/// Kept out of `DeliveryListener` deliberately. That class owns socket
/// wiring and is unit-tested against a mocked socket with no navigator at
/// all; navigation needs a live router, which would drag a `GoRouter` into
/// every one of those tests for a concern they do not exercise.
class StopAlertRouter {
  StopAlertRouter({
    required NotificationPresenter notificationPresenter,
    required AppRouter appRouter,
  }) : _notificationPresenter = notificationPresenter,
       _appRouter = appRouter;

  final NotificationPresenter _notificationPresenter;
  final AppRouter _appRouter;
  StreamSubscription<String>? _subscription;

  void attach() {
    _subscription ??= _notificationPresenter.taps.listen(_handleTap);
  }

  Future<void> detach() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  void _handleTap(String payload) {
    // `orderId:stopId`, as `DeliveryListener` composes it. Anything else is
    // a payload from some future alert this router does not own — ignored
    // rather than guessed at.
    final parts = payload.split(':');
    if (parts.length != 2 || parts.any((p) => p.isEmpty)) return;
    final [orderId, stopId] = parts;

    _appRouter.config.go(AppRoutes.driverOrderDetail(orderId));

    // The sheet needs a context under the route we just pushed, which does
    // not exist until the frame after `go`. Deferring by one frame is the
    // difference between the prompt opening and the tap doing nothing
    // visible — the failure would look exactly like a dead notification.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _appRouter.config.routerDelegate.navigatorKey.currentContext;
      if (context == null) return;
      unawaited(showStopReasonSheet(context, orderId: orderId, stopId: stopId));
    });
  }
}
