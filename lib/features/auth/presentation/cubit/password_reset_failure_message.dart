import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/network/error_codes.dart';

/// Non-enumerating, user-facing copy for the password-recovery flow (spec
/// 006 US3), mirroring `phoneVerificationFailureMessageKey`'s shape.
///
/// FR-024: `RESET_CODE_INVALID` is one message regardless of whether the
/// code was wrong, expired, superseded, or attempt-locked-out —
/// distinguishing them would tell an attacker which wall they hit.
String passwordResetFailureMessageKey(Failure failure) => switch (failure) {
  ValidationFailure(:final code) when code == ErrorCodes.resetCodeInvalid =>
    ErrorKeys.resetCodeInvalid,
  ValidationFailure(:final code) when code == ErrorCodes.resetRateLimited =>
    ErrorKeys.resetRateLimited,
  NetworkFailure() => ErrorKeys.network,
  ThrottledFailure() => ErrorKeys.throttled,
  AuthFailure() ||
  NotFoundFailure() ||
  ValidationFailure() ||
  ServerFailure() => ErrorKeys.generic,
};

/// The wait `RESET_RATE_LIMITED` states, in whole minutes rounded up —
/// 61 seconds must read as 2 minutes, never 1, since understating the
/// wait is what sends a driver back before the server will actually
/// accept another attempt. A pure function (no `.tr()`) so the rounding
/// itself is directly testable without a localization harness.
int rateLimitWaitMinutes(Failure failure) {
  final seconds = failure is ValidationFailure
      ? (failure.extra?['retryAfterSeconds'] as num?)?.toInt()
      : null;
  final minutes = ((seconds ?? 60) / 60).ceil();
  return minutes.clamp(1, 999);
}

/// Resolves the message key above to real copy, filling in
/// `RESET_RATE_LIMITED`'s wait (FR-025) from the failure's `extra` —
/// the one case here that needs data the key alone can't carry.
String passwordResetFailureMessage(Failure failure) {
  if (failure is ValidationFailure && failure.code == ErrorCodes.resetRateLimited) {
    return ErrorKeys.resetRateLimited.tr(
      namedArgs: {'minutes': '${rateLimitWaitMinutes(failure)}'},
    );
  }
  return passwordResetFailureMessageKey(failure).tr();
}
