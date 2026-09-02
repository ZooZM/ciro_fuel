import '../../features/auth/presentation/cubit/session_cubit.dart';
import '../../features/auth/presentation/cubit/session_revocation_message.dart';
import '../network/token_store.dart';
import 'socket_events.dart';
import 'tracking_socket.dart';

/// Wires the two ways a driver's live session can end without their own
/// action into a local sign-out (spec 006 US5): the primary `session:revoked`
/// push (FR-035), and the handshake-refusal fallback for a device that was
/// disconnected when it went out (FR-035a) — a reconnect attempt's
/// `connect_error` carrying `UNAUTHORIZED`.
///
/// Extracted out of `injector.dart` so this wiring is unit-testable without
/// booting the whole DI graph — a mocked [TrackingSocket] is enough.
class SessionRevocationListener {
  SessionRevocationListener({
    required TrackingSocket trackingSocket,
    required TokenStore tokenStore,
    required SessionCubit sessionCubit,
  }) : _trackingSocket = trackingSocket,
       _tokenStore = tokenStore,
       _sessionCubit = sessionCubit;

  final TrackingSocket _trackingSocket;
  final TokenStore _tokenStore;
  final SessionCubit _sessionCubit;

  /// Call only once the socket is actually connected — i.e. after awaiting
  /// [TrackingSocket.connect], not right after invoking it. Registering
  /// these callbacks any earlier is the exact silent-no-op mistake
  /// `mobile_app/CLAUDE.md` debt #6 already records for `NotificationsCubit`,
  /// which wires its handler in its own constructor, before any socket
  /// exists at all.
  void attach() {
    _trackingSocket.onSessionRevoked(
      (payload) => _endSession(payload['cause'] as String?),
    );
    // Every other reason `authenticateSocket` rejects a handshake also
    // surfaces as `connect_error` (a stale/expired token, none presented at
    // all) — only `UNAUTHORIZED` from a *revoked* session should sign the
    // driver out; an ordinary connectivity blip must not.
    _trackingSocket.onConnectError((err) {
      if (err.toString().contains(SocketAckReasons.unauthorized)) {
        _endSession(null);
      }
    });
  }

  Future<void> _endSession(String? cause) async {
    await _tokenStore.clear();
    _sessionCubit.signOut(reason: sessionRevocationMessage(cause));
  }
}
