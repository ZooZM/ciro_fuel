import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/security/biometric_authenticator.dart';
import 'package:mobile_app/features/auth/presentation/cubit/app_lock_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/app_lock_state.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_state.dart';
import 'package:mobile_app/shared/entities/auth_user.dart';
import 'package:mobile_app/shared/enums/user_role.dart';
import 'package:mocktail/mocktail.dart';

class _MockBiometricAuthenticator extends Mock
    implements BiometricAuthenticator {}

const _driver = AuthUser(
  id: 'd1',
  role: UserRole.driver,
  companyId: 'c1',
  fullName: 'A Driver',
);

const _client = AuthUser(
  id: 'u1',
  role: UserRole.client,
  companyId: 'c1',
  fullName: 'A Client',
);

void main() {
  // AppLockCubit registers itself as a WidgetsBindingObserver, which needs
  // a real binding instance even in a headless unit test.
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockBiometricAuthenticator biometrics;
  late SessionCubit sessionCubit;
  DateTime now = DateTime(2026, 1, 1, 12);

  setUp(() {
    biometrics = _MockBiometricAuthenticator();
    sessionCubit = SessionCubit();
    now = DateTime(2026, 1, 1, 12);
  });

  AppLockCubit build() => AppLockCubit(
    biometrics: biometrics,
    sessionCubit: sessionCubit,
    now: () => now,
  );

  void backgroundThenResumeAfter(AppLockCubit cubit, Duration elapsed) {
    cubit.didChangeAppLifecycleState(AppLifecycleState.paused);
    now = now.add(elapsed);
    cubit.didChangeAppLifecycleState(AppLifecycleState.resumed);
  }

  group('cold launch (FR-012)', () {
    blocTest<AppLockCubit, AppLockState>(
      'engages immediately when constructed against an already-authenticated driver session',
      setUp: () => sessionCubit.authenticate(_driver),
      build: build,
      // blocTest seeds its expectation stream only from construction
      // onward, so the state emitted synchronously in the constructor is
      // observed via `state` directly rather than `expect`.
      verify: (cubit) => expect(cubit.state, const AppLockState.locked()),
    );

    blocTest<AppLockCubit, AppLockState>(
      'stays unlocked when constructed against a CLIENT session',
      setUp: () => sessionCubit.authenticate(_client),
      build: build,
      verify: (cubit) => expect(cubit.state, const AppLockState.unlocked()),
    );
  });

  group('a fresh sign-in mid-session', () {
    blocTest<AppLockCubit, AppLockState>(
      'a driver signing in engages the lock, same as a cold launch',
      build: build,
      act: (_) => sessionCubit.authenticate(_driver),
      expect: () => [const AppLockState.locked()],
    );

    blocTest<AppLockCubit, AppLockState>(
      'a CLIENT session never engages the lock at all',
      build: build,
      act: (_) => sessionCubit.authenticate(_client),
      expect: () => [const AppLockState.unlocked()],
    );
  });

  group('background/resume threshold (FR-012)', () {
    // Both cases below need a genuinely `unlocked` baseline before the
    // background/resume cycle — reached the same way the real app would,
    // through a successful `unlock()` call, not by poking Cubit.emit
    // (`@protected`) directly from the test.
    void mockSuccessfulUnlock() {
      when(() => biometrics.isDeviceLockAvailable()).thenAnswer((_) async => true);
      when(
        () => biometrics.authenticate(
          localizedReason: any(named: 'localizedReason'),
          allowDeviceCredential: true,
        ),
      ).thenAnswer((_) async => true);
    }

    blocTest<AppLockCubit, AppLockState>(
      'engages after being backgrounded past the threshold',
      setUp: () {
        sessionCubit.authenticate(_driver);
        mockSuccessfulUnlock();
      },
      build: build,
      act: (cubit) async {
        await cubit.unlock(localizedReason: 'reason');
        backgroundThenResumeAfter(cubit, const Duration(minutes: 3));
      },
      // The constructor's own synchronous `locked()` (cold launch) happens
      // before blocTest attaches its listener, so it is not among these.
      expect: () => [
        const AppLockState.authenticating(),
        const AppLockState.unlocked(),
        const AppLockState.locked(),
      ],
    );

    blocTest<AppLockCubit, AppLockState>(
      'does not engage when backgrounded under the threshold',
      setUp: () {
        sessionCubit.authenticate(_driver);
        mockSuccessfulUnlock();
      },
      build: build,
      act: (cubit) async {
        await cubit.unlock(localizedReason: 'reason');
        backgroundThenResumeAfter(cubit, const Duration(seconds: 30));
      },
      expect: () => [
        const AppLockState.authenticating(),
        const AppLockState.unlocked(),
      ],
    );

    blocTest<AppLockCubit, AppLockState>(
      'a CLIENT session backgrounded past the threshold still never engages',
      setUp: () => sessionCubit.authenticate(_client),
      build: build,
      act: (cubit) => backgroundThenResumeAfter(cubit, const Duration(minutes: 5)),
      expect: () => <AppLockState>[],
    );
  });

  group('unlock()', () {
    blocTest<AppLockCubit, AppLockState>(
      'a successful challenge unlocks',
      setUp: () {
        sessionCubit.authenticate(_driver);
        when(() => biometrics.isDeviceLockAvailable()).thenAnswer((_) async => true);
        when(
          () => biometrics.authenticate(
            localizedReason: any(named: 'localizedReason'),
            allowDeviceCredential: true,
          ),
        ).thenAnswer((_) async => true);
      },
      build: build,
      act: (cubit) => cubit.unlock(localizedReason: 'reason'),
      expect: () => [
        const AppLockState.authenticating(),
        const AppLockState.unlocked(),
      ],
    );

    blocTest<AppLockCubit, AppLockState>(
      'a failed challenge returns to locked, never ends the session (FR-015)',
      setUp: () {
        sessionCubit.authenticate(_driver);
        when(() => biometrics.isDeviceLockAvailable()).thenAnswer((_) async => true);
        when(
          () => biometrics.authenticate(
            localizedReason: any(named: 'localizedReason'),
            allowDeviceCredential: true,
          ),
        ).thenAnswer((_) async => false);
      },
      build: build,
      act: (cubit) => cubit.unlock(localizedReason: 'reason'),
      expect: () => [
        const AppLockState.authenticating(),
        const AppLockState.locked(),
      ],
      verify: (_) => expect(sessionCubit.state, isA<SessionAuthenticated>()),
    );

    blocTest<AppLockCubit, AppLockState>(
      'reaches unavailable when the device has neither biometric nor passcode (FR-013a)',
      setUp: () {
        sessionCubit.authenticate(_driver);
        when(() => biometrics.isDeviceLockAvailable()).thenAnswer((_) async => false);
      },
      build: build,
      act: (cubit) => cubit.unlock(localizedReason: 'reason'),
      expect: () => [
        const AppLockState.authenticating(),
        const AppLockState.unavailable(),
      ],
      verify: (_) {
        verifyNever(
          () => biometrics.authenticate(
            localizedReason: any(named: 'localizedReason'),
            allowDeviceCredential: any(named: 'allowDeviceCredential'),
          ),
        );
      },
    );

    blocTest<AppLockCubit, AppLockState>(
      'passes allowDeviceCredential: true — unlike the login biometric path',
      setUp: () {
        sessionCubit.authenticate(_driver);
        when(() => biometrics.isDeviceLockAvailable()).thenAnswer((_) async => true);
        when(
          () => biometrics.authenticate(
            localizedReason: any(named: 'localizedReason'),
            allowDeviceCredential: true,
          ),
        ).thenAnswer((_) async => true);
      },
      build: build,
      act: (cubit) => cubit.unlock(localizedReason: 'reason'),
      expect: () => [
        const AppLockState.authenticating(),
        const AppLockState.unlocked(),
      ],
      verify: (_) {
        verify(
          () => biometrics.authenticate(
            localizedReason: any(named: 'localizedReason'),
            allowDeviceCredential: true,
          ),
        ).called(1);
      },
    );

    blocTest<AppLockCubit, AppLockState>(
      'does nothing for a CLIENT session — the mandate never applies (FR-010)',
      setUp: () => sessionCubit.authenticate(_client),
      build: build,
      act: (cubit) => cubit.unlock(localizedReason: 'reason'),
      expect: () => <AppLockState>[],
      verify: (_) => verifyNever(() => biometrics.isDeviceLockAvailable()),
    );
  });
}
