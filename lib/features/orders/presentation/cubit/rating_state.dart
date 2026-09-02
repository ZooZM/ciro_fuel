import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';

part 'rating_state.freezed.dart';

/// [RatingFailureState.failure] is the raw [Failure] — ALREADY_RATED and
/// ORDER_NOT_DELIVERED reach the caller as its `ValidationFailure.code`
/// (spec 007 T096), branchable via `error_codes.dart`'s named constants
/// rather than string-matched.
@freezed
sealed class RatingState with _$RatingState {
  const factory RatingState.idle() = RatingIdle;
  const factory RatingState.submitting() = RatingSubmitting;
  const factory RatingState.submitted(OrderRating rating) = RatingSubmitted;
  const factory RatingState.failure(Failure failure) = RatingFailureState;
}
