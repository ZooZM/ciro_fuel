import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/token_store.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class _FakeSecureStoragePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FlutterSecureStoragePlatform {}

class _FakeSocket extends Mock implements io.Socket {}

/// A fake `io.Socket` plus a [fire] callback that invokes whatever handlers
/// `TrackingSocket` attached for an event — the same path a live frame takes.
class _FakeSocketHarness {
  _FakeSocketHarness() {
    when(() => socket.on(any(), any())).thenAnswer((invocation) {
      final event = invocation.positionalArguments[0] as String;
      final handler =
          invocation.positionalArguments[1] as dynamic Function(dynamic);
      _handlers.putIfAbsent(event, () => []).add(handler);
      return () {};
    });
    when(() => socket.dispose()).thenReturn(null);
    when(() => socket.connect()).thenReturn(socket);
    when(() => socket.disconnect()).thenReturn(socket);
  }

  final _FakeSocket socket = _FakeSocket();
  final Map<String, List<dynamic Function(dynamic)>> _handlers = {};

  void fire(String event, dynamic data) {
    for (final handler in _handlers[event] ?? const []) {
      handler(data);
    }
  }
}

void main() {
  setUpAll(() => registerFallbackValue((dynamic _) {}));

  setUp(() {
    final backing = <String, String>{'access_token': 'test-token'};
    final storagePlatform = _FakeSecureStoragePlatform();
    when(
      () => storagePlatform.read(
        key: any(named: 'key'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((i) async => backing[i.namedArguments[#key] as String]);
    when(
      () => storagePlatform.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((i) async {
      backing[i.namedArguments[#key] as String] =
          i.namedArguments[#value] as String;
    });
    when(
      () => storagePlatform.delete(
        key: any(named: 'key'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((i) async => backing.remove(i.namedArguments[#key] as String));
    FlutterSecureStoragePlatform.instance = storagePlatform;
  });

  test(
    'a handler registered BEFORE connect() fires after it — the exact case '
    'that silently subscribed to nothing on main (debt #6)',
    () async {
      final harness = _FakeSocketHarness();
      final socket = TrackingSocket(
        tokenStore: TokenStore(),
        socketFactory: (_, __) => harness.socket,
      );

      final received = <Map<String, dynamic>>[];
      socket.onNotification(received.add);

      // Nothing is attached while there is no underlying socket.
      verifyNever(() => harness.socket.on(any(), any()));

      await socket.connect();

      // connect() flushed the registry onto the socket it built.
      harness.fire('notification:new', {
        'type': 'ORDER_ASSIGNED',
        'orderId': 'o1',
      });
      expect(received, [
        {'type': 'ORDER_ASSIGNED', 'orderId': 'o1'},
      ]);
    },
  );

  test(
    'handlers survive a connect() -> dispose() -> connect() cycle — connect() '
    'builds a NEW socket each call, so the durable registry is what carries '
    'a once-registered app-lifetime listener across a sign-out/sign-in',
    () async {
      final harnesses = [_FakeSocketHarness(), _FakeSocketHarness()];
      var next = 0;
      final socket = TrackingSocket(
        tokenStore: TokenStore(),
        socketFactory: (_, __) => harnesses[next++].socket,
      );

      final received = <Map<String, dynamic>>[];
      socket.onNotification(received.add); // registered once, before any connect

      await socket.connect(); // builds harnesses[0]
      socket.dispose(); // sign-out: socket torn down, registry kept
      await socket.connect(); // sign-in: builds harnesses[1]

      // The second socket got the handler even though it was never
      // re-registered after dispose().
      harnesses[1].fire('notification:new', {'type': 'ORDER_ASSIGNED'});
      expect(received, [
        {'type': 'ORDER_ASSIGNED'},
      ]);

      // Attached exactly once on the live socket — not stacked.
      verify(() => harnesses[1].socket.on('notification:new', any())).called(1);
    },
  );

  test('dispose() disposes the underlying socket', () async {
    final harness = _FakeSocketHarness();
    final socket = TrackingSocket(
      tokenStore: TokenStore(),
      socketFactory: (_, __) => harness.socket,
    );
    await socket.connect();
    socket.dispose();
    verify(() => harness.socket.dispose()).called(1);
  });
}
