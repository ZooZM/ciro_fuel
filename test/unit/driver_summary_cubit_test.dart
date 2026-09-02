import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/features/delivery/domain/entities/driver_standing.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_driver_summary.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/driver_summary_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/driver_summary_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetDriverSummary extends Mock implements GetDriverSummary {}

/// spec 007 T080 (FR-031/FR-045): an absent `ratingAverage` must reach the
/// cubit's state as `null`, never coerced to a numeral — the screen is
/// what turns that into "not yet rated" copy, but the cubit must not
/// collapse the distinction first. A zero `deliveriesToday` is a normal
/// loaded value, distinct from a load failure.
void main() {
  late _MockGetDriverSummary getDriverSummary;

  setUp(() {
    getDriverSummary = _MockGetDriverSummary();
  });

  DriverSummaryCubit build() =>
      DriverSummaryCubit(getDriverSummary: getDriverSummary);

  blocTest<DriverSummaryCubit, DriverSummaryState>(
    'a never-rated driver loads with ratingAverage null, never 0',
    setUp: () {
      when(getDriverSummary.call).thenAnswer(
        (_) async => const Right(
          DriverStanding(ratingCount: 0, deliveriesToday: 0, readyForWork: true),
        ),
      );
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const DriverSummaryState.loading(),
      const DriverSummaryState.loaded(
        DriverStanding(ratingCount: 0, deliveriesToday: 0, readyForWork: true),
      ),
    ],
    verify: (cubit) {
      final state = cubit.state as DriverSummaryLoaded;
      expect(state.summary.ratingAverage, isNull);
      expect(state.summary.deliveriesToday, 0);
    },
  );

  blocTest<DriverSummaryCubit, DriverSummaryState>(
    'a rated driver loads with the real average',
    setUp: () {
      when(getDriverSummary.call).thenAnswer(
        (_) async => const Right(
          DriverStanding(
            ratingAverage: 4.5,
            ratingCount: 9,
            deliveriesToday: 3,
            readyForWork: true,
          ),
        ),
      );
    },
    build: build,
    act: (cubit) => cubit.load(),
    verify: (cubit) {
      final state = cubit.state as DriverSummaryLoaded;
      expect(state.summary.ratingAverage, 4.5);
      expect(state.summary.deliveriesToday, 3);
    },
  );

  blocTest<DriverSummaryCubit, DriverSummaryState>(
    'a load failure is distinct from a zero count — never shown as 0',
    setUp: () {
      when(getDriverSummary.call).thenAnswer(
        (_) async => const Left(Failure.network()),
      );
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const DriverSummaryState.loading(),
      const DriverSummaryState.failure(Failure.network()),
    ],
  );

  blocTest<DriverSummaryCubit, DriverSummaryState>(
    'clear() resets to loading, so the next driver never sees the last one\'s figures',
    build: build,
    seed: () => const DriverSummaryState.loaded(
      DriverStanding(
        ratingAverage: 5,
        ratingCount: 1,
        deliveriesToday: 1,
        readyForWork: true,
      ),
    ),
    act: (cubit) => cubit.clear(),
    expect: () => [const DriverSummaryState.loading()],
  );
}
