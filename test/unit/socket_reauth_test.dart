import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/auth_interceptor.dart';
import 'package:mobile_app/core/network/token_store.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakeSecureStoragePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FlutterSecureStoragePlatform {}

class _FakeAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final headers = {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    };
    if (options.path.contains('/auth/refresh')) {
      return ResponseBody.fromString(
        '{"accessToken":"new-token","refreshToken":"new-refresh"}',
        200,
        headers: headers,
      );
    }
    return ResponseBody.fromString(
      '{"message":"unauthorized"}',
      401,
      headers: headers,
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUp(() {
    final backing = <String, String>{};
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
    'onTokenRefreshed fires exactly once after a successful silent refresh — '
    'the hook TrackingSocket.reauthenticate() is wired to (FR-020)',
    () async {
      final tokenStore = TokenStore();
      await tokenStore.save(access: 'old-token', refresh: 'old-refresh');

      final adapter = _FakeAdapter();
      final refreshDio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;

      var refreshedCallCount = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter
        ..interceptors.add(
          AuthInterceptor(
            tokenStore: tokenStore,
            refreshDio: refreshDio,
            onSessionExpired: ([cause]) async {},
            onTokenRefreshed: () async {
              refreshedCallCount++;
            },
          ),
        );

      await Future.wait([
        dio
            .get<dynamic>('/protected-a')
            .then<Response<dynamic>?>((r) => r)
            .catchError((_) => null),
        dio
            .get<dynamic>('/protected-b')
            .then<Response<dynamic>?>((r) => r)
            .catchError((_) => null),
      ]);

      // One refresh event -> one reauthenticate hook, not once per request.
      expect(refreshedCallCount, 1);
      expect(await tokenStore.accessToken, 'new-token');
    },
  );

  test(
    'reauthenticate() is a safe no-op before the socket has ever connected',
    () async {
      final tokenStore = TokenStore();
      await tokenStore.save(access: 'token', refresh: 'refresh');
      final socket = TrackingSocket(tokenStore: tokenStore);

      await expectLater(socket.reauthenticate(), completes);
    },
  );
}
