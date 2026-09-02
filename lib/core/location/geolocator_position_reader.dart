import 'package:geolocator/geolocator.dart';

import 'position_reader.dart';

/// The only concrete [PositionReader]. Every failure mode — services off,
/// permission denied or permanently denied, no fix before the time limit —
/// collapses to `null`, because the caller's decision is the same in all of
/// them: the attempt cannot carry a position, so the platform will refuse
/// the loading stage and the driver is told to enable location.
class GeolocatorPositionReader implements PositionReader {
  const GeolocatorPositionReader();

  /// Long enough for a cold fix in a depot yard, short enough that a driver
  /// standing at the gate is not left watching a spinner.
  static const Duration _timeLimit = Duration(seconds: 12);

  @override
  Future<PositionFix?> currentFix() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: _timeLimit,
        ),
      );
      return PositionFix(
        longitude: position.longitude,
        latitude: position.latitude,
      );
    } on Exception {
      // Includes `TimeoutException` from `timeLimit` and the plugin's own
      // permission/service exceptions — all of them mean the same thing
      // here: no fix.
      return null;
    }
  }
}
