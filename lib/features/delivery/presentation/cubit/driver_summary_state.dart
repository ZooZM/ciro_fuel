import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/driver_standing.dart';

part 'driver_summary_state.freezed.dart';

@freezed
sealed class DriverSummaryState with _$DriverSummaryState {
  const factory DriverSummaryState.loading() = DriverSummaryLoading;
  const factory DriverSummaryState.loaded(DriverStanding summary) =
      DriverSummaryLoaded;
  const factory DriverSummaryState.failure(Failure failure) =
      DriverSummaryFailureState;
}
