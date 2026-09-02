import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/network/error_codes.dart';
import 'package:mobile_app/features/orders/domain/usecases/submit_rating.dart';
import 'package:mobile_app/features/orders/presentation/cubit/rating_cubit.dart';
import 'package:mobile_app/features/orders/presentation/cubit/rating_state.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mocktail/mocktail.dart';

class _MockSubmitRating extends Mock implements SubmitRating {}

/// spec 007 T096: submission states progress correctly; ALREADY_RATED and
/// ORDER_NOT_DELIVERED surface as distinct, branchable failures rather than
/// a generic error a caller can't tell apart.
void main() {
  late _MockSubmitRating submitRating;

  setUp(() {
    submitRating = _MockSubmitRating();
  });

  RatingCubit build() =>
      RatingCubit(orderId: 'order-1', submitRating: submitRating);

  blocTest<RatingCubit, RatingState>(
    'a successful submission progresses submitting -> submitted',
    setUp: () {
      when(
        () => submitRating(
          orderId: any(named: 'orderId'),
          score: any(named: 'score'),
          review: any(named: 'review'),
        ),
      ).thenAnswer(
        (_) async => const Right(OrderRating(score: 5, review: 'Great!')),
      );
    },
    build: build,
    act: (cubit) => cubit.submit(score: 5, review: 'Great!'),
    expect: () => const [
      RatingState.submitting(),
      RatingState.submitted(OrderRating(score: 5, review: 'Great!')),
    ],
  );

  blocTest<RatingCubit, RatingState>(
    'ALREADY_RATED is a distinct, branchable failure',
    setUp: () {
      when(
        () => submitRating(
          orderId: any(named: 'orderId'),
          score: any(named: 'score'),
          review: any(named: 'review'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          Failure.validation('already rated', code: ErrorCodes.alreadyRated),
        ),
      );
    },
    build: build,
    act: (cubit) => cubit.submit(score: 3),
    expect: () => const [
      RatingState.submitting(),
      RatingState.failure(
        Failure.validation('already rated', code: ErrorCodes.alreadyRated),
      ),
    ],
    verify: (cubit) {
      final state = cubit.state as RatingFailureState;
      final failure = state.failure as ValidationFailure;
      expect(failure.code, ErrorCodes.alreadyRated);
    },
  );

  blocTest<RatingCubit, RatingState>(
    'ORDER_NOT_DELIVERED is a distinct, branchable failure',
    setUp: () {
      when(
        () => submitRating(
          orderId: any(named: 'orderId'),
          score: any(named: 'score'),
          review: any(named: 'review'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          Failure.validation(
            'not delivered',
            code: ErrorCodes.orderNotDelivered,
          ),
        ),
      );
    },
    build: build,
    act: (cubit) => cubit.submit(score: 3),
    verify: (cubit) {
      final state = cubit.state as RatingFailureState;
      final failure = state.failure as ValidationFailure;
      expect(failure.code, ErrorCodes.orderNotDelivered);
      // The two failure codes must not collapse into the same branch.
      expect(failure.code, isNot(ErrorCodes.alreadyRated));
    },
  );
}
