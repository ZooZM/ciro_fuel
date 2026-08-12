/// Mirrors backend `PaymentMethod` (spec 004 FR-021): DIRECT (the client
/// pays), DEFERRED (the Transportation Company pays on the client's
/// behalf), CREDIT (drawn against a Fuel-Company-set credit limit).
enum PaymentMethod {
  direct('DIRECT'),
  deferred('DEFERRED'),
  credit('CREDIT');

  const PaymentMethod(this.wire);

  final String wire;

  static PaymentMethod fromWire(String wire) => switch (wire) {
    'DIRECT' => PaymentMethod.direct,
    'DEFERRED' => PaymentMethod.deferred,
    'CREDIT' => PaymentMethod.credit,
    _ => throw ArgumentError.value(wire, 'wire', 'Unknown PaymentMethod'),
  };

  String toWire() => wire;
}
