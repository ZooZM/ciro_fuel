/// Mirrors backend `fuelType` (feature 001 fuel catalog / pricing). Wire
/// values are `PETROL_91`/`PETROL_95`, not `GASOLINE_*` — the Dart member
/// names stay as `gasoline91`/`gasoline95` (widely referenced for display),
/// only the wire string each carries matches the backend's actual enum.
enum FuelType {
  diesel('DIESEL'),
  gasoline91('PETROL_91'),
  gasoline95('PETROL_95'),
  kerosene('KEROSENE');

  const FuelType(this.wire);

  final String wire;

  static FuelType fromWire(String wire) => switch (wire) {
    'DIESEL' => FuelType.diesel,
    'PETROL_91' => FuelType.gasoline91,
    'PETROL_95' => FuelType.gasoline95,
    'KEROSENE' => FuelType.kerosene,
    _ => throw ArgumentError.value(wire, 'wire', 'Unknown FuelType'),
  };

  String toWire() => wire;
}
