import '../../../../core/error/failure.dart';
import '../../../../core/localization/translation_keys.dart';

/// Non-enumerating, user-facing copy for a login failure (FR-007) — never
/// reveals whether the account exists or which credential was wrong.
///
/// Returns a translation *key* rather than finished copy, so this mapping
/// stays free of locale concerns; the caller resolves it with `.tr()`.
String authFailureMessageKey(Failure failure) => switch (failure) {
  AuthFailure() => ErrorKeys.invalidCredentials,
  ThrottledFailure() => ErrorKeys.throttled,
  NetworkFailure() => ErrorKeys.network,
  NotFoundFailure() ||
  ValidationFailure() ||
  ServerFailure() => ErrorKeys.generic,
};
