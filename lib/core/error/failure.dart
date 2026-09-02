import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Every error a repository can surface, produced solely by
/// [ErrorInterceptor] (Constitution Principle III: one centralized shaping
/// layer). Raw `DioException`s never escape the data layer.
@freezed
sealed class Failure with _$Failure {
  /// Bad/absent connectivity, timeout, or an unparseable response.
  const factory Failure.network() = NetworkFailure;

  /// Session could not be established or renewed (401 after refresh failed,
  /// or 403).
  const factory Failure.auth({@Default(false) bool forbidden}) = AuthFailure;

  /// 404, including cross-tenant access — deliberately carries no detail
  /// about which case it was (FR-023).
  const factory Failure.notFound() = NotFoundFailure;

  /// 400/409/422 (and any other status carrying a recognised application
  /// error code, e.g. the 502 `SMS_SEND_FAILED`) — invalid input, illegal
  /// state transition, wrong OTP. `code` is the backend's `ErrorCode` enum
  /// value (feature 005) when the response carried one — e.g. `QUOTE_STALE`
  /// vs `CREDIT_LIMIT_EXCEEDED`, both 409 — so callers branch on a named
  /// constant (see `error_codes.dart`) rather than matching `message` text.
  /// `null` for the older, code-less validation errors that predate this.
  /// `extra` carries whatever additional JSON the response included beyond
  /// `message`/`error` — e.g. `QUOTE_STALE`'s `currentBreakdown` — so a
  /// caller that needs it (T062) doesn't have to re-fetch or re-parse the
  /// raw response; most call sites ignore it entirely.
  const factory Failure.validation(
    String message, {
    String? code,
    Map<String, Object?>? extra,
  }) = ValidationFailure;

  /// 429 — carries the server-provided retry-after when available.
  const factory Failure.throttled({Duration? retryAfter}) = ThrottledFailure;

  /// 5xx or an unrecognized shape. Never surfaces internal detail to the UI.
  const factory Failure.server() = ServerFailure;
}
