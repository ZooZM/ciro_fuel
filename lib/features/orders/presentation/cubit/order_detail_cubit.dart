import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/tracking_socket.dart';
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
      (order) => emit(OrderDetailState.loaded(order)),
    );
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
        final current = state;
        if (current is OrderDetailLoaded) {
          emit(OrderDetailState.loaded(current.order, activeOtp: otp));
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
