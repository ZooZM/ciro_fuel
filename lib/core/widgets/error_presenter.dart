import 'package:flutter/material.dart';

import '../error/failure.dart';

/// The single place a [Failure] is turned into user-facing copy
/// (Constitution Principle III) — no internal detail (status codes,
/// exception messages, stack traces) ever reaches the UI (FR-025).
/// [ValidationFailure] is the one variant that already carries a
/// backend-supplied, user-safe message (e.g. a specific field error).
String failureMessage(Failure failure) => switch (failure) {
  AuthFailure() => 'You need to sign in again.',
  NetworkFailure() => 'Check your connection and try again.',
  NotFoundFailure() => "We couldn't find that.",
  ValidationFailure(:final message) => message,
  ThrottledFailure(:final retryAfter) =>
    retryAfter != null
        ? 'Too many attempts. Try again in ${retryAfter.inMinutes} min.'
        : 'Too many attempts. Please wait and try again.',
  ServerFailure() => 'Something went wrong. Please try again.',
};

/// Shows [failure] as a transient SnackBar using the shared mapping above.
void presentFailure(BuildContext context, Failure failure) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failureMessage(failure))));
}
