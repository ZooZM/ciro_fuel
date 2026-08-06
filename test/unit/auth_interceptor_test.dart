import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/auth_interceptor.dart';
import 'package:mobile_app/core/network/token_store.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _InMemorySecureStorage extends Mock
    with MockPlatformInterfaceMixin
    implements FlutterSecureStoragePlatform {}

/// Simulates the backend: `/auth/refresh` always issues `new-token`; any
/// other path 401s unless called with `Bearer new-token`. Counts refresh
/// calls so the test can assert single-flight behavior directly.
class _FakeAdapter implements HttpClientAdapter {
  int refreshCallCount = 0;
  bool refreshShouldFail = false;

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
      refreshCallCount++;
      if (refreshShouldFail) {
        return ResponseBody.fromString(
          '{"message":"invalid refresh token"}',
          401,
          headers: headers,
        );
      }
      return ResponseBody.fromString(
        '{"accessToken":"new-token","refreshToken":"new-refresh"}',
        200,
        headers: headers,
      );
    }

    final authHeader = options.headers['Authorization'] as String?;
    if (authHeader == 'Bearer new-token') {
      return ResponseBody.fromString('{"ok":true}', 200, headers: headers);
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
  late TokenStore tokenStore;
  late _FakeAdapter adapter;
  late Dio dio;
  late int sessionExpiredCalls;

  setUp(() async {
    final storagePlatform = _InMemorySecureStorage();
    final backing = <String, String>{};
    when(
      () => storagePlatform.read(
        key: any(named: 'key'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((invocation) async {
      return backing[invocation.namedArguments[#key] as String];
    });
    when(
      () => storagePlatform.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((invocation) async {
      backing[invocation.namedArguments[#key] as String] =
          invocation.namedArguments[#value] as String;
    });
    when(
      () => storagePlatform.delete(
        key: any(named: 'key'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((invocation) async {
      backing.remove(invocation.namedArguments[#key] as String);
    });
    FlutterSecureStoragePlatform.instance = storagePlatform;

    tokenStore = TokenStore();
    await tokenStore.save(access: 'old-token', refresh: 'old-refresh');

    adapter = _FakeAdapter();
    sessionExpiredCalls = 0;

    final refreshDio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter;

    dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthInterceptor(
          tokenStore: tokenStore,
          refreshDio: refreshDio,
          onSessionExpired: () async {
            sessionExpiredCalls++;
          },
        ),
      );
  });

  test(
    'concurrent 401s trigger exactly one refresh; both requests replay once and succeed',
    () async {
      final results = await Future.wait([
        dio.get<dynamic>('/protected-a'),
        dio.get<dynamic>('/protected-b'),
      ]);

      expect(results[0].statusCode, 200);
      expect(results[1].statusCode, 200);
      expect(adapter.refreshCallCount, 1);
      expect(sessionExpiredCalls, 0);
      expect(await tokenStore.accessToken, 'new-token');
    },
  );

  test(
    'unrecoverable refresh clears the session and fires onSessionExpired once',
    () async {
      adapter.refreshShouldFail = true;

      final results = await Future.wait([
        dio
            .get<dynamic>('/protected-a')
            .then<Response<dynamic>?>((r) => r)
            .catchError((_) => null),
        dio
            .get<dynamic>('/protected-b')
            .then<Response<dynamic>?>((r) => r)
            .catchError((_) => null),
      ]);

      expect(results.every((r) => r == null), isTrue);
      expect(sessionExpiredCalls, 1);
      expect(await tokenStore.accessToken, isNull);
    },
  );

  test(
    'a single 401 is retried once and succeeds without a redundant refresh call',
    () async {
      final response = await dio.get<dynamic>('/protected-a');

      expect(response.statusCode, 200);
      expect(adapter.refreshCallCount, 1);
    },
  );
}
