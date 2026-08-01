import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/config/constants.dart';
import 'package:mobile_app/features/tracking/domain/entities/location_sample.dart';

void main() {
  final recordedAt = DateTime.utc(2026, 1, 1, 12);

  test('a sample within the stale window is not stale', () {
    final sample = LocationSample(lat: 24.7136, lng: 46.6753, recordedAt: recordedAt);
    final now = recordedAt.add(AppDurations.locationStaleWindow - const Duration(seconds: 1));

    expect(sample.isStale(now), isFalse);
  });

  test('a sample past the stale window is stale', () {
    final sample = LocationSample(lat: 24.7136, lng: 46.6753, recordedAt: recordedAt);
    final now = recordedAt.add(AppDurations.locationStaleWindow + const Duration(seconds: 1));

    expect(sample.isStale(now), isTrue);
  });

  test('staleness is measured from receivedAt (server stamp) when present, not recordedAt', () {
    final receivedAt = recordedAt.add(const Duration(minutes: 2));
    final sample = LocationSample(
      lat: 24.7136,
      lng: 46.6753,
      recordedAt: recordedAt,
      receivedAt: receivedAt,
    );

    // Well past staleness relative to recordedAt, but not relative to
    // receivedAt — receivedAt must be the one that governs.
    final now = receivedAt.add(AppDurations.locationStaleWindow - const Duration(seconds: 1));

    expect(sample.isStale(now), isFalse);
  });

  test('falls back to recordedAt when the server did not include receivedAt', () {
    final sample = LocationSample(lat: 24.7136, lng: 46.6753, recordedAt: recordedAt);
    final now = recordedAt.add(AppDurations.locationStaleWindow + const Duration(minutes: 1));

    expect(sample.isStale(now), isTrue);
  });
}
