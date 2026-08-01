import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/tracking_socket.dart';
import '../../../../shared/enums/order_status.dart';
import '../../data/services/location_stream_service.dart';
import '../../domain/usecases/get_active_order.dart';
import 'delivery_state.dart';

/// Owns the driver's active-order lookup and the location stream's
/// lifecycle together: streaming starts only once a trackable job is
/// found and stops the moment the backend reports the order terminal
/// (research R4) — never left running idle.
class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit({
    required GetActiveOrder getActiveOrder,
    required LocationStreamService locationStream,
    required TrackingSocket socket,
  }) : _getActiveOrder = getActiveOrder,
       _locationStream = locationStream,
       _socket = socket,
       super(const DeliveryState.noActiveOrder()) {
    _socket.onStatus(_handleStatus);
  }

  final GetActiveOrder _getActiveOrder;
  final LocationStreamService _locationStream;
  final TrackingSocket _socket;

  Future<void> load() async {
    final result = await _getActiveOrder();
    await result.fold(
      (failure) async => emit(DeliveryState.failure(failure)),
      (order) async {
        if (order == null) {
          await _locationStream.stop();
          emit(const DeliveryState.noActiveOrder());
          return;
        }
        final streaming = await _locationStream.start();
        emit(DeliveryState.active(order, streaming: streaming));
      },
    );
  }

  void _handleStatus(Map<String, dynamic> payload) {
    final current = state;
    if (current is! DeliveryActive) return;
    if (payload['orderId'] != current.order.id) return;

    final to = payload['to'] as String?;
    if (to == OrderStatus.delivered.toWire() ||
        to == OrderStatus.cancelled.toWire()) {
      // load() alone decides whether to stop: its "no active order" branch
      // stops the stream, and if the driver already has a next job lined
      // up, LocationStreamService.start() is a no-op on an already-running
      // stream — no need to stop and immediately restart it here too.
      unawaited(load());
    }
  }

  @override
  Future<void> close() {
    unawaited(_locationStream.stop());
    return super.close();
  }
}
