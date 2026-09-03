import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/orders/data/models/order_mapper.dart';
import 'package:mobile_app/shared/enums/stop_origin.dart';
import 'package:mobile_app/shared/enums/stop_reason.dart';

Map<String, Object?> _order({Object? stopEvents}) => {
  '_id': 'o1',
  'status': 'IN_TRANSIT',
  'fuelType': 'PETROL_91',
  'quantityLiters': 5000,
  'statusChangedAt': '2026-08-17T20:00:00.000Z',
  'deliveryLocation': {
    'type': 'Point',
    'coordinates': [46.6753, 24.7136],
  },
  'stopEvents': ?stopEvents,
};

void main() {
  group('OrderMapper — stopEvents', () {
    test('parses every field of a driver order payload', () {
      final order = OrderMapper.fromJson(
        _order(
          stopEvents: [
            {
              '_id': 'stop-1',
              'origin': 'DETECTED',
              'detectedAt': '2026-08-17T20:10:00.000Z',
            },
            {
              '_id': 'stop-2',
              'origin': 'BLOCKED',
              'detectedAt': '2026-08-17T20:20:00.000Z',
              'reason': 'ROAD_CLOSURE',
              'reasonText': 'bridge out',
              'reasonGivenAt': '2026-08-17T20:20:00.000Z',
              'escalatedAt': '2026-08-17T20:20:00.000Z',
            },
            {
              '_id': 'stop-3',
              'origin': 'DECLARED',
              'detectedAt': '2026-08-17T20:30:00.000Z',
              'reason': 'REST_OR_PRAYER',
              'reasonGivenAt': '2026-08-17T20:30:00.000Z',
              'suppressedUntil': '2026-08-17T20:45:00.000Z',
              'resolvedAt': '2026-08-17T20:30:00.000Z',
            },
          ],
        ),
      );

      expect(order.stopEvents, hasLength(3));

      final detected = order.stopEvents[0];
      expect(detected.id, 'stop-1');
      expect(detected.origin, StopOrigin.detected);
      expect(
        detected.detectedAt,
        DateTime.parse('2026-08-17T20:10:00.000Z'),
      );
      expect(detected.reason, isNull);
      expect(detected.reasonGivenAt, isNull);
      expect(detected.resolvedAt, isNull);

      final blocked = order.stopEvents[1];
      expect(blocked.origin, StopOrigin.blocked);
      expect(blocked.reason, StopReason.roadClosure);
      expect(blocked.reasonText, 'bridge out');
      expect(blocked.reasonGivenAt, isNotNull);
      expect(blocked.escalatedAt, isNotNull);
      expect(blocked.suppressedUntil, isNull);
      expect(blocked.resolvedAt, isNull);

      final declared = order.stopEvents[2];
      expect(declared.origin, StopOrigin.declared);
      expect(declared.reason, StopReason.restOrPrayer);
      expect(declared.suppressedUntil, isNotNull);
      expect(declared.resolvedAt, isNotNull);
    });

    test(
      'a payload with NO stopEvents key at all parses cleanly to an empty '
      "list — the CLIENT's response omits it entirely, and both personas "
      'share one entity and one parser',
      () {
        final order = OrderMapper.fromJson(_order());
        expect(order.stopEvents, isEmpty);
        expect(order.outstandingStop, isNull);
      },
    );

    test('id also accepts a bare `id` key, and skips malformed entries', () {
      final order = OrderMapper.fromJson(
        _order(
          stopEvents: [
            {'id': 'stop-x', 'origin': 'DETECTED', 'detectedAt': '2026-08-17T20:10:00.000Z'},
            {'origin': 'DETECTED'}, // no id / detectedAt -> skipped
            'not a map', // skipped
          ],
        ),
      );
      expect(order.stopEvents, hasLength(1));
      expect(order.stopEvents.single.id, 'stop-x');
    });
  });
}
