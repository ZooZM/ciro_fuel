import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/delivery/data/datasources/delivery_remote_data_source.dart';
import 'package:mobile_app/shared/enums/order_status.dart';

/// spec 007 T014/T015: `getActiveOrder()` used to read `response.data!['data']`
/// against `GET /orders`'s real `{ items, nextCursor }` envelope (cursor
/// pagination, spec 005) — a key that endpoint has never actually returned.
/// It would have thrown against the real backend on its very first call.
/// `mobile_app/CLAUDE.md` debt #1 recorded the bug but itself described the
/// wrong shape ("a bare JSON array"); this test is against the shape the
/// backend genuinely sends.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this.body);

  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(body, 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

DeliveryRemoteDataSourceImpl _dataSourceWithBody(String body) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = _ScriptedAdapter(body);
  return DeliveryRemoteDataSourceImpl(dio);
}

void main() {
  test(
    'finds the in-transit order on the real {items, nextCursor} envelope',
    () async {
      final dataSource = _dataSourceWithBody(
        '{"items":[{"id":"o1","status":"IN_TRANSIT","fuelType":"DIESEL",'
        '"quantityLiters":500,"statusChangedAt":"2026-01-01T12:00:00Z"}],'
        '"nextCursor":null}',
      );

      final order = await dataSource.getActiveOrder();

      expect(order, isNotNull);
      expect(order!.id, 'o1');
      expect(order.status, OrderStatus.inTransit);
    },
  );

  test('finds an unloading order among several, skipping terminal ones', () async {
    final dataSource = _dataSourceWithBody(
      '{"items":['
      '{"id":"o1","status":"DELIVERED","fuelType":"DIESEL",'
      '"quantityLiters":100,"statusChangedAt":"2026-01-01T09:00:00Z"},'
      '{"id":"o2","status":"UNLOADING","fuelType":"PETROL_95",'
      '"quantityLiters":200,"statusChangedAt":"2026-01-01T12:00:00Z"}'
      '],"nextCursor":null}',
    );

    final order = await dataSource.getActiveOrder();

    expect(order?.id, 'o2');
    expect(order?.status, OrderStatus.unloading);
  });

  test(
    'a page with no in-transit/unloading order yields null rather than throwing',
    () async {
      final dataSource = _dataSourceWithBody(
        '{"items":['
        '{"id":"o1","status":"DELIVERED","fuelType":"DIESEL",'
        '"quantityLiters":100,"statusChangedAt":"2026-01-01T09:00:00Z"},'
        '{"id":"o2","status":"CANCELLED","fuelType":"DIESEL",'
        '"quantityLiters":100,"statusChangedAt":"2026-01-01T09:00:00Z"}'
        '],"nextCursor":"c2"}',
      );

      expect(await dataSource.getActiveOrder(), isNull);
    },
  );

  test('an empty page yields null', () async {
    final dataSource = _dataSourceWithBody('{"items":[],"nextCursor":null}');

    expect(await dataSource.getActiveOrder(), isNull);
  });

  test(
    'a malformed envelope (the old bare-array shape) throws loudly rather '
    'than silently returning null',
    () async {
      final dataSource = _dataSourceWithBody(
        '{"data":[{"id":"o1","status":"IN_TRANSIT","fuelType":"DIESEL",'
        '"quantityLiters":500,"statusChangedAt":"2026-01-01T12:00:00Z"}]}',
      );

      expect(dataSource.getActiveOrder, throwsA(isA<FormatException>()));
    },
  );
}
