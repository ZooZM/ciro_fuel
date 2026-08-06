import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/realtime/tracking_socket.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/order_status.dart';
import '../../domain/gateways/payment_gateway.dart';
import '../../domain/usecases/get_order.dart';
import 'payment_state.dart';

/// Confirmation is detected two ways: the room-scoped `order:status` push
/// (works once `OrderDetailCubit`/[TrackingCubit] has already joined the
/// order's room — only possible once IN_TRANSIT/UNLOADING per the WS
/// contract's NOT_TRACKABLE rule) and, since that room membership is *not*
/// guaranteed to exist yet at the moment payment is confirmed, a REST poll
/// while [PaymentAwaitingConfirmation] as the reliable fallback. Either path
/// only ever emits [PaymentState.confirmed] from backend-observed state —
/// never from the gateway's own return value (research R3/R7).
class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit({
    required String orderId,
    required PaymentGateway gateway,
    required TrackingSocket socket,
    required GetOrder getOrder,
    Duration? pollInterval,
  }) : _orderId = orderId,
       _gateway = gateway,
       _socket = socket,
       _getOrder = getOrder,
       _pollInterval =
           pollInterval ?? AppDurations.paymentConfirmationPollInterval,
       super(const PaymentState.idle()) {
    _socket.onStatus(_handleStatus);
  }

  final String _orderId;
  final PaymentGateway _gateway;
  final TrackingSocket _socket;
  final GetOrder _getOrder;
  final Duration _pollInterval;
  Timer? _pollTimer;

  Future<void> pay(Money amount) async {
    emit(const PaymentState.initiating());
    final result = await _gateway.pay(orderId: _orderId, amount: amount);
    result.fold((failure) => emit(PaymentState.failure(failure)), (_) {
      emit(const PaymentState.awaitingConfirmation());
      _pollTimer?.cancel();
      _pollTimer = Timer.periodic(_pollInterval, (_) => unawaited(_pollOnce()));
    });
  }

  Future<void> _pollOnce() async {
    if (state is! PaymentAwaitingConfirmation) {
      _pollTimer?.cancel();
      return;
    }
    final result = await _getOrder(_orderId);
    result.fold((_) {}, _applyOrderStatus);
  }

  void _handleStatus(Map<String, dynamic> payload) {
    if (payload['orderId'] != _orderId) return;
    final to = payload['to'] as String?;
    if (to == null) return;
    _applyStatus(to);
  }

  void _applyOrderStatus(Order order) => _applyStatus(order.status.toWire());

  void _applyStatus(String to) {
    if (to == OrderStatus.inTransit.toWire()) {
      _pollTimer?.cancel();
      emit(const PaymentState.confirmed());
    } else if (to == OrderStatus.approved.toWire() &&
        state is PaymentAwaitingConfirmation) {
      _pollTimer?.cancel();
      emit(const PaymentState.windowExpired());
    }
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }
}
