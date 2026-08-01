import '../../../../core/error/failure.dart';

/// Non-enumerating, user-facing copy for a login failure (FR-007) — never
/// reveals whether the account exists or which credential was wrong.
String authFailureMessage(Failure failure) => switch (failure) {
  AuthFailure() => 'Incorrect email or password.',
  ThrottledFailure() => 'Too many attempts. Please wait and try again.',
  NetworkFailure() => 'Check your connection and try again.',
  NotFoundFailure() ||
  ValidationFailure() ||
  ServerFailure() => 'Something went wrong. Please try again.',
};
