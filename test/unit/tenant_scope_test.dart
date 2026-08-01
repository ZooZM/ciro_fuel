import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/auth/data/datasources/auth_remote_data_source.dart';

/// FR-023: company scope comes only from the decoded JWT / `AuthUser`. The
/// app must never place a client-chosen `companyId` in a request body,
/// query string, or header — the backend derives and enforces scope itself.
/// This test captures outgoing requests and asserts that invariant for
/// every datasource method that exists so far; extend it as new
/// datasources are added in later user stories.
class _CapturingAdapter implements HttpClientAdapter {
  final List<RequestOptions> captured = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured.add(options);
    return ResponseBody.fromString(
      '{"message":"stub"}',
      500,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void _expectNoClientChosenCompanyId(RequestOptions options) {
  expect(
    options.queryParameters.containsKey('companyId'),
    isFalse,
    reason: '${options.path} query must not carry a client-set companyId',
  );
  final data = options.data;
  if (data is Map) {
    expect(
      data.containsKey('companyId'),
      isFalse,
      reason: '${options.path} body must not carry a client-set companyId',
    );
  }
}

void main() {
  test('AuthRemoteDataSource.login never sends a client-chosen companyId', () async {
    final adapter = _CapturingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter;
    final dataSource = AuthRemoteDataSourceImpl(dio);

    try {
      await dataSource.login(email: 'jane@ciro.fuel', password: 'secret');
    } on DioException {
      // Expected: the stub adapter always returns a non-2xx response.
    }

    expect(adapter.captured, hasLength(1));
    _expectNoClientChosenCompanyId(adapter.captured.single);
  });

  test('AuthRemoteDataSource.me never sends a client-chosen companyId', () async {
    final adapter = _CapturingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter;
    final dataSource = AuthRemoteDataSourceImpl(dio);

    try {
      await dataSource.me();
    } on DioException {
      // Expected: the stub adapter always returns a non-2xx response.
    }

    expect(adapter.captured, hasLength(1));
    _expectNoClientChosenCompanyId(adapter.captured.single);
  });
}
