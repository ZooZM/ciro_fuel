import 'package:socket_io_client/socket_io_client.dart' as io;

import '../config/constants.dart';
import '../config/env.dart';
import '../network/token_store.dart';
import 'socket_events.dart';

/// A `(event, handler)` pair recorded on [TrackingSocket] so it can be
/// (re)attached to whatever underlying `io.Socket` currently exists — or to
/// the next one [TrackingSocket.connect] builds.
typedef _Subscription = (String event, dynamic Function(dynamic) handler);

/// Builds the underlying Socket.io client. Injectable so a test can supply a
/// fake without a real server; the default creates the `/tracking` client and
/// calls `connect()` on it, exactly as this class did inline before.
typedef SocketFactory = io.Socket Function(String uri, dynamic options);

/// Client for the backend's `/tracking` Socket.io namespace (feature 001
/// WS contract). The handshake fixes the socket's user/role/company
/// context, so a token renewal requires cycling the connection via
/// [reauthenticate] rather than mutating an established socket (FR-020).
///
/// **Handler registry (feature 013 Slice 0, `mobile_app/CLAUDE.md` debt #6).**
/// Every `on*` method used to be `_socket?.on(...)`, so a handler registered
/// before [connect] resolved subscribed to *nothing*, silently — which is why
/// no `notification:new` push had ever reached either persona
/// (`NotificationsCubit` wires its handler from its constructor, at DI setup,
/// long before any socket exists). Now every `on*` records into [_handlers]
/// and attaches immediately only if a socket is already live; [connect]
/// attaches the whole registry to the socket it creates. Because [connect]
/// builds a **new** `io.Socket` every call (unlike [reauthenticate], which
/// reuses one), the registry is what carries handlers across a
/// sign-out/sign-in — [dispose] tears down the socket but deliberately keeps
/// [_handlers], or a once-registered app-lifetime listener such as
/// `NotificationsCubit` would go permanently deaf after the first sign-out.
class TrackingSocket {
  TrackingSocket({required TokenStore tokenStore, SocketFactory? socketFactory})
    : _tokenStore = tokenStore,
      _socketFactory = socketFactory ?? _defaultSocketFactory;

  final TokenStore _tokenStore;
  final SocketFactory _socketFactory;
  io.Socket? _socket;

  /// Survives [dispose] on purpose — see the class doc comment.
  final List<_Subscription> _handlers = [];

  static io.Socket _defaultSocketFactory(String uri, dynamic options) =>
      io.io(uri, options)..connect();

  Future<void> connect() async {
    final token = await _tokenStore.accessToken;
    final socket = _socketFactory(
      '${Env.wsBaseUrl}/tracking',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .setReconnectionDelay(
            AppDurations.socketReconnectDelay.inMilliseconds,
          )
          .build(),
    );
    _socket = socket;
    for (final (event, handler) in _handlers) {
      socket.on(event, handler);
    }
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

  void onLocation(void Function(Map<String, dynamic>) handler) =>
      _register(SocketEvents.orderLocation, (dynamic d) => handler(_asMap(d)));

  void onStatus(void Function(Map<String, dynamic>) handler) =>
      _register(SocketEvents.orderStatus, (dynamic d) => handler(_asMap(d)));

  void onOtp(void Function(Map<String, dynamic>) handler) =>
      _register(SocketEvents.orderOtp, (dynamic d) => handler(_asMap(d)));

  void onNotification(void Function(Map<String, dynamic>) handler) =>
      _register(SocketEvents.notificationNew, (dynamic d) => handler(_asMap(d)));

  /// spec 006 US5 (FR-035): the server pushes this the instant a live
  /// session is revoked — displacement by a sign-in elsewhere, a password
  /// reset, or a deactivation. The registry (see the class doc comment) is
  /// what makes attaching this before [connect] safe now — it is recorded and
  /// flushed onto the socket [connect] builds, rather than lost.
  void onSessionRevoked(void Function(Map<String, dynamic>) handler) =>
      _register(SocketEvents.sessionRevoked, (dynamic d) => handler(_asMap(d)));

  /// Fires on the initial connect AND every reconnect (background/foreground
  /// resume, a transient network drop, or [reauthenticate] cycling the
  /// connection). Callers that depend on server-side room membership (e.g.
  /// [TrackingCubit]'s `order:watch`) must re-issue their join here: a
  /// disconnect silently drops the watcher from its room server-side (WS
  /// contract disconnect semantics) — the app never sees an error for it,
  /// so a plain reconnect without re-joining would leave the UI looking
  /// "connected" while no more updates ever arrive (FR-024).
  void onConnect(void Function() handler) =>
      _register(SocketEvents.connect, (_) => handler());

  void onConnectError(void Function(dynamic) handler) =>
      _register(SocketEvents.connectError, (dynamic e) => handler(e));

  void dispose() {
    _socket?.dispose();
    _socket = null;
    // [_handlers] is intentionally NOT cleared — see the class doc comment.
  }

  void _register(String event, dynamic Function(dynamic) handler) {
    _handlers.add((event, handler));
    _socket?.on(event, handler);
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    return const <String, dynamic>{};
  }
}
