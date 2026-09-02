import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_standing.freezed.dart';
part 'credit_standing.g.dart';

/// `GET /users/me/credit` (spec 005 FR-026/FR-027) — computed live by the
/// backend from the same derivation that refuses an over-limit order, never
/// a second figure the app keeps of its own. Every field is null together
/// when the client has no credit facility at all (FR-027) — never
/// substituted with zero, which would read as "a facility of nothing"
/// rather than "no facility".
@freezed
abstract class CreditStanding with _$CreditStanding {
  const factory CreditStanding({
    double? creditLimit,
    double? consumed,
    double? available,
  }) = _CreditStanding;

  factory CreditStanding.fromJson(Map<String, Object?> json) =>
      _$CreditStandingFromJson(json);
}
