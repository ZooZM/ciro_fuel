import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/stop_origin.dart';
import '../enums/stop_reason.dart';

part 'stop_event.freezed.dart';

/// One stop on a delivery, as the platform holds it (spec 011 `StopEvent`,
/// feature 013 data-model §4). Read off `Order.stopEvents` — the platform
/// already returns this array to a DRIVER from `GET /orders/:id`; a CLIENT's
/// response omits the key entirely.
///
/// No generated `fromJson`/`toJson`: `OrderMapper` is the sole parser for
/// this entity, hand-written like every other nested `Order` type.
///
/// [reasonGivenAt] and [resolvedAt] carry meaning through **absence** and
/// must stay nullable — absent [reasonGivenAt] is what "unanswered" means,
/// absent [resolvedAt] is what "unresolved" means. Never infer either from
/// [reason]'s presence.
@freezed
abstract class StopEvent with _$StopEvent {
  const factory StopEvent({
    /// The stop's own `_id` — retained server-side precisely so a specific
    /// stop can be addressed (the reason/resolve endpoints take it).
    required String id,
    required StopOrigin origin,
    required DateTime detectedAt,
    StopReason? reason,
    String? reasonText,
    DateTime? reasonGivenAt,
    DateTime? suppressedUntil,
    DateTime? escalatedAt,
    DateTime? resolvedAt,
  }) = _StopEvent;

  const StopEvent._();

  /// The outstanding-question test for a single stop, mirroring the
  /// platform's own `unblockedStopFilter` rather than approximating it:
  /// unresolved **and** unanswered. A `DECLARED` stop arrives with both
  /// timestamps set and correctly never qualifies.
  bool get isOutstanding => resolvedAt == null && reasonGivenAt == null;
}
