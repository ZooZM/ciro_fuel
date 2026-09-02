import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/enums/stop_reason.dart';
import '../../domain/usecases/declare_stop.dart';
import '../../domain/usecases/submit_stop_reason.dart';
import 'stop_reason_state.dart';

/// spec 011 US2 (FR-005 to FR-008d, SC-003): the driver's side of a stop.
///
/// One cubit for both flows. Answering a detected stop and declaring one
/// ahead of time are the same interaction — pick a reason, add words only
/// for `OTHER` — differing solely in which endpoint the answer goes to and
/// whether a duration rides along. Splitting them would duplicate the one
/// rule that actually matters here, and duplicated rules drift.
///
/// **The reason list is not validated against anything local.** A driver
/// picks from the fixed set the app was built with; the platform is the
/// authority on whether the stop is still answerable, whether it has already
/// escalated, and whether a declaration is allowed right now. This cubit
/// never pre-judges any of that — notably, it does not treat an escalated
/// stop as unanswerable (FR-010), because on the platform a late answer is
/// an ordinary success.
class StopReasonCubit extends Cubit<StopReasonState> {
  StopReasonCubit({
    required SubmitStopReason submitStopReason,
    required DeclareStop declareStop,
  }) : _submitStopReason = submitStopReason,
       _declareStop = declareStop,
       super(const StopReasonState.editing());

  final SubmitStopReason _submitStopReason;
  final DeclareStop _declareStop;

  StopReason? _reason;
  String _text = '';

  StopReason? get selectedReason => _reason;

  /// Selecting is deliberately separate from submitting. A driver at the
  /// roadside taps one of six common reasons and is done (SC-003) — only
  /// `OTHER` puts a keyboard in front of them, which is why `needsText` is
  /// state the screen reads rather than a check it performs.
  void select(StopReason reason) {
    _reason = reason;
    emit(StopReasonState.editing(needsText: reason == StopReason.other));
  }

  void setText(String text) {
    _text = text;
    final current = state;
    // Clears a previous "please describe what happened" the moment the
    // driver starts typing, rather than leaving it under their cursor.
    if (current is StopReasonEditing && current.textMissing && text.trim().isNotEmpty) {
      emit(StopReasonState.editing(needsText: current.needsText));
    }
  }

  /// Answers a detected stop. [stopId] is the one the notification carried —
  /// the platform addresses reasons by stop, not by order, because a
  /// delivery can accumulate several across a journey.
  Future<void> submit({required String orderId, required String stopId}) async {
    final reason = _reason;
    if (reason == null) return;
    if (!_textSatisfied(reason)) return;

    emit(const StopReasonState.submitting());
    final result = await _submitStopReason(
      orderId: orderId,
      stopId: stopId,
      reason: reason,
      reasonText: reason == StopReason.other ? _text.trim() : null,
    );
    if (isClosed) return;
    emit(
      result.fold(
        StopReasonState.failed,
        (_) => const StopReasonState.sent(),
      ),
    );
  }

  /// Declares a stop before one is detected.
  Future<void> declare({
    required String orderId,
    required int expectedDurationMinutes,
  }) async {
    final reason = _reason;
    if (reason == null) return;
    if (!_textSatisfied(reason)) return;

    emit(const StopReasonState.submitting());
    final result = await _declareStop(
      orderId: orderId,
      reason: reason,
      reasonText: reason == StopReason.other ? _text.trim() : null,
      expectedDurationMinutes: expectedDurationMinutes,
    );
    if (isClosed) return;
    emit(
      result.fold(
        StopReasonState.failed,
        (_) => const StopReasonState.sent(),
      ),
    );
  }

  /// FR-006: free text is required for `OTHER` and for nothing else. Checked
  /// here as well as on the platform so a driver with no signal is told
  /// immediately rather than after a round trip that was always going to
  /// fail — the platform stays the authority, this is only politeness.
  bool _textSatisfied(StopReason reason) {
    if (reason != StopReason.other) return true;
    if (_text.trim().isNotEmpty) return true;
    emit(const StopReasonState.editing(needsText: true, textMissing: true));
    return false;
  }
}
