import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/station.dart';

part 'stations_state.freezed.dart';

@freezed
sealed class StationsState with _$StationsState {
  const factory StationsState.loading() = StationsLoading;

  const factory StationsState.loaded(List<Station> stations) =
      StationsLoaded;

  const factory StationsState.failure(Failure failure) = StationsFailureState;
}
