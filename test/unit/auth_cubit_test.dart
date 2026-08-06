import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/localization/translation_keys.dart';
import 'package:mobile_app/core/security/biometric_authenticator.dart';
import 'package:mobile_app/features/auth/data/datasources/login_preferences_store.dart';
import 'package:mobile_app/features/auth/domain/entities/country_dial_code.dart';
import 'package:mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_app/features/auth/domain/usecases/restore_session.dart';
import 'package:mobile_app/features/auth/domain/usecases/sign_in.dart';
import 'package:mobile_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_state.dart';
import 'package:mobile_app/shared/entities/auth_user.dart';
import 'package:mobile_app/shared/enums/user_role.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockBiometricAuthenticator extends Mock
    implements BiometricAuthenticator {}

class _MockLoginPreferencesStore extends Mock
    implements LoginPreferencesStore {}

void main() {
  late _MockAuthRepository repository;
  late _MockBiometricAuthenticator biometrics;
  late _MockLoginPreferencesStore preferences;
  late SignIn signIn;
  late RestoreSession restoreSession;
  late SessionCubit sessionCubit;

  const user = AuthUser(
    id: 'u1',
    role: UserRole.client,
    companyId: 'c1',
    fullName: 'Jane Client',
  );

  // As typed into the field, with the trunk prefix and spacing a user would
  // realistically include — the cubit is responsible for normalising it.
  const typedNumber = '05 123 45678';
  const expectedE164 = '+966512345678';
  const country = CountryDialCode.saudiArabia;

  setUpAll(() => registerFallbackValue(CountryDialCode.saudiArabia));

  setUp(() {
    repository = _MockAuthRepository();
    biometrics = _MockBiometricAuthenticator();
    preferences = _MockLoginPreferencesStore();
    signIn = SignIn(repository);
    restoreSession = RestoreSession(repository);
    sessionCubit = SessionCubit();

    when(
      () => preferences.save(
        country: any(named: 'country'),
        nationalNumber: any(named: 'nationalNumber'),
      ),
    ).thenAnswer((_) async {});
    when(preferences.clear).thenAnswer((_) async {});
  });

  tearDown(() => sessionCubit.close());

  AuthCubit buildCubit() => AuthCubit(
    signIn: signIn,
    restoreSession: restoreSession,
    biometrics: biometrics,
    preferences: preferences,
    sessionCubit: sessionCubit,
  );

  group('AuthCubit.submit', () {
    blocTest<AuthCubit, AuthState>(
      'idle -> submitting -> success and authenticates SessionCubit on valid credentials',
      setUp: () {
        when(
          () => repository.signIn(phone: expectedE164, password: 'secret'),
        ).thenAnswer((_) async => const Right(user));
      },
      build: buildCubit,
      act: (cubit) => cubit.submit(
        country: country,
        nationalNumber: typedNumber,
        password: 'secret',
        rememberMe: false,
      ),
      expect: () => const [AuthState.submitting(), AuthState.success()],
      verify: (_) {
        expect(sessionCubit.state, isA<SessionAuthenticated>());
        expect((sessionCubit.state as SessionAuthenticated).user, user);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'idle -> submitting -> failure on bad credentials, session stays unauthenticated',
      setUp: () {
        when(
          () => repository.signIn(phone: expectedE164, password: 'wrong'),
        ).thenAnswer((_) async => const Left(Failure.auth()));
      },
      build: buildCubit,
      act: (cubit) => cubit.submit(
        country: country,
        nationalNumber: typedNumber,
        password: 'wrong',
        rememberMe: true,
      ),
      expect: () => const [
        AuthState.submitting(),
        AuthState.failure(Failure.auth()),
      ],
      verify: (_) {
        expect(sessionCubit.state, isA<SessionUnknown>());
        // A rejected number must never become the next launch's prefill.
        verifyNever(
          () => preferences.save(
            country: any(named: 'country'),
            nationalNumber: any(named: 'nationalNumber'),
          ),
        );
      },
    );

    blocTest<AuthCubit, AuthState>(
      'persists the normalized number when remember-me is on',
      setUp: () {
        when(
          () => repository.signIn(phone: expectedE164, password: 'secret'),
        ).thenAnswer((_) async => const Right(user));
      },
      build: buildCubit,
      act: (cubit) => cubit.submit(
        country: country,
        nationalNumber: typedNumber,
        password: 'secret',
        rememberMe: true,
      ),
      verify: (_) {
        verify(
          () => preferences.save(country: country, nationalNumber: '512345678'),
        ).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'clears any stored number when remember-me is off',
      setUp: () {
        when(
          () => repository.signIn(phone: expectedE164, password: 'secret'),
        ).thenAnswer((_) async => const Right(user));
      },
      build: buildCubit,
      act: (cubit) => cubit.submit(
        country: country,
        nationalNumber: typedNumber,
        password: 'secret',
        rememberMe: false,
      ),
      verify: (_) => verify(preferences.clear).called(1),
    );
  });

  group('AuthCubit.signInWithBiometrics', () {
    blocTest<AuthCubit, AuthState>(
      'restores the persisted session after a successful scan',
      setUp: () {
        when(
          () => biometrics.authenticate(
            localizedReason: any(named: 'localizedReason'),
          ),
        ).thenAnswer((_) async => true);
        when(
          repository.restoreSession,
        ).thenAnswer((_) async => const Right(user));
      },
      build: buildCubit,
      act: (cubit) => cubit.signInWithBiometrics(localizedReason: 'reason'),
      expect: () => const [AuthState.submitting(), AuthState.success()],
      verify: (_) => expect(sessionCubit.state, isA<SessionAuthenticated>()),
    );

    blocTest<AuthCubit, AuthState>(
      'reports a declined scan without touching the session',
      setUp: () {
        when(
          () => biometrics.authenticate(
            localizedReason: any(named: 'localizedReason'),
          ),
        ).thenAnswer((_) async => false);
      },
      build: buildCubit,
      act: (cubit) => cubit.signInWithBiometrics(localizedReason: 'reason'),
      expect: () => const [AuthState.error(ErrorKeys.biometricFailed)],
      verify: (_) {
        expect(sessionCubit.state, isA<SessionUnknown>());
        verifyNever(repository.restoreSession);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'points the user back to the password form when no session is stored',
      setUp: () {
        when(
          () => biometrics.authenticate(
            localizedReason: any(named: 'localizedReason'),
          ),
        ).thenAnswer((_) async => true);
        when(
          repository.restoreSession,
        ).thenAnswer((_) async => const Left(Failure.auth()));
      },
      build: buildCubit,
      act: (cubit) => cubit.signInWithBiometrics(localizedReason: 'reason'),
      expect: () => const [
        AuthState.submitting(),
        AuthState.error(ErrorKeys.biometricUnavailable),
      ],
      verify: (_) => expect(sessionCubit.state, isA<SessionUnknown>()),
    );
  });

  group('SessionCubit', () {
    blocTest<SessionCubit, SessionState>(
      'signOut is idempotent — a second call while already unauthenticated does not re-emit',
      build: SessionCubit.new,
      act: (cubit) {
        cubit.signOut(reason: 'expired');
        cubit.signOut(reason: 'expired again');
      },
      expect: () => const [SessionState.unauthenticated(reason: 'expired')],
    );
  });
}
