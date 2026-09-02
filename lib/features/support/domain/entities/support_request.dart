import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_request.freezed.dart';

/// spec 005 T119 — a client's raised problem (`POST/GET /support/requests`).
/// `state` is the backend's raw `SupportRequestState` string
/// (`'SUBMITTED'` | `'ACKNOWLEDGED'`, FR-039a) rather than a converted
/// enum: exactly two values, never expected to grow, and the UI only ever
/// needs "acknowledged or not" (see [isAcknowledged]).
@freezed
abstract class SupportRequest with _$SupportRequest {
  const SupportRequest._();

  const factory SupportRequest({
    required String id,
    required String topic,
    required String message,
    required String state,
    required DateTime createdAt,
    String? orderId,
    DateTime? acknowledgedAt,
  }) = _SupportRequest;

  bool get isAcknowledged => state == 'ACKNOWLEDGED';
}
