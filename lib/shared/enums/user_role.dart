/// Mirrors backend `UserRole` (feature 004: `COMPANY_ADMIN` split into a
/// Fuel Company tier and a Transportation Company tier). The only place
/// role wire strings are parsed — no role literal appears elsewhere
/// (Principle I).
enum UserRole {
  superAdmin('SUPER_ADMIN'),
  fuelCompanyAdmin('FUEL_COMPANY_ADMIN'),
  transportCompanyAdmin('TRANSPORT_COMPANY_ADMIN'),
  client('CLIENT'),
  driver('DRIVER');

  const UserRole(this.wire);

  final String wire;

  static UserRole fromWire(String wire) => switch (wire) {
    'SUPER_ADMIN' => UserRole.superAdmin,
    'FUEL_COMPANY_ADMIN' => UserRole.fuelCompanyAdmin,
    'TRANSPORT_COMPANY_ADMIN' => UserRole.transportCompanyAdmin,
    'CLIENT' => UserRole.client,
    'DRIVER' => UserRole.driver,
    _ => throw ArgumentError.value(wire, 'wire', 'Unknown UserRole'),
  };

  String toWire() => wire;
}
