import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/credit_standing.dart';

part 'credit_state.freezed.dart';

@freezed
sealed class CreditState with _$CreditState {
  const factory CreditState.loading() = CreditLoading;
  const factory CreditState.loaded(CreditStanding standing) = CreditLoaded;
  const factory CreditState.failure(Failure failure) = CreditLoadFailure;
}
