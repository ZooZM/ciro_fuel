import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/theme/theme_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/profile/domain/entities/profile_user.dart';
import 'package:mobile_app/features/profile/domain/usecases/download_avatar.dart';
import 'package:mobile_app/features/profile/domain/usecases/get_profile.dart';
import 'package:mobile_app/features/profile/domain/usecases/update_full_name.dart';
import 'package:mobile_app/features/profile/domain/usecases/upload_profile_picture.dart';
import 'package:mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mobile_app/features/profile/presentation/view/driver_profile_screen.dart';
import 'package:mobile_app/features/stations/domain/usecases/get_stations.dart';
import 'package:mobile_app/shared/entities/auth_user.dart';
import 'package:mobile_app/shared/enums/user_role.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/localized_harness.dart';

class _MockGetProfile extends Mock implements GetProfile {}

class _MockGetStations extends Mock implements GetStations {}

class _MockUpdateFullName extends Mock implements UpdateFullName {}

class _MockUploadProfilePicture extends Mock implements UploadProfilePicture {}

class _MockDownloadAvatar extends Mock implements DownloadAvatar {}

/// feature 013 US4 (FR-035, FR-036): the driver's "more" tab shows the
/// signed-in driver's own identity, never the `driver_mock_profile.*`
/// fabrication ("محمد أحمد", "محطة الحمد") it used to render regardless of
/// who was signed in — and none of it lingers after a driver switch.
void main() {
  late _MockGetProfile getProfile;

  AuthUser driver(String id, String name) => AuthUser(
    id: id,
    role: UserRole.driver,
    companyId: 'transport-1',
    fullName: name,
  );

  ProfileUser profile(String id, String name) => ProfileUser(
    id: id,
    fullName: name,
    email: '$id@example.com',
    phone: '+96650$id',
    isActive: true,
    createdAt: DateTime(2026, 1, 1),
    companyName: 'Fast Transport Co',
  );

  setUp(() {
    getProfile = _MockGetProfile();
    final getStations = _MockGetStations();
    when(getStations.call).thenAnswer((_) async => const Right([]));
    getIt.registerFactoryParam<ProfileCubit, String, void>(
      (userId, _) => ProfileCubit(
        userId: userId,
        getProfile: getProfile,
        getStations: getStations,
        updateFullName: _MockUpdateFullName(),
        uploadProfilePicture: _MockUploadProfilePicture(),
        downloadAvatar: _MockDownloadAvatar(),
      ),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<ProfileCubit>()) getIt.unregister<ProfileCubit>();
  });

  Future<void> pump(WidgetTester tester, SessionCubit session) => pumpLocalized(
    tester,
    MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: session),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      ],
      child: const DriverProfileScreen(),
    ),
    locale: const Locale('en'),
  );

  testWidgets('renders the loaded driver\'s own name — no placeholder identity', (
    tester,
  ) async {
    when(() => getProfile('d1')).thenAnswer(
      (_) async => Right(profile('d1', 'Yousef Al-Harbi')),
    );
    final session = SessionCubit()..authenticate(driver('d1', 'Yousef Al-Harbi'));

    await pump(tester, session);
    await tester.pumpAndSettle();

    expect(find.text('Yousef Al-Harbi'), findsOneWidget);
    expect(find.text('محمد أحمد'), findsNothing);
    expect(find.textContaining('الحمد'), findsNothing);
  });

  testWidgets('a load failure renders a stated retry, never a fallback identity (FR-035)', (
    tester,
  ) async {
    when(() => getProfile('d1')).thenAnswer((_) async => const Left(Failure.server()));
    await pump(tester, SessionCubit()..authenticate(driver('d1', 'Y')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('محمد أحمد'), findsNothing);
  });

  testWidgets('after a second driver signs in, none of the first driver\'s details remain (FR-036)', (
    tester,
  ) async {
    when(() => getProfile('d1')).thenAnswer(
      (_) async => Right(profile('d1', 'First Driver')),
    );
    when(() => getProfile('d2')).thenAnswer(
      (_) async => Right(profile('d2', 'Second Driver')),
    );

    await pump(tester, SessionCubit()..authenticate(driver('d1', 'First Driver')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('First Driver'), findsOneWidget);

    // Force a full unmount, as a sign-out does in the real app (the router
    // drops the whole authenticated shell), so the "more" tab is genuinely
    // rebuilt for the next driver rather than reusing its State element.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();

    await pump(tester, SessionCubit()..authenticate(driver('d2', 'Second Driver')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Second Driver'), findsOneWidget);
    expect(find.text('First Driver'), findsNothing);
  });
}
