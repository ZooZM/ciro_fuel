import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/orders/data/models/order_mapper.dart';

Map<String, Object?> _order({Object? priceBreakdown}) => {
  '_id': 'o1',
  'status': 'PENDING_APPROVAL',
  'fuelType': 'DIESEL',
  'quantityLiters': 5000,
  'statusChangedAt': '2026-09-13T20:00:00.000Z',
  'deliveryLocation': {
    'type': 'Point',
    'coordinates': [46.6753, 24.7136],
  },
  'priceBreakdown': ?priceBreakdown,
};

void main() {
  /// The delivery leg is priced by the transport company that performs it, and
  /// that company is not chosen until the fuel company ROUTES the order. So the
  /// platform sends no `deliveryFee` at all until then — a quote has none, and
  /// neither does an order that has only been placed.
  ///
  /// The mapper used to read it as `value['deliveryFee']! as num`. That `!` was
  /// safe only while the platform invented a figure for a hauler nobody had
  /// chosen; the moment it stopped, the assertion threw and EVERY order and
  /// quote the customer opened failed to parse.
  group('OrderMapper.priceBreakdown — the transport line is absent before routing', () {
    test('parses an un-routed order, leaving deliveryFee null rather than throwing', () {
      final order = OrderMapper.fromJson(
        _order(
          priceBreakdown: {
            'fuelLineTotal': 12500.0,
            // No `deliveryFee` key at all — exactly what the platform sends.
            'serviceFee': 125.0,
            'tax': 1893.75,
            'total': 14518.75,
            'unitPrice': 2.5,
            'serviceFeePercent': 1.0,
            'taxRatePercent': 15.0,
            'currency': 'SAR',
          },
        ),
      );

      expect(order.priceBreakdown, isNotNull);
      expect(order.priceBreakdown!.deliveryFee, isNull);
      // Null is a DIFFERENT fact from zero: zero would tell the station owner
      // delivery is free, when the truth is that nobody has priced it yet.
      expect(order.priceBreakdown!.deliveryFee, isNot(0));
      expect(order.priceBreakdown!.total, 14518.75);
    });

    test('reads the real transport price once routing has set one', () {
      final order = OrderMapper.fromJson(
        _order(
          priceBreakdown: {
            'fuelLineTotal': 12500.0,
            'deliveryFee': 300.0,
            'serviceFee': 125.0,
            'tax': 1938.75,
            'total': 14863.75,
            'unitPrice': 2.5,
            'serviceFeePercent': 1.0,
            'taxRatePercent': 15.0,
            'currency': 'SAR',
          },
        ),
      );

      expect(order.priceBreakdown!.deliveryFee, 300.0);
      // The components still sum to the total, transport included.
      final b = order.priceBreakdown!;
      expect(
        ((b.fuelLineTotal + b.deliveryFee! + b.serviceFee + b.tax) * 100).round(),
        (b.total * 100).round(),
      );
    });
  });
}
