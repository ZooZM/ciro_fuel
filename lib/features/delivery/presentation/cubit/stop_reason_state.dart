import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';

part 'stop_reason_state.freezed.dart';

/// spec 011 US2. Covers both driver flows — answering a detected stop and
/// declaring one — because they differ only in what is sent, not in what the
/// screen has to show.
@freezed
sealed class StopReasonState with _$StopReasonState {
  /// Nothing chosen yet. [needsText] is the whole reason this state carries
  /// anything at all: choosing `OTHER` reveals a text field and nothing else
  /// does (FR-006), and the screen must not have to re-derive that rule.
  const factory StopReasonState.editing({
    @Default(false) bool needsText,
    @Default(false) bool textMissing,
  }) = StopReasonEditing;

  const factory StopReasonState.submitting() = StopReasonSubmitting;

  const factory StopReasonState.sent() = StopReasonSent;

  const factory StopReasonState.failed(Failure failure) = StopReasonFailed;
}
