/// Mirrors backend `UserRole` (feature 001). The only place role wire
/// strings are parsed — no role literal appears elsewhere (Principle I).
enum UserRole {
  superAdmin('SUPER_ADMIN'),
  companyAdmin('COMPANY_ADMIN'),
  client('CLIENT'),
  driver('DRIVER');

  const UserRole(this.wire);

  final String wire;

  static UserRole fromWire(String wire) => switch (wire) {
    'SUPER_ADMIN' => UserRole.superAdmin,
    'COMPANY_ADMIN' => UserRole.companyAdmin,
    'CLIENT' => UserRole.client,
    'DRIVER' => UserRole.driver,
    _ => throw ArgumentError.value(wire, 'wire', 'Unknown UserRole'),
  };

  String toWire() => wire;
}
