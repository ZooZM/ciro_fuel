import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/utils/encoded_polyline.dart';

void main() {
  group('EncodedPolyline.decode', () {
    test('decodes the reference example from Google’s own documentation', () {
      // `_p~iF~ps|U_ulLnnqC_mqNvxq`@` is the worked example in the encoded
      // polyline algorithm spec, and decodes to these three points.
      final points = EncodedPolyline.decode(r'_p~iF~ps|U_ulLnnqC_mqNvxq`@');

      expect(points, hasLength(3));
      expect(points[0].lat, closeTo(38.5, 1e-6));
      expect(points[0].lng, closeTo(-120.2, 1e-6));
      expect(points[1].lat, closeTo(40.7, 1e-6));
      expect(points[1].lng, closeTo(-120.95, 1e-6));
      expect(points[2].lat, closeTo(43.252, 1e-6));
      expect(points[2].lng, closeTo(-126.453, 1e-6));
    });

    test('handles an empty string as an empty route', () {
      expect(EncodedPolyline.decode(''), isEmpty);
    });

    test('returns what decoded rather than throwing on a truncated string', () {
      // A cut-off payload must still draw the part that parsed — the route is
      // decoration, and losing the tracking screen over it would be worse.
      final full = EncodedPolyline.decode(r'_p~iF~ps|U_ulLnnqC_mqNvxq`@');
      final truncated = EncodedPolyline.decode(r'_p~iF~ps|U_ulLnnqC_mqNvxq');

      expect(truncated.length, lessThan(full.length));
      expect(truncated.first.lat, closeTo(38.5, 1e-6));
    });

    test('does not spin on a corrupt run of continuation bytes', () {
      // Every byte here sets the continuation bit; the shift guard is what
      // stops this looping forever.
      expect(EncodedPolyline.decode(r'~~~~~~~~~~~~~~~~~~~~'), isEmpty);
    });
  });
}
