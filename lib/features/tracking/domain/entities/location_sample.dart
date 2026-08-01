import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/constants.dart';

part 'location_sample.freezed.dart';
part 'location_sample.g.dart';

/// A driver-reported position (WS `order:location` payload). `receivedAt`
/// (server stamp) drives staleness (FR-021); falls back to `recordedAt`
/// (driver device time) if the server didn't include one.
@freezed
abstract class LocationSample with _$LocationSample {
  const LocationSample._();

  const factory LocationSample({
    required double lat,
    required double lng,
    required DateTime recordedAt,
    DateTime? receivedAt,
  }) = _LocationSample;

  factory LocationSample.fromJson(Map<String, Object?> json) =>
      _$LocationSampleFromJson(json);

  bool isStale(DateTime now) =>
      now.difference(receivedAt ?? recordedAt) >
      AppDurations.locationStaleWindow;
}
