import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/features/stations/domain/entities/station.dart';
import 'package:mobile_app/features/stations/domain/usecases/get_stations.dart';
import 'package:mobile_app/features/stations/domain/usecases/set_favourite_station.dart';
import 'package:mobile_app/features/stations/presentation/cubit/stations_cubit.dart';
import 'package:mobile_app/features/stations/presentation/cubit/stations_state.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetStations extends Mock implements GetStations {}

class _MockSetFavouriteStation extends Mock implements SetFavouriteStation {}

void main() {
  late _MockGetStations getStations;
  late _MockSetFavouriteStation setFavouriteStation;

  Station stationAt(String id, {bool isFavourite = false, bool isDefault = false}) =>
      Station(
        id: id,
        regionCode: 'RIYADH',
        governorateCode: 'RIYADH_CITY',
        location: const GeoPoint(lat: 24.7, lng: 46.6),
        addressText: 'Address $id',
        isDefault: isDefault,
        isFavourite: isFavourite,
      );

  setUp(() {
    getStations = _MockGetStations();
    setFavouriteStation = _MockSetFavouriteStation();
  });

  StationsCubit build() => StationsCubit(
    getStations: getStations,
    setFavouriteStation: setFavouriteStation,
  );

  blocTest<StationsCubit, StationsState>(
    'load() succeeds and emits the fetched stations',
    setUp: () {
      when(
        () => getStations(),
      ).thenAnswer((_) async => Right([stationAt('s1', isDefault: true)]));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const StationsState.loading(),
      StationsState.loaded([stationAt('s1', isDefault: true)]),
    ],
  );

  blocTest<StationsCubit, StationsState>(
    'load() failure surfaces the mapped Failure',
    setUp: () {
      when(
        () => getStations(),
      ).thenAnswer((_) async => const Left(Failure.server()));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      StationsState.loading(),
      StationsState.failure(Failure.server()),
    ],
  );

  blocTest<StationsCubit, StationsState>(
    'toggleFavourite() success replaces the station in place',
    setUp: () {
      when(
        () => getStations(),
      ).thenAnswer((_) async => Right([stationAt('s1'), stationAt('s2')]));
      when(
        () => setFavouriteStation('s1', true),
      ).thenAnswer((_) async => Right(stationAt('s1', isFavourite: true)));
    },
    build: build,
    act: (cubit) async {
      await cubit.load();
      await cubit.toggleFavourite('s1', true);
    },
    expect: () => [
      const StationsState.loading(),
      StationsState.loaded([stationAt('s1'), stationAt('s2')]),
      StationsState.loaded([
        stationAt('s1', isFavourite: true),
        stationAt('s2'),
      ]),
    ],
  );

  blocTest<StationsCubit, StationsState>(
    'toggleFavourite() failure leaves the list untouched',
    setUp: () {
      when(
        () => getStations(),
      ).thenAnswer((_) async => Right([stationAt('s1')]));
      when(
        () => setFavouriteStation('s1', true),
      ).thenAnswer((_) async => const Left(Failure.server()));
    },
    build: build,
    act: (cubit) async {
      await cubit.load();
      final ok = await cubit.toggleFavourite('s1', true);
      expect(ok, isFalse);
    },
    expect: () => [
      const StationsState.loading(),
      StationsState.loaded([stationAt('s1')]),
    ],
  );
}
