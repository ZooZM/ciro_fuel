import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/orders/presentation/constants/order_presentation.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';

Order _order({
  String? deliveryAddressText,
  String? stationAddressText,
  String? stationName,
}) => Order(
  id: 'o1',
  status: OrderStatus.inTransit,
  fuelType: FuelType.gasoline91,
  quantityLiters: 5000,
  statusChangedAt: DateTime.utc(2026, 8, 18),
  destination: const GeoPoint(lat: 24.7136, lng: 46.6753),
  deliveryAddressText: deliveryAddressText,
  stationAddressText: stationAddressText,
  stationName: stationName,
);

void main() {
  group('OrderPresentation.destinationLabel', () {
    test('prefers the snapshot taken when the order was placed', () {
      // FR-009/FR-030: renaming a station must not rewrite the address on an
      // order already delivered against the old one.
      final label = OrderPresentation.destinationLabel(
        _order(
          deliveryAddressText: 'Old address, as ordered',
          stationAddressText: 'Renamed since',
        ),
      );
      expect(label, 'Old address, as ordered');
    });

    test('falls back to the station address when the snapshot is empty', () {
      // Regression: an order placed before its station had any address on
      // file showed the client raw coordinates, and setting the address
      // afterwards could never fix it — the snapshot stays empty forever.
      final label = OrderPresentation.destinationLabel(
        _order(deliveryAddressText: '', stationAddressText: 'حي العليا، الرياض'),
      );
      expect(label, 'حي العليا، الرياض');
    });

    test('falls back to the station name before printing coordinates', () {
      final label = OrderPresentation.destinationLabel(
        _order(stationName: 'Smoke Test Station'),
      );
      expect(label, 'Smoke Test Station');
    });

    test('prints coordinates only when nothing readable exists', () {
      expect(OrderPresentation.destinationLabel(_order()), '24.7136, 46.6753');
    });
  });
}
