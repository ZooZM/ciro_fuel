import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/features/profile/domain/entities/phone_verification_request.dart';
import 'package:mobile_app/features/profile/domain/usecases/confirm_phone_verification.dart';
import 'package:mobile_app/features/profile/domain/usecases/request_phone_verification.dart';
import 'package:mobile_app/features/profile/presentation/cubit/phone_verification_cubit.dart';
import 'package:mobile_app/features/profile/presentation/cubit/phone_verification_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockRequestPhoneVerification extends Mock
    implements RequestPhoneVerification {}

class _MockConfirmPhoneVerification extends Mock
    implements ConfirmPhoneVerification {}

void main() {
  late _MockRequestPhoneVerification requestVerification;
  late _MockConfirmPhoneVerification confirmVerification;

  const newPhone = '+966501234567';
  final expiresAt = DateTime.utc(2026, 1, 1, 12, 30);

  setUp(() {
    requestVerification = _MockRequestPhoneVerification();
    confirmVerification = _MockConfirmPhoneVerification();
  });

  PhoneVerificationCubit build() => PhoneVerificationCubit(
    requestVerification: requestVerification,
    confirmVerification: confirmVerification,
  );

  blocTest<PhoneVerificationCubit, PhoneVerificationState>(
    'requestCode() success emits sending then codeSent',
    setUp: () {
      when(() => requestVerification(newPhone)).thenAnswer(
        (_) async => Right(
          PhoneVerificationRequest(
            expiresAt: expiresAt,
            attemptsRemaining: 5,
          ),
        ),
      );
    },
    build: build,
    act: (cubit) => cubit.requestCode(newPhone),
    expect: () => [
      const PhoneVerificationState.sending(),
      PhoneVerificationState.codeSent(
        newPhone: newPhone,
        expiresAt: expiresAt,
        attemptsRemaining: 5,
      ),
    ],
  );

  blocTest<PhoneVerificationCubit, PhoneVerificationState>(
    'requestCode() PHONE_IN_USE surfaces the mapped Failure',
    setUp: () {
      when(() => requestVerification(newPhone)).thenAnswer(
        (_) async => const Left(
          Failure.validation('in use', code: 'PHONE_IN_USE'),
        ),
      );
    },
    build: build,
    act: (cubit) => cubit.requestCode(newPhone),
    expect: () => const [
      PhoneVerificationState.sending(),
      PhoneVerificationState.failure(
        Failure.validation('in use', code: 'PHONE_IN_USE'),
      ),
    ],
  );

  blocTest<PhoneVerificationCubit, PhoneVerificationState>(
    'requestCode() throttled surfaces retryAfter',
    setUp: () {
      when(() => requestVerification(newPhone)).thenAnswer(
        (_) async =>
            const Left(Failure.throttled(retryAfter: Duration(minutes: 15))),
      );
    },
    build: build,
    act: (cubit) => cubit.requestCode(newPhone),
    expect: () => const [
      PhoneVerificationState.sending(),
      PhoneVerificationState.failure(
        Failure.throttled(retryAfter: Duration(minutes: 15)),
      ),
    ],
  );

  blocTest<PhoneVerificationCubit, PhoneVerificationState>(
    'confirmCode() success emits confirming then confirmed',
    setUp: () {
      when(
        () => confirmVerification('123456'),
      ).thenAnswer((_) async => const Right(null));
    },
    build: build,
    act: (cubit) => cubit.confirmCode('123456'),
    expect: () => const [
      PhoneVerificationState.confirming(),
      PhoneVerificationState.confirmed(),
    ],
  );

  blocTest<PhoneVerificationCubit, PhoneVerificationState>(
    'confirmCode() wrong code surfaces AuthFailure — never a session-expiry '
    'side effect, since the datasource marks this call skipAuthRefresh',
    setUp: () {
      when(
        () => confirmVerification('000000'),
      ).thenAnswer((_) async => const Left(Failure.auth()));
    },
    build: build,
    act: (cubit) => cubit.confirmCode('000000'),
    expect: () => const [
      PhoneVerificationState.confirming(),
      PhoneVerificationState.failure(Failure.auth()),
    ],
  );

  blocTest<PhoneVerificationCubit, PhoneVerificationState>(
    'confirmCode() lockout (5 attempts) surfaces as throttled',
    setUp: () {
      when(() => confirmVerification('000000')).thenAnswer(
        (_) async =>
            const Left(Failure.throttled(retryAfter: Duration(minutes: 1))),
      );
    },
    build: build,
    act: (cubit) => cubit.confirmCode('000000'),
    expect: () => const [
      PhoneVerificationState.confirming(),
      PhoneVerificationState.failure(
        Failure.throttled(retryAfter: Duration(minutes: 1)),
      ),
    ],
  );
}
