/// Domain-safe seam over the platform's positioning stack (spec 008
/// FR-030c) — no `geolocator` import anywhere near this file, mirroring how
/// [NfcReader] isolates `nfc_manager`. Distinct from
/// `LocationStreamService`, which pushes a *stream* of positions to the
/// tracking socket for the customer's map: this reads exactly one fix, on
/// demand, to accompany a single verification attempt.
///
/// The two must not be conflated. The streamed position is throttled to
/// 50 m / 3 minutes and can be far staler than that when the driver has
/// been parked — which is precisely the situation at a depot gate — so the
/// geofence is never evaluated against it.
abstract interface class PositionReader {
  /// One fresh fix, or `null` when the device cannot produce one — services
  /// disabled, permission refused, or no fix inside the time limit. A
  /// missing fix is an ordinary, expected answer, never an exception: the
  /// caller decides what a delivery step does without one.
  Future<PositionFix?> currentFix();
}

/// A single position, in the platform's own longitude/latitude order.
class PositionFix {
  const PositionFix({required this.longitude, required this.latitude});

  final double longitude;
  final double latitude;
}
