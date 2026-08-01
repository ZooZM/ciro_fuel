/// Mirrors backend OTP `purpose` (feature 001 WS/REST contracts).
enum OtpPurpose {
  arrival('ARRIVAL'),
  delivery('DELIVERY');

  const OtpPurpose(this.wire);

  final String wire;

  static OtpPurpose fromWire(String wire) => switch (wire) {
    'ARRIVAL' => OtpPurpose.arrival,
    'DELIVERY' => OtpPurpose.delivery,
    _ => throw ArgumentError.value(wire, 'wire', 'Unknown OtpPurpose'),
  };

  String toWire() => wire;
}
