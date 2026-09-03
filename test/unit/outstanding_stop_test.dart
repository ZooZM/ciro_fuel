import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/entities/stop_event.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/stop_origin.dart';
import 'package:mobile_app/shared/enums/stop_reason.dart';

StopEvent _stop({
  String id = 's',
  StopOrigin origin = StopOrigin.detected,
  DateTime? reasonGivenAt,
  DateTime? resolvedAt,
  DateTime? suppressedUntil,
}) => StopEvent(
  id: id,
  origin: origin,
  detectedAt: DateTime.utc(2026, 1, 1, 12),
  reason: reasonGivenAt == null ? null : StopReason.traffic,
  reasonGivenAt: reasonGivenAt,
  resolvedAt: resolvedAt,
  suppressedUntil: suppressedUntil,
);

Order _order(List<StopEvent> stops) => Order(
  id: 'o1',
  status: OrderStatus.inTransit,
  fuelType: FuelType.diesel,
  quantityLiters: 500,
  statusChangedAt: DateTime.utc(2026, 1, 1, 12),
  stopEvents: stops,
);

void main() {
  final t = DateTime.utc(2026, 1, 1, 12, 30);

  group('outstandingStop — unresolved AND unanswered, both clauses required', () {
    test('non-null only for a stop with reasonGivenAt AND resolvedAt absent', () {
      final stop = _stop();
      expect(stop.isOutstanding, isTrue);
      expect(_order([stop]).outstandingStop, stop);
    });

    test('null for an ANSWERED stop (reasonGivenAt set) — not re-asked', () {
      final stop = _stop(reasonGivenAt: t);
      expect(stop.isOutstanding, isFalse);
      expect(_order([stop]).outstandingStop, isNull);
    });

    test('null for a RESOLVED stop (resolvedAt set) — admin already closed it', () {
      final stop = _stop(resolvedAt: t);
      expect(stop.isOutstanding, isFalse);
      expect(_order([stop]).outstandingStop, isNull);
    });

    test('null for a DECLARED stop — it arrives with both timestamps set', () {
      final stop = _stop(
        origin: StopOrigin.declared,
        reasonGivenAt: t,
        resolvedAt: t,
        suppressedUntil: t.add(const Duration(hours: 1)),
      );
      expect(stop.isOutstanding, isFalse);
      expect(_order([stop]).outstandingStop, isNull);
    });

    test('picks the first outstanding stop when several exist', () {
      final answered = _stop(id: 'a', reasonGivenAt: t);
      final open1 = _stop(id: 'open-1');
      final open2 = _stop(id: 'open-2');
      expect(_order([answered, open1, open2]).outstandingStop, open1);
    });

    test('empty stopEvents -> null', () {
      expect(_order(const []).outstandingStop, isNull);
    });
  });
}
