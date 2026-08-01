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

  /// 400/409/422 — invalid input, illegal state transition, wrong OTP.
  const factory Failure.validation(String message) = ValidationFailure;

  /// 429 — carries the server-provided retry-after when available.
  const factory Failure.throttled({Duration? retryAfter}) = ThrottledFailure;

  /// 5xx or an unrecognized shape. Never surfaces internal detail to the UI.
  const factory Failure.server() = ServerFailure;
}
