/// Mirrors backend `InvoiceState` (spec 004 FR-020).
enum InvoiceState {
  issued('ISSUED'),
  settled('SETTLED'),
  voided('VOID');

  const InvoiceState(this.wire);

  final String wire;

  static InvoiceState fromWire(String wire) => switch (wire) {
    'ISSUED' => InvoiceState.issued,
    'SETTLED' => InvoiceState.settled,
    'VOID' => InvoiceState.voided,
    _ => throw ArgumentError.value(wire, 'wire', 'Unknown InvoiceState'),
  };

  String toWire() => wire;
}
