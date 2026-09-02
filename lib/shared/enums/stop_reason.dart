/// spec 011 FR-005/FR-006/SC-003: the fixed vocabulary a driver answers a
/// stop prompt with.
///
/// Mirrors `src/common/enums/stop-reason.enum.ts` value for value. The two
/// have no shared source of truth across the language boundary, so
/// `test/unit/stop_reason_test.dart` pins them together — the same guard
/// `NotificationType` carries, and for the same reason: this enum's whole
/// job is that the transport administrator reads back exactly what the
/// driver picked, which fails silently the moment one side invents a value
/// the other does not know.
///
/// Fixed rather than free text so a driver at the roadside — possibly
/// dealing with the problem itself — can answer in one tap. [other] is the
/// escape hatch, and is the only value that carries free text with it.
enum StopReason {
  traffic('TRAFFIC'),
  vehicleProblem('VEHICLE_PROBLEM'),
  restOrPrayer('REST_OR_PRAYER'),
  refuelling('REFUELLING'),
  roadClosure('ROAD_CLOSURE'),
  accident('ACCIDENT'),
  other('OTHER');

  const StopReason(this.wire);

  /// The exact string the platform expects and returns.
  final String wire;

  String toWire() => wire;

  /// The translation key for this reason's label, in both languages.
  String get labelKey => 'driver.stop_reason.$name';

  /// Unlike `NotificationType`, there is no `unknown` fallback here: this
  /// enum is only ever *sent*, and a value the app cannot name is one it
  /// could not have offered as a choice in the first place.
  static StopReason? fromWire(String wire) {
    for (final reason in StopReason.values) {
      if (reason.wire == wire) return reason;
    }
    return null;
  }
}
