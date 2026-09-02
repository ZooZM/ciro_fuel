import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/orders/data/models/order_mapper.dart';

Map<String, Object?> _order({Object? driverLocation}) => {
  '_id': 'o1',
  'status': 'IN_TRANSIT',
  'fuelType': 'PETROL_91',
  'quantityLiters': 5000,
  'statusChangedAt': '2026-08-17T20:00:00.000Z',
  'deliveryLocation': {
    'type': 'Point',
    'coordinates': [46.6753, 24.7136],
  },
  'driverLocation': ?driverLocation,
};

void main() {
  // The tracking map and the remaining-distance figure both read the
  // driver's position. It used to arrive only over the `/tracking` socket,
  // which the gateway throttles to 50m of movement or a 3-minute heartbeat —
  // so a client opening the screen saw a blank map and a "—" distance for
  // minutes, while the backend already knew where the truck was (it derives
  // `etaMinutes` from exactly that point). The order now carries it.
  group('OrderMapper.driverLocation', () {
    test('reads the GeoJSON position the backend sends', () {
      final order = OrderMapper.fromJson(
        _order(
          driverLocation: {
            'type': 'Point',
            // [lng, lat] — GeoJSON order, the reverse of the entity's.
            'coordinates': [46.6790, 24.7180],
          },
        ),
      );

      expect(order.driverLocation, isNotNull);
      expect(order.driverLocation!.lat, closeTo(24.7180, 1e-9));
      expect(order.driverLocation!.lng, closeTo(46.6790, 1e-9));
    });

    test('is null when the backend omits it, never a fabricated point', () {
      // Omitted whenever no driver is assigned, or the assigned driver has
      // no position on file — the client must see "unknown", not a guess.
      expect(OrderMapper.fromJson(_order()).driverLocation, isNull);
    });

    test('does not disturb the destination it shares a parser with', () {
      final order = OrderMapper.fromJson(_order());
      expect(order.destination!.lat, closeTo(24.7136, 1e-9));
      expect(order.destination!.lng, closeTo(46.6753, 1e-9));
    });
  });
}
