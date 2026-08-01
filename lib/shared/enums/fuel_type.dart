/// Mirrors backend `fuelType` (feature 001 fuel catalog / pricing).
enum FuelType {
  diesel('DIESEL'),
  gasoline91('GASOLINE_91'),
  gasoline95('GASOLINE_95');

  const FuelType(this.wire);

  final String wire;

  static FuelType fromWire(String wire) => switch (wire) {
    'DIESEL' => FuelType.diesel,
    'GASOLINE_91' => FuelType.gasoline91,
    'GASOLINE_95' => FuelType.gasoline95,
    _ => throw ArgumentError.value(wire, 'wire', 'Unknown FuelType'),
  };

  String toWire() => wire;
}
