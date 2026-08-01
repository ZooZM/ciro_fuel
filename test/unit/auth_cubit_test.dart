import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_app/features/auth/domain/usecases/sign_in.dart';
import 'package:mobile_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_state.dart';
import 'package:mobile_app/shared/entities/auth_user.dart';
import 'package:mobile_app/shared/enums/user_role.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late SignIn signIn;
  late SessionCubit sessionCubit;

  const user = AuthUser(
    id: 'u1',
    role: UserRole.client,
    companyId: 'c1',
    fullName: 'Jane Client',
  );

  setUp(() {
    repository = _MockAuthRepository();
    signIn = SignIn(repository);
    sessionCubit = SessionCubit();
  });

  tearDown(() => sessionCubit.close());

  group('AuthCubit', () {
    blocTest<AuthCubit, AuthState>(
      'idle -> submitting -> success and authenticates SessionCubit on valid credentials',
      setUp: () {
        when(
          () => repository.signIn(email: 'jane@ciro.fuel', password: 'secret'),
        ).thenAnswer((_) async => const Right(user));
      },
      build: () => AuthCubit(signIn: signIn, sessionCubit: sessionCubit),
      act: (cubit) =>
          cubit.submit(email: 'jane@ciro.fuel', password: 'secret'),
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
          () => repository.signIn(email: 'jane@ciro.fuel', password: 'wrong'),
        ).thenAnswer((_) async => const Left(Failure.auth()));
      },
      build: () => AuthCubit(signIn: signIn, sessionCubit: sessionCubit),
      act: (cubit) => cubit.submit(email: 'jane@ciro.fuel', password: 'wrong'),
      expect: () => const [
        AuthState.submitting(),
        AuthState.failure(Failure.auth()),
      ],
      verify: (_) {
        expect(sessionCubit.state, isA<SessionUnknown>());
      },
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
