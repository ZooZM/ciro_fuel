import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/location_sample.dart';

part 'tracking_state.freezed.dart';

@freezed
sealed class TrackingState with _$TrackingState {
  const factory TrackingState.disconnected() = TrackingDisconnected;
  const factory TrackingState.connecting() = TrackingConnecting;

  /// `stale` is populated by the periodic staleness check added in US4
  /// (T063); this story only wires the live location stream itself.
  const factory TrackingState.watching({
    LocationSample? location,
    @Default(false) bool stale,
  }) = TrackingWatching;

  const factory TrackingState.notTrackable() = TrackingNotTrackable;
  const factory TrackingState.failure(Failure failure) = TrackingFailureState;
}
