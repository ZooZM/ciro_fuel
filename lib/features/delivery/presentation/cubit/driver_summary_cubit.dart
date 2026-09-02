import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_driver_summary.dart';
import 'driver_summary_state.dart';

/// Drives the driver home header's rating/day-count/duty figures (spec 007
/// US5) — `GET /drivers/me/summary`, the platform's own derivation, never a
/// value the app computes or holds across sign-ins itself.
class DriverSummaryCubit extends Cubit<DriverSummaryState> {
  DriverSummaryCubit({required GetDriverSummary getDriverSummary})
    : _getDriverSummary = getDriverSummary,
      super(const DriverSummaryState.loading());

  final GetDriverSummary _getDriverSummary;

  Future<void> load() async {
    emit(const DriverSummaryState.loading());
    final result = await _getDriverSummary();
    if (isClosed) return;
    result.fold(
      (failure) => emit(DriverSummaryState.failure(failure)),
      (summary) => emit(DriverSummaryState.loaded(summary)),
    );
  }

  /// Called on sign-out and on every session-ending revocation (spec 006
  /// FR-008/SC-002), same reasoning as `DeliveryCubit.clear()`: a
  /// session-lifetime singleton, so nothing else resets it between drivers.
  void clear() => emit(const DriverSummaryState.loading());
}
