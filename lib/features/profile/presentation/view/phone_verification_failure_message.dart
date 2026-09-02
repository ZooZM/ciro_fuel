import '../../../../core/error/failure.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/network/error_codes.dart';

/// Non-enumerating, user-facing copy for the phone-verification flow
/// (spec 005 FR-035), mirroring `authFailureMessageKey`'s shape. An
/// [AuthFailure] here only ever means the confirm endpoint's 401 (wrong or
/// expired code) — `PhoneVerificationRemoteDataSource.confirmVerification`
/// sets `skipAuthRefresh` precisely so this 401 reaches the cubit as a
/// business-rule outcome rather than being consumed by a silent token
/// refresh first.
///
/// Returns a translation *key*; the caller resolves it with `.tr()`.
String phoneVerificationFailureMessageKey(Failure failure) => switch (failure) {
  ValidationFailure(:final code) when code == ErrorCodes.phoneInUse =>
    ErrorKeys.phoneInUse,
  ValidationFailure(:final code) when code == ErrorCodes.smsSendFailed =>
    ErrorKeys.smsSendFailed,
  AuthFailure() => ErrorKeys.wrongVerificationCode,
  ThrottledFailure() => ErrorKeys.throttled,
  NetworkFailure() => ErrorKeys.network,
  NotFoundFailure() ||
  ValidationFailure() ||
  ServerFailure() => ErrorKeys.generic,
};
