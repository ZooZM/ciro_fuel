import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/entities/value_objects.dart';

part 'price_breakdown.freezed.dart';
part 'price_breakdown.g.dart';

/// `POST /orders/quote`'s response — a breakdown plus the token that proves
/// order creation asked for exactly these figures (research R10). Never
/// persisted by the app; the token is opaque and round-tripped as-is.
@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    required PriceBreakdown breakdown,
    required String quoteToken,
    required DateTime expiresAt,
  }) = _Quote;

  factory Quote.fromJson(Map<String, Object?> json) => _$QuoteFromJson(json);
}
