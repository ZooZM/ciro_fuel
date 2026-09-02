import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_credit_standing.dart';
import 'credit_state.dart';

/// Drives the client credit-limit screen (spec 005 T083) — sources the same
/// `GET /users/me/credit` the home dashboard's finance cards read (FR-026),
/// so the two can never disagree.
class CreditCubit extends Cubit<CreditState> {
  CreditCubit({required GetCreditStanding getCreditStanding})
    : _getCreditStanding = getCreditStanding,
      super(const CreditState.loading());

  final GetCreditStanding _getCreditStanding;

  Future<void> load() async {
    emit(const CreditState.loading());
    final result = await _getCreditStanding();
    if (isClosed) return;
    result.fold(
      (failure) => emit(CreditState.failure(failure)),
      (standing) => emit(CreditState.loaded(standing)),
    );
  }
}
