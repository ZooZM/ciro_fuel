import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/tracking_socket.dart';
import '../../../../shared/entities/order.dart';
import '../../domain/entities/otp_challenge.dart';
import '../../domain/usecases/get_current_otp.dart';
import '../../domain/usecases/get_order.dart';
import 'order_detail_state.dart';

/// Loads an order and keeps it live via the `/tracking` socket's
/// `order:status`/`order:otp` pushes. A status push carries only
/// `{orderId, from, to, at}` — richer fields that change alongside a
/// transition (`finalPrice`, `paymentDeadline`, `driverId`)
/// only exist on the REST representation, so a push triggers a full
/// re-fetch rather than a local patch, keeping every field in sync with
/// the backend (research R7). A push is only acted on if its timestamp is
/// newer than what's currently held, guarding against an out-of-order
/// delivery re-triggering a redundant fetch.
class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit({
    required String orderId,
    required GetOrder getOrder,
    required GetCurrentOtp getCurrentOtp,
    required TrackingSocket socket,
  }) : _orderId = orderId,
       _getOrder = getOrder,
       _getCurrentOtp = getCurrentOtp,
       _socket = socket,
       super(const OrderDetailState.loading()) {
    _socket.onStatus(_handleStatus);
    _socket.onOtp(_handleOtp);
  }

  final String _orderId;
  final GetOrder _getOrder;
  final GetCurrentOtp _getCurrentOtp;
  final TrackingSocket _socket;

  /// The handover code, held here rather than only in the emitted state.
  ///
  /// It has to outlive an individual emit: `/arrive` issues the code AND
  /// sends a notification, and that notification triggers a full [load] —
  /// so a reload reliably landed after the code had been fetched and
  /// emitted `loaded(order)` over the top of it, with `activeOtp` back to
  /// its null default. The customer was then holding the one screen that is
  /// supposed to show the code, with the code fetched and thrown away.
  OtpChallenge? _activeOtp;

  /// Never hand back a code that has already lapsed — the card renders a
  /// countdown, and an expired code presented as live is worse than none.
  OtpChallenge? get _liveOtp {
    final otp = _activeOtp;
    if (otp == null) return null;
    return otp.expiresAt.isAfter(DateTime.now()) ? otp : null;
  }

  Future<void> load() async {
    if (isClosed) return;
    emit(const OrderDetailState.loading());
    final result = await _getOrder(_orderId);
    // The screen can be popped — or pull-to-refresh can rebuild it — while
    // this is in flight, and the socket handlers below fire it without
    // awaiting. `TrackingSocket` has no way to unregister a handler, so a
    // closed cubit still receives pushes; emitting into one throws.
    if (isClosed) return;
    result.fold(
      (failure) => emit(OrderDetailState.failure(failure)),
      (order) {
        // Out-of-order responses must not win. `_handleStatus` fires one
        // [load] per `order:status` push, and transitions arrive in BURSTS:
        // approving a DEFERRED order moves it PENDING_APPROVAL -> APPROVED ->
        // ROUTED_TO_TRANSPORT -> PENDING_PAYMENT inside a single second, so
        // three fetches are in flight at once and whichever RESOLVED last
        // decided what the customer saw. Landing on the middle one left the
        // order reading "confirmed" while the platform was actually waiting
        // on the station owner to accept the total — the same dead end the
        // accept card exists to remove, reached a different way.
        if (_isStalerThanDisplayed(order)) return;
        emit(OrderDetailState.loaded(order, activeOtp: _liveOtp));
      },
    );
  }

  /// Whether [candidate] describes an OLDER moment than what is already on
  /// screen. Compared on `statusChangedAt` — the order's own account of when
  /// it last moved — rather than on request ordering, so it is correct
  /// however the responses interleave, and self-corrects rather than needing
  /// the fetches to be serialised.
  bool _isStalerThanDisplayed(Order candidate) {
    final current = state;
    if (current is! OrderDetailLoaded) return false;
    return candidate.statusChangedAt.isBefore(current.order.statusChangedAt);
  }

  /// Called when a CLIENT navigates to the arrival/delivery step, when the
  /// `order:otp` push arrives, or as a fallback if that push was missed.
  /// Deliberately does not require [state] to already be
  /// [OrderDetailLoaded] before fetching — only when applying the result —
  /// so an OTP push arriving while a concurrent status-triggered [load] is
  /// still in flight is not silently dropped.
  Future<void> loadCurrentOtp() async {
    final result = await _getCurrentOtp(_orderId);
    if (isClosed) return;
    result.fold(
      (_) {}, // no active OTP yet; not an error condition worth surfacing
      (otp) {
        // Recorded FIRST, unconditionally. Applying it only when the state
        // already happened to be loaded discarded the code outright on the
        // common path: the screen kicks off `load()` and `loadCurrentOtp()`
        // together, and whenever the OTP fetch won that race the state was
        // still `loading()` and the code went nowhere. Held here, the next
        // emit picks it up either way.
        _activeOtp = otp;
        final current = state;
        if (current is OrderDetailLoaded) {
          emit(OrderDetailState.loaded(current.order, activeOtp: _liveOtp));
        }
      },
    );
  }

  void _handleStatus(Map<String, dynamic> payload) {
    if (payload['orderId'] != _orderId) return;
    final current = state;
    if (current is! OrderDetailLoaded) return;

    final at = DateTime.parse(payload['at'] as String);
    if (!at.isAfter(current.order.statusChangedAt)) return;

    unawaited(load());
  }

  void _handleOtp(Map<String, dynamic> payload) {
    if (payload['orderId'] != _orderId) return;
    unawaited(loadCurrentOtp());
  }
}
