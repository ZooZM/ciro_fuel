import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/features/support/domain/entities/support_request.dart';
import 'package:mobile_app/features/support/domain/usecases/create_support_request.dart';
import 'package:mobile_app/features/support/domain/usecases/get_support_requests.dart';
import 'package:mobile_app/features/support/presentation/cubit/support_cubit.dart';
import 'package:mobile_app/features/support/presentation/cubit/support_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetSupportRequests extends Mock implements GetSupportRequests {}

class _MockCreateSupportRequest extends Mock implements CreateSupportRequest {}

void main() {
  late _MockGetSupportRequests getSupportRequests;
  late _MockCreateSupportRequest createSupportRequest;

  SupportRequest requestAt(String id, {String state = 'SUBMITTED'}) => SupportRequest(
    id: id,
    topic: 'ORDER_ISSUE',
    message: 'message $id',
    state: state,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  setUp(() {
    getSupportRequests = _MockGetSupportRequests();
    createSupportRequest = _MockCreateSupportRequest();
  });

  SupportCubit build() => SupportCubit(
    getSupportRequests: getSupportRequests,
    createSupportRequest: createSupportRequest,
  );

  blocTest<SupportCubit, SupportState>(
    'loadRequests() succeeds and emits the fetched list',
    setUp: () {
      when(
        () => getSupportRequests(),
      ).thenAnswer((_) async => Right([requestAt('r1')]));
    },
    build: build,
    act: (cubit) => cubit.loadRequests(),
    expect: () => [
      const SupportState.loading(),
      SupportState.loaded(requests: [requestAt('r1')]),
    ],
  );

  blocTest<SupportCubit, SupportState>(
    'loadRequests() failure surfaces the mapped Failure',
    setUp: () {
      when(
        () => getSupportRequests(),
      ).thenAnswer((_) async => const Left(Failure.server()));
    },
    build: build,
    act: (cubit) => cubit.loadRequests(),
    expect: () => const [
      SupportState.loading(),
      SupportState.failure(Failure.server()),
    ],
  );

  blocTest<SupportCubit, SupportState>(
    'submit() success prepends the created request to the list',
    setUp: () {
      when(
        () => getSupportRequests(),
      ).thenAnswer((_) async => Right([requestAt('r1')]));
      when(
        () => createSupportRequest(
          topic: 'ORDER_ISSUE',
          message: 'a new problem',
          orderId: 'o1',
        ),
      ).thenAnswer((_) async => Right(requestAt('r2')));
    },
    build: build,
    act: (cubit) async {
      await cubit.loadRequests();
      await cubit.submit(
        topic: 'ORDER_ISSUE',
        message: 'a new problem',
        orderId: 'o1',
      );
    },
    expect: () => [
      const SupportState.loading(),
      SupportState.loaded(requests: [requestAt('r1')]),
      SupportState.loaded(requests: [requestAt('r1')], isSubmitting: true),
      SupportState.loaded(requests: [requestAt('r2'), requestAt('r1')]),
    ],
  );

  blocTest<SupportCubit, SupportState>(
    'submit() failure keeps the prior list and surfaces submitError',
    setUp: () {
      when(
        () => getSupportRequests(),
      ).thenAnswer((_) async => Right([requestAt('r1')]));
      when(
        () => createSupportRequest(
          topic: 'ORDER_ISSUE',
          message: 'a new problem',
          orderId: null,
        ),
      ).thenAnswer((_) async => const Left(Failure.server()));
    },
    build: build,
    act: (cubit) async {
      await cubit.loadRequests();
      final ok = await cubit.submit(topic: 'ORDER_ISSUE', message: 'a new problem');
      expect(ok, isFalse);
    },
    expect: () => [
      const SupportState.loading(),
      SupportState.loaded(requests: [requestAt('r1')]),
      SupportState.loaded(requests: [requestAt('r1')], isSubmitting: true),
      SupportState.loaded(
        requests: [requestAt('r1')],
        submitError: const Failure.server(),
      ),
    ],
  );
}
