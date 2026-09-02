import '../../shared/entities/value_objects.dart';

/// Decodes Google's [encoded polyline algorithm][1] — the compact string the
/// Directions API returns in place of a coordinate list.
///
/// Hand-rolled rather than pulled in as a dependency: it is one well-defined
/// loop, and the alternatives bundle a whole maps toolkit for it.
///
/// [1]: https://developers.google.com/maps/documentation/utilities/polylinealgorithm
abstract final class EncodedPolyline {
  /// Returns the points in order. A malformed or truncated string yields
  /// whatever decoded cleanly rather than throwing — a partial route still
  /// draws, and the tracking screen must not fail over a cosmetic line.
  static List<GeoPoint> decode(String encoded) {
    final points = <GeoPoint>[];
    var index = 0;
    var lat = 0;
    var lng = 0;

    while (index < encoded.length) {
      final latDelta = _nextDelta(encoded, index);
      if (latDelta == null) break;
      index = latDelta.nextIndex;
      lat += latDelta.value;

      final lngDelta = _nextDelta(encoded, index);
      if (lngDelta == null) break;
      index = lngDelta.nextIndex;
      lng += lngDelta.value;

      // The algorithm carries five decimal places as integers.
      points.add(GeoPoint(lat: lat / 1e5, lng: lng / 1e5));
    }

    return points;
  }

  /// Reads one zig-zag-encoded, chunked varint starting at [start].
  /// Null when the string ends mid-value.
  static _Delta? _nextDelta(String encoded, int start) {
    var index = start;
    var shift = 0;
    var result = 0;
    int chunk;

    do {
      if (index >= encoded.length) return null;
      chunk = encoded.codeUnitAt(index++) - 63;
      result |= (chunk & 0x1f) << shift;
      shift += 5;
      // A value cannot legitimately need more than six chunks; refusing to
      // keep shifting stops a corrupt string spinning here.
      if (shift > 30) return null;
    } while (chunk >= 0x20);

    // Odd values are negative, per the zig-zag encoding.
    return _Delta(
      value: (result & 1) != 0 ? ~(result >> 1) : result >> 1,
      nextIndex: index,
    );
  }
}

class _Delta {
  const _Delta({required this.value, required this.nextIndex});

  final int value;
  final int nextIndex;
}
