/// Mirrors backend `VerificationMethod` (spec 008 FR-036c). The app submits
/// this as which action the driver just performed — tapping a card or
/// scanning a code — never as an assertion that verification succeeded;
/// the platform alone decides that (FR-022).
enum VerificationMethod {
  nfcCard('NFC_CARD'),
  qrCode('QR_CODE');

  const VerificationMethod(this.wire);

  final String wire;

  static VerificationMethod fromWire(String wire) => switch (wire) {
    'NFC_CARD' => VerificationMethod.nfcCard,
    'QR_CODE' => VerificationMethod.qrCode,
    _ => throw ArgumentError.value(wire, 'wire', 'Unknown VerificationMethod'),
  };

  String toWire() => wire;
}
