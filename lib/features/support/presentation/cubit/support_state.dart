import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/support_request.dart';

part 'support_state.freezed.dart';

@freezed
sealed class SupportState with _$SupportState {
  const factory SupportState.loading() = SupportLoading;

  /// `isSubmitting`/`submitError` cover a new request in flight — the
  /// already-loaded history stays on screen rather than being replaced by a
  /// whole-screen failure state (spec 005 T121, same shape as
  /// `ProfileState.loaded`'s save fields).
  const factory SupportState.loaded({
    required List<SupportRequest> requests,
    @Default(false) bool isSubmitting,
    Failure? submitError,
  }) = SupportLoaded;

  const factory SupportState.failure(Failure failure) = SupportFailureState;
}
