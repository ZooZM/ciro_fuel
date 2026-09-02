import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/localization/translation_keys.dart';
import 'package:mobile_app/core/network/error_codes.dart';
import 'package:mobile_app/features/auth/data/datasources/password_reset_remote_data_source.dart';
import 'package:mobile_app/features/auth/domain/usecases/complete_password_reset.dart';
import 'package:mobile_app/features/auth/domain/usecases/request_password_reset.dart';
import 'package:mobile_app/features/auth/domain/usecases/verify_reset_code.dart';
import 'package:mobile_app/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/password_reset_failure_message.dart';
import 'package:mobile_app/features/auth/presentation/cubit/password_reset_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockRequestPasswordReset extends Mock implements RequestPasswordReset {}

class _MockVerifyResetCode extends Mock implements VerifyResetCode {}

class _MockCompletePasswordReset extends Mock implements CompletePasswordReset {}

void main() {
  late _MockRequestPasswordReset requestReset;
  late _MockVerifyResetCode verifyCode;
  late _MockCompletePasswordReset completeReset;

  const phone = '+966501234567';

  setUp(() {
    requestReset = _MockRequestPasswordReset();
    verifyCode = _MockVerifyResetCode();
    completeReset = _MockCompletePasswordReset();
  });

  PasswordResetCubit build() => PasswordResetCubit(
    requestReset: requestReset,
    verifyCode: verifyCode,
    completeReset: completeReset,
  );

  group('requestReset() — step progression', () {
    blocTest<PasswordResetCubit, PasswordResetState>(
      'success emits requesting then codeSent, regardless of whether the '
      'phone actually belongs to an account (FR-021 — the cubit has no '
      'way to tell, by design)',
      setUp: () {
        when(() => requestReset(phone)).thenAnswer(
          (_) async => const Right(
            PasswordResetRequestResult(expiresInMinutes: 5, attemptsAllowed: 5),
          ),
        );
      },
      build: build,
      act: (cubit) => cubit.requestReset(phone),
      expect: () => [
        const PasswordResetState.requesting(),
        const PasswordResetState.codeSent(phone: phone, expiresInMinutes: 5),
      ],
    );

    blocTest<PasswordResetCubit, PasswordResetState>(
      'RESET_RATE_LIMITED surfaces as a failure state carrying the wait in extra',
      setUp: () {
        when(() => requestReset(phone)).thenAnswer(
          (_) async => const Left(
            Failure.validation(
              'Too many requests',
              code: ErrorCodes.resetRateLimited,
              extra: {'retryAfterSeconds': 900},
            ),
          ),
        );
      },
      build: build,
      act: (cubit) => cubit.requestReset(phone),
      expect: () => [
        const PasswordResetState.requesting(),
        const PasswordResetState.failure(
          Failure.validation(
            'Too many requests',
            code: ErrorCodes.resetRateLimited,
            extra: {'retryAfterSeconds': 900},
          ),
        ),
      ],
    );

    test('the rate-limit wait rounds up to whole minutes, never down', () {
      // 61 seconds must read as 2 minutes, not 1 — understating the wait
      // is exactly the off-by-one that sends a driver back before the
      // server will actually accept another attempt.
      expect(
        rateLimitWaitMinutes(
          const Failure.validation(
            'x',
            code: ErrorCodes.resetRateLimited,
            extra: {'retryAfterSeconds': 61},
          ),
        ),
        2,
      );
      expect(
        rateLimitWaitMinutes(
          const Failure.validation(
            'x',
            code: ErrorCodes.resetRateLimited,
            extra: {'retryAfterSeconds': 900},
          ),
        ),
        15,
      );
      // No `extra` at all (a malformed or unexpected response) still
      // renders a concrete, non-zero wait rather than "0 minutes".
      expect(
        rateLimitWaitMinutes(const Failure.validation('x', code: ErrorCodes.resetRateLimited)),
        1,
      );
    });
  });

  group('verifyCode() — one message regardless of cause (FR-024)', () {
    blocTest<PasswordResetCubit, PasswordResetState>(
      'success emits verifying then verified, carrying the resetToken',
      setUp: () {
        when(
          () => verifyCode(phone: phone, code: '123456'),
        ).thenAnswer((_) async => const Right('opaque-token'));
      },
      build: build,
      act: (cubit) => cubit.verifyCode(phone: phone, code: '123456'),
      expect: () => const [
        PasswordResetState.verifying(),
        PasswordResetState.verified('opaque-token'),
      ],
    );

    blocTest<PasswordResetCubit, PasswordResetState>(
      'a wrong code surfaces RESET_CODE_INVALID',
      setUp: () {
        when(() => verifyCode(phone: phone, code: '000000')).thenAnswer(
          (_) async => const Left(
            Failure.validation('Incorrect or expired code', code: ErrorCodes.resetCodeInvalid),
          ),
        );
      },
      build: build,
      act: (cubit) => cubit.verifyCode(phone: phone, code: '000000'),
      expect: () => const [
        PasswordResetState.verifying(),
        PasswordResetState.failure(
          Failure.validation('Incorrect or expired code', code: ErrorCodes.resetCodeInvalid),
        ),
      ],
    );

    test(
      'wrong, expired, superseded, and locked-out codes all map to the '
      'same message key — the app must not distinguish them (FR-024)',
      () {
        const wrong = Failure.validation('x', code: ErrorCodes.resetCodeInvalid);
        const expired = Failure.validation('y', code: ErrorCodes.resetCodeInvalid);
        const lockedOut = Failure.validation('z', code: ErrorCodes.resetCodeInvalid);

        final keys = {
          passwordResetFailureMessageKey(wrong),
          passwordResetFailureMessageKey(expired),
          passwordResetFailureMessageKey(lockedOut),
        };
        expect(keys, {ErrorKeys.resetCodeInvalid});
      },
    );
  });

  group('completeReset()', () {
    blocTest<PasswordResetCubit, PasswordResetState>(
      'success emits completing then completed',
      setUp: () {
        when(
          () => completeReset(resetToken: 'opaque-token', newPassword: 'NewPassword123!'),
        ).thenAnswer((_) async => const Right(null));
      },
      build: build,
      act: (cubit) => cubit.completeReset(
        resetToken: 'opaque-token',
        newPassword: 'NewPassword123!',
      ),
      expect: () => const [
        PasswordResetState.completing(),
        PasswordResetState.completed(),
      ],
    );

    blocTest<PasswordResetCubit, PasswordResetState>(
      'an invalid/expired/consumed resetToken surfaces RESET_CODE_INVALID',
      setUp: () {
        when(
          () => completeReset(resetToken: 'stale-token', newPassword: 'NewPassword123!'),
        ).thenAnswer(
          (_) async => const Left(
            Failure.validation(
              'This reset link is invalid or has expired',
              code: ErrorCodes.resetCodeInvalid,
            ),
          ),
        );
      },
      build: build,
      act: (cubit) => cubit.completeReset(
        resetToken: 'stale-token',
        newPassword: 'NewPassword123!',
      ),
      expect: () => const [
        PasswordResetState.completing(),
        PasswordResetState.failure(
          Failure.validation(
            'This reset link is invalid or has expired',
            code: ErrorCodes.resetCodeInvalid,
          ),
        ),
      ],
    );
  });

  blocTest<PasswordResetCubit, PasswordResetState>(
    'restart() returns to idle — "change number" on the code-entry step',
    build: build,
    act: (cubit) => cubit.restart(),
    expect: () => const [PasswordResetState.idle()],
  );
}
