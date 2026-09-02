/// Mirrors backend `TankMaterial` (spec 008 FR-048a/g). Recorded fact only —
/// never used client-side to derive which fuel grades a tank may carry;
/// that is always `Order.tankSummary`'s own explicit data.
enum TankMaterial {
  iron('IRON'),
  aluminium('ALUMINIUM');

  const TankMaterial(this.wire);

  final String wire;

  static TankMaterial fromWire(String wire) => switch (wire) {
    'IRON' => TankMaterial.iron,
    'ALUMINIUM' => TankMaterial.aluminium,
    _ => throw ArgumentError.value(wire, 'wire', 'Unknown TankMaterial'),
  };

  String toWire() => wire;
}
