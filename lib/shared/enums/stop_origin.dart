/// Mirrors backend `StopOrigin` (`src/common/enums/stop-origin.enum.ts`) and
/// the dashboard's `web_dashboard/src/constants/stop-events.ts` — how a stop
/// on a delivery came to exist. The transport administrator reads back
/// exactly what this value says, so a member present on one surface and
/// absent on another fails quietly (a missing label beside a real stop),
/// never loudly.
///
/// - [detected] — the platform noticed the truck had not moved and asked.
/// - [declared] — the driver announced the stop before anyone asked; it
///   arrives already answered and already resolved.
/// - [blocked] — the driver cannot reach the destination and is asking for
///   help; written unresolved and escalated to the transporter immediately
///   (feature 013 US5a, research R5).
enum StopOrigin {
  detected('DETECTED'),
  declared('DECLARED'),
  blocked('BLOCKED');

  const StopOrigin(this.wire);

  /// The exact string the platform sends and expects.
  final String wire;

  String toWire() => wire;

  /// Unknown values throw rather than degrade: a stop the app cannot name
  /// is one it must not silently misrender next to a real delivery.
  static StopOrigin fromWire(String wire) => switch (wire) {
    'DETECTED' => StopOrigin.detected,
    'DECLARED' => StopOrigin.declared,
    'BLOCKED' => StopOrigin.blocked,
    _ => throw ArgumentError.value(wire, 'wire', 'Unknown StopOrigin'),
  };
}
