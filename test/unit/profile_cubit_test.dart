import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/features/profile/domain/entities/profile_user.dart';
import 'package:mobile_app/features/profile/domain/usecases/download_avatar.dart';
import 'package:mobile_app/features/profile/domain/usecases/get_profile.dart';
import 'package:mobile_app/features/profile/domain/usecases/update_full_name.dart';
import 'package:mobile_app/features/profile/domain/usecases/upload_profile_picture.dart';
import 'package:mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mobile_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:mobile_app/features/stations/domain/entities/station.dart';
import 'package:mobile_app/features/stations/domain/usecases/get_stations.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetProfile extends Mock implements GetProfile {}

class _MockGetStations extends Mock implements GetStations {}

class _MockUpdateFullName extends Mock implements UpdateFullName {}

class _MockUploadProfilePicture extends Mock implements UploadProfilePicture {}

class _MockDownloadAvatar extends Mock implements DownloadAvatar {}

void main() {
  late _MockGetProfile getProfile;
  late _MockGetStations getStations;
  late _MockUpdateFullName updateFullName;
  late _MockUploadProfilePicture uploadProfilePicture;
  late _MockDownloadAvatar downloadAvatar;

  const userId = 'user-1';
  final user = ProfileUser(
    id: userId,
    fullName: 'Jane Client',
    email: 'jane@example.com',
    phone: '+966501234567',
    isActive: true,
    createdAt: DateTime.utc(2026, 1, 1),
  );
  final userWithPicture = user.copyWith(profilePictureFileId: 'file-1');
  const station = Station(
    id: 's1',
    regionCode: 'RIYADH',
    governorateCode: 'RIYADH_CITY',
    location: GeoPoint(lat: 24.7, lng: 46.6),
    addressText: 'Some address',
    isDefault: true,
    isFavourite: false,
  );

  setUp(() {
    getProfile = _MockGetProfile();
    getStations = _MockGetStations();
    updateFullName = _MockUpdateFullName();
    uploadProfilePicture = _MockUploadProfilePicture();
    downloadAvatar = _MockDownloadAvatar();
  });

  ProfileCubit build() => ProfileCubit(
    userId: userId,
    getProfile: getProfile,
    getStations: getStations,
    updateFullName: updateFullName,
    uploadProfilePicture: uploadProfilePicture,
    downloadAvatar: downloadAvatar,
  );

  blocTest<ProfileCubit, ProfileState>(
    'load() succeeds, fetching the profile and its stations',
    setUp: () {
      when(() => getProfile(userId)).thenAnswer((_) async => Right(user));
      when(() => getStations()).thenAnswer((_) async => Right([station]));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const ProfileState.loading(),
      ProfileState.loaded(user: user, stations: [station]),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'load() with no picture never calls downloadAvatar',
    setUp: () {
      when(() => getProfile(userId)).thenAnswer((_) async => Right(user));
      when(() => getStations()).thenAnswer((_) async => const Right([]));
    },
    build: build,
    act: (cubit) => cubit.load(),
    verify: (_) => verifyNever(() => downloadAvatar(any())),
  );

  blocTest<ProfileCubit, ProfileState>(
    'load() with a picture downloads and surfaces its bytes',
    setUp: () {
      when(
        () => getProfile(userId),
      ).thenAnswer((_) async => Right(userWithPicture));
      when(() => getStations()).thenAnswer((_) async => const Right([]));
      when(
        () => downloadAvatar('file-1'),
      ).thenAnswer((_) async => const Right([1, 2, 3]));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const ProfileState.loading(),
      isA<ProfileLoaded>()
          .having((s) => s.user, 'user', userWithPicture)
          .having((s) => s.avatarBytes, 'avatarBytes', isNotNull),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'a stations fetch failure still lands the profile with an empty list, '
    'not a whole-screen failure',
    setUp: () {
      when(() => getProfile(userId)).thenAnswer((_) async => Right(user));
      when(
        () => getStations(),
      ).thenAnswer((_) async => const Left(Failure.server()));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const ProfileState.loading(),
      ProfileState.loaded(user: user, stations: const []),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'load() failure surfaces the mapped Failure',
    setUp: () {
      when(
        () => getProfile(userId),
      ).thenAnswer((_) async => const Left(Failure.notFound()));
    },
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [
      ProfileState.loading(),
      ProfileState.failure(Failure.notFound()),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'updateFullName() success replaces the user in place, keeping stations',
    setUp: () {
      when(() => getProfile(userId)).thenAnswer((_) async => Right(user));
      when(() => getStations()).thenAnswer((_) async => Right([station]));
      when(
        () => updateFullName(userId, 'New Name'),
      ).thenAnswer((_) async => Right(user.copyWith(fullName: 'New Name')));
    },
    build: build,
    act: (cubit) async {
      await cubit.load();
      await cubit.updateFullName('New Name');
    },
    expect: () => [
      const ProfileState.loading(),
      ProfileState.loaded(user: user, stations: [station]),
      ProfileState.loaded(
        user: user,
        stations: [station],
        isSaving: true,
      ),
      ProfileState.loaded(
        user: user.copyWith(fullName: 'New Name'),
        stations: [station],
      ),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'updateFullName() failure keeps the prior user and surfaces saveError',
    setUp: () {
      when(() => getProfile(userId)).thenAnswer((_) async => Right(user));
      when(() => getStations()).thenAnswer((_) async => const Right([]));
      when(() => updateFullName(userId, 'New Name')).thenAnswer(
        (_) async => const Left(Failure.validation('name rejected')),
      );
    },
    build: build,
    act: (cubit) async {
      await cubit.load();
      await cubit.updateFullName('New Name');
    },
    expect: () => [
      const ProfileState.loading(),
      ProfileState.loaded(user: user, stations: const []),
      ProfileState.loaded(user: user, stations: const [], isSaving: true),
      ProfileState.loaded(
        user: user,
        stations: const [],
        saveError: const Failure.validation('name rejected'),
      ),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'clearSaveError() clears a set saveError without touching the rest',
    setUp: () {
      when(() => getProfile(userId)).thenAnswer((_) async => Right(user));
      when(() => getStations()).thenAnswer((_) async => const Right([]));
      when(
        () => updateFullName(userId, 'New Name'),
      ).thenAnswer((_) async => const Left(Failure.server()));
    },
    build: build,
    act: (cubit) async {
      await cubit.load();
      await cubit.updateFullName('New Name');
      cubit.clearSaveError();
    },
    verify: (cubit) {
      final state = cubit.state;
      expect(state, isA<ProfileLoaded>());
      expect((state as ProfileLoaded).saveError, isNull);
    },
  );
}
