import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/realtime/socket_events.dart';
import '../../../../core/realtime/tracking_socket.dart';
import '../../domain/entities/location_sample.dart';
import 'tracking_state.dart';

/// Watches one order's live location over the `/tracking` socket
/// (FR-018/019). Location/status listeners are registered once and filtered
/// by [_watchedOrderId] rather than per-watch, since the socket only
/// exposes global event streams. A periodic timer re-evaluates staleness
/// (FR-021) even when no new update arrives — heartbeats stopping is
/// exactly the case that must be detected without a triggering event.
/// Every reconnect (background/foreground resume, a transient network drop)
/// re-issues `order:watch` for the currently watched order, since the
/// server drops room membership on disconnect (FR-024).
class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit({required TrackingSocket socket})
    : _socket = socket,
      super(const TrackingState.disconnected()) {
    _socket.onLocation(_handleLocation);
    _socket.onConnect(_handleReconnect);
    _staleCheckTimer = Timer.periodic(
      AppDurations.staleCheckInterval,
      (_) => _checkStale(),
    );
  }

  final TrackingSocket _socket;
  String? _watchedOrderId;
  Timer? _staleCheckTimer;

  Future<void> watch(String orderId) async {
    emit(const TrackingState.connecting());
    _watchedOrderId = orderId;

    final ack = await _socket.watchOrder(orderId);
    if (ack['ok'] != true) {
      final error = ack['error'] as String?;
      if (error == SocketAckReasons.notTrackable) {
        emit(const TrackingState.notTrackable());
      } else if (error == SocketAckReasons.notFound) {
        emit(const TrackingState.failure(Failure.notFound()));
      } else {
        emit(const TrackingState.failure(Failure.server()));
      }
      return;
    }

    emit(const TrackingState.watching());
  }

  void _handleReconnect() {
    final orderId = _watchedOrderId;
    if (orderId != null) {
      unawaited(watch(orderId));
    }
  }

  void unwatch(String orderId) {
    _socket.unwatchOrder(orderId);
    if (_watchedOrderId == orderId) {
      _watchedOrderId = null;
      emit(const TrackingState.disconnected());
    }
  }

  void _handleLocation(Map<String, dynamic> payload) {
    if (payload['orderId'] != _watchedOrderId) return;

    final sample = LocationSample(
      lat: (payload['lat'] as num).toDouble(),
      lng: (payload['lng'] as num).toDouble(),
      recordedAt: DateTime.parse(payload['recordedAt'] as String),
      receivedAt: payload['receivedAt'] != null
          ? DateTime.parse(payload['receivedAt'] as String)
          : null,
    );
    // A fresh update is definitionally not stale.
    emit(TrackingState.watching(location: sample));
  }

  void _checkStale() {
    final current = state;
    if (current is! TrackingWatching || current.location == null) return;

    final isStale = current.location!.isStale(DateTime.now());
    if (isStale != current.stale) {
      emit(current.copyWith(stale: isStale));
    }
  }

  @override
  Future<void> close() {
    _staleCheckTimer?.cancel();
    return super.close();
  }
}
