import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/submit_rating.dart';
import 'rating_state.dart';

/// spec 007 US6 (FR-037–FR-040): one instance per order-detail screen
/// visit, keyed by orderId — same lifecycle as `OrderDetailCubit`/
/// `PaymentCubit` on the same screen. `OrderDetailCubit` owns re-fetching
/// the order (and therefore its `rating` field) after a successful submit;
/// this cubit owns only the submission itself.
class RatingCubit extends Cubit<RatingState> {
  RatingCubit({required String orderId, required SubmitRating submitRating})
    : _orderId = orderId,
      _submitRating = submitRating,
      super(const RatingState.idle());

  final String _orderId;
  final SubmitRating _submitRating;

  Future<void> submit({required int score, String? review}) async {
    emit(const RatingState.submitting());
    final result = await _submitRating(
      orderId: _orderId,
      score: score,
      review: review,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(RatingState.failure(failure)),
      (rating) => emit(RatingState.submitted(rating)),
    );
  }
}
