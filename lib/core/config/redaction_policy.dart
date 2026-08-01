/// Redaction policy (SC-008): no OTP code, access token, or refresh token
/// may reach a log line, crash report, or analytics event in full.
///
/// Enforcement points already in place — extend this list when a new type
/// carries one of these values:
/// - [OtpChallenge.toString] (`features/orders/domain/entities/otp_challenge.dart`)
///   overrides freezed's generated toString to print `[REDACTED]` instead
///   of the OTP code.
/// - [LoginResponseModel.toString] (`features/auth/data/models/login_response_model.dart`)
///   does the same for `accessToken`/`refreshToken`.
/// - [TokenStore] (`core/network/token_store.dart`) never exposes tokens as
///   printable fields — only via async getters read on demand.
/// - The DRIVER build never constructs an [OtpChallenge] at all (see
///   `features/delivery/presentation/cubit/otp_verify_cubit.dart`); OTP
///   entry is a bare `String` method parameter, never held in state.
/// - [error_boundary.dart]'s `debugPrint` only fires under `kDebugMode` and
///   is never wired to a release-mode crash reporter.
///
/// Before adding any logging framework, analytics SDK, or crash reporter,
/// verify it does not serialize full object graphs (which would bypass the
/// toString overrides above via reflection-based serializers) and does not
/// log raw HTTP request/response bodies for `/auth/*` or `*/otp/*` routes.
library;
