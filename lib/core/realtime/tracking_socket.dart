import 'package:socket_io_client/socket_io_client.dart' as io;

import '../config/constants.dart';
import '../config/env.dart';
import '../network/token_store.dart';
import 'socket_events.dart';

/// Client for the backend's `/tracking` Socket.io namespace (feature 001
/// WS contract). The handshake fixes the socket's user/role/company
/// context, so a token renewal requires cycling the connection via
/// [reauthenticate] rather than mutating an established socket (FR-020).
class TrackingSocket {
  TrackingSocket({required TokenStore tokenStore}) : _tokenStore = tokenStore;

  final TokenStore _tokenStore;
  io.Socket? _socket;

  Future<void> connect() async {
    final token = await _tokenStore.accessToken;
    _socket = io.io(
      '${Env.wsBaseUrl}/tracking',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .setReconnectionDelay(
            AppDurations.socketReconnectDelay.inMilliseconds,
          )
          .build(),
    )..connect();
  }

  /// Re-establishes the connection with a freshly renewed access token
  /// (called after [AuthInterceptor] silently refreshes the session).
  Future<void> reauthenticate() async {
    final socket = _socket;
    if (socket == null) return;
    socket.auth = {'token': await _tokenStore.accessToken};
    socket.disconnect();
    socket.connect();
  }

  Future<Map<String, dynamic>> watchOrder(String orderId) async {
    final ack = await _socket?.emitWithAckAsync(SocketEvents.orderWatch, {
      'orderId': orderId,
    });
    return _asMap(ack);
  }

  void unwatchOrder(String orderId) =>
      _socket?.emit(SocketEvents.orderUnwatch, {'orderId': orderId});

  /// DRIVER only. Caller applies the displacement/heartbeat gate before
  /// calling this (research R4); the server re-enforces it regardless.
  Future<Map<String, dynamic>> sendLocation({
    required double lat,
    required double lng,
    required DateTime recordedAt,
  }) async {
    final ack = await _socket?.emitWithAckAsync(SocketEvents.locationUpdate, {
      'lat': lat,
      'lng': lng,
      'recordedAt': recordedAt.toUtc().toIso8601String(),
    });
    return _asMap(ack);
  }

  void onLocation(void Function(Map<String, dynamic>) handler) => _socket?.on(
    SocketEvents.orderLocation,
    (dynamic d) => handler(_asMap(d)),
  );

  void onStatus(void Function(Map<String, dynamic>) handler) =>
      _socket?.on(SocketEvents.orderStatus, (dynamic d) => handler(_asMap(d)));

  void onOtp(void Function(Map<String, dynamic>) handler) =>
      _socket?.on(SocketEvents.orderOtp, (dynamic d) => handler(_asMap(d)));

  void onNotification(void Function(Map<String, dynamic>) handler) => _socket
      ?.on(SocketEvents.notificationNew, (dynamic d) => handler(_asMap(d)));

  /// Fires on the initial connect AND every reconnect (background/foreground
  /// resume, a transient network drop, or [reauthenticate] cycling the
  /// connection). Callers that depend on server-side room membership (e.g.
  /// [TrackingCubit]'s `order:watch`) must re-issue their join here: a
  /// disconnect silently drops the watcher from its room server-side (WS
  /// contract disconnect semantics) — the app never sees an error for it,
  /// so a plain reconnect without re-joining would leave the UI looking
  /// "connected" while no more updates ever arrive (FR-024).
  void onConnect(void Function() handler) =>
      _socket?.on(SocketEvents.connect, (_) => handler());

  void onConnectError(void Function(dynamic) handler) =>
      _socket?.on(SocketEvents.connectError, handler);

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    return const <String, dynamic>{};
  }
}
