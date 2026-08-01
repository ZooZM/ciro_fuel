import 'dart:math' as math;

import '../../../../core/config/constants.dart';

/// The backend's displacement/heartbeat/floor policy (WS contract, research
/// R4), as a pure decision with no platform dependency — deliberately
/// separate from [LocationStreamService] so it's directly unit-testable
/// without a real or mocked GPS plugin.
class LocationEmitGate {
  ({double lat, double lng})? _lastAccepted;
  DateTime? _lastAcceptedAt;

  /// Returns whether a fix at (`lat`, `lng`) taken at `now` should be sent,
  /// and records it as the new baseline if so.
  bool shouldEmit({
    required double lat,
    required double lng,
    required DateTime now,
  }) {
    final elapsed = _lastAcceptedAt == null ? null : now.difference(_lastAcceptedAt!);

    // Local abuse-ceiling mirroring the server's 1 accepted update / 5 s.
    if (elapsed != null && elapsed < AppDurations.locationEmitFloor) {
      return false;
    }

    final displacement = _lastAccepted == null
        ? double.infinity
        : _distanceMeters(_lastAccepted!.lat, _lastAccepted!.lng, lat, lng);
    final pastDisplacement = displacement > AppDistances.locationDisplacementMeters;
    final pastHeartbeat = elapsed == null || elapsed >= AppDurations.locationHeartbeat;

    if (!pastDisplacement && !pastHeartbeat) return false;

    _lastAccepted = (lat: lat, lng: lng);
    _lastAcceptedAt = now;
    return true;
  }

  void reset() {
    _lastAccepted = null;
    _lastAcceptedAt = null;
  }

  /// Haversine distance in meters — the same formula geolocator's platform
  /// interface uses, reimplemented here to keep this class dependency-free.
  static double _distanceMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadiusMeters = 6378137.0;
    double toRadians(double degrees) => degrees * math.pi / 180;

    final dLat = toRadians(lat2 - lat1);
    final dLng = toRadians(lng2 - lng1);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.pow(math.sin(dLng / 2), 2) *
            math.cos(toRadians(lat1)) *
            math.cos(toRadians(lat2));
    final c = 2 * math.asin(math.sqrt(a));
    return earthRadiusMeters * c;
  }
}
