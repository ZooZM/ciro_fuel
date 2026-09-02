import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_stations.dart';
import '../../domain/usecases/set_favourite_station.dart';
import 'stations_state.dart';

/// The client's own stations screen (spec 005 T109/T110) — one instance per
/// screen visit, like `InvoicesCubit`. `GetStations`/`SetFavouriteStation`
/// are the only two operations this app ever performs on a station: FR-036b
/// gives a CLIENT no create/rename/delete affordance at all.
class StationsCubit extends Cubit<StationsState> {
  StationsCubit({
    required GetStations getStations,
    required SetFavouriteStation setFavouriteStation,
  }) : _getStations = getStations,
       _setFavouriteStation = setFavouriteStation,
       super(const StationsState.loading());

  final GetStations _getStations;
  final SetFavouriteStation _setFavouriteStation;

  Future<void> load() async {
    emit(const StationsState.loading());
    final result = await _getStations();
    result.fold(
      (failure) => emit(StationsState.failure(failure)),
      (stations) => emit(StationsState.loaded(stations)),
    );
  }

  /// Persists the flip through the backend (FR-037) before applying it —
  /// on failure the list is left exactly as it was, no optimistic update to
  /// roll back.
  Future<bool> toggleFavourite(String stationId, bool isFavourite) async {
    final current = state;
    if (current is! StationsLoaded) return false;

    final result = await _setFavouriteStation(stationId, isFavourite);
    return result.fold((_) => false, (updated) {
      emit(
        StationsState.loaded([
          for (final s in current.stations)
            if (s.id == updated.id) updated else s,
        ]),
      );
      return true;
    });
  }
}
