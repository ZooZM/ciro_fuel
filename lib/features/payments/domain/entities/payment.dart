import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

/// A confirmed payment (`GET /payments`, spec 005 FR-023) — the client's
/// own settled Sadad/Mada charges. `rawPayload` never reaches the app: the
/// backend projects it away at the query level (T074), so there is no
/// field for it here to accidentally surface.
@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    @JsonKey(name: '_id') required String id,
    required String orderId,
    required double amount,
    required String currency,
    required String gateway,
    required DateTime createdAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, Object?> json) =>
      _$PaymentFromJson(json);
}
