import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/session/current_avatar.dart';
import 'package:mobile_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mobile_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mobile_app/features/profile/domain/usecases/download_avatar.dart';
import 'package:mobile_app/features/profile/domain/usecases/get_profile.dart';
import 'package:mobile_app/features/profile/domain/usecases/update_full_name.dart';
import 'package:mobile_app/features/profile/domain/usecases/upload_profile_picture.dart';
import 'package:mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mobile_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:mobile_app/features/stations/domain/usecases/get_stations.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetStations extends Mock implements GetStations {}

class _MockUpdateFullName extends Mock implements UpdateFullName {}

class _MockUploadProfilePicture extends Mock implements UploadProfilePicture {}

class _MockDownloadAvatar extends Mock implements DownloadAvatar {}

/// Serves `GET /users/:id` exactly as `UsersController.findOne` now does
/// for a DRIVER (spec 006 FR-001/002/003) — real wire JSON, not a
/// hand-built [ProfileUser], so this exercises `ProfileMapper.fromJson`
/// against the actual backend contract rather than assuming it.
class _ScriptedUsersAdapter implements HttpClientAdapter {
  final Map<String, String> responses = {};

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final body = responses[options.path];
    if (body == null) {
      return ResponseBody.fromString('{"message":"not found"}', 404);
    }
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _ScriptedUsersAdapter adapter;
  late Dio dio;
  late ProfileRepositoryImpl repository;
  late _MockGetStations getStations;
  late _MockUpdateFullName updateFullName;
  late _MockUploadProfilePicture uploadProfilePicture;
  late _MockDownloadAvatar downloadAvatar;

  setUp(() {
    adapter = _ScriptedUsersAdapter();
    dio = Dio()..httpClientAdapter = adapter;
    repository = ProfileRepositoryImpl(ProfileRemoteDataSourceImpl(dio));
    getStations = _MockGetStations();
    updateFullName = _MockUpdateFullName();
    uploadProfilePicture = _MockUploadProfilePicture();
    downloadAvatar = _MockDownloadAvatar();
    when(() => getStations()).thenAnswer((_) async => const Right([]));
    CurrentAvatar.clear();
  });

  ProfileCubit buildCubit(String userId) => ProfileCubit(
    userId: userId,
    getProfile: GetProfile(repository),
    getStations: getStations,
    updateFullName: updateFullName,
    uploadProfilePicture: uploadProfilePicture,
    downloadAvatar: downloadAvatar,
  );

  // spec 008 (research R12): the embedded `User.truck` this pair of tests
  // used to check (present vs FR-003's "explicit absence") is deleted
  // outright, backend and mobile alike — a vehicle is assigned per
  // delivery now, never a fixed field on the driver's own profile. One
  // test remains, confirming every real (non-vehicle) field still renders.
  blocTest<ProfileCubit, ProfileState>(
    'a driver profile: every real field renders, not a placeholder',
    setUp: () {
      adapter.responses['/users/driver-a'] =
          '{'
          '"_id":"driver-a","role":"DRIVER","companyId":"company-a",'
          '"fullName":"Ahmad Al-Otaibi","email":"ahmad@example.com",'
          '"phone":"+966501111111","isActive":true,'
          '"createdAt":"2026-01-01T00:00:00.000Z",'
          '"companyName":"Fast Fleet Transport"'
          '}';
    },
    build: () => buildCubit('driver-a'),
    act: (cubit) => cubit.load(),
    expect: () => [
      const ProfileState.loading(),
      isA<ProfileLoaded>()
          .having((s) => s.user.fullName, 'fullName', 'Ahmad Al-Otaibi')
          .having((s) => s.user.email, 'email', 'ahmad@example.com')
          .having((s) => s.user.phone, 'phone', '+966501111111')
          .having((s) => s.user.companyName, 'companyName', 'Fast Fleet Transport'),
    ],
  );

  test(
    'a driver switch leaks nothing: CurrentAvatar does not carry the '
    'previous driver into the next one (spec 006 FR-008/SC-002)',
    () async {
      adapter.responses['/users/driver-a'] =
          '{"_id":"driver-a","role":"DRIVER","companyId":"c1",'
          '"fullName":"Ahmad","email":"a@example.com","phone":"+966501111111",'
          '"isActive":true,"createdAt":"2026-01-01T00:00:00.000Z",'
          '"profilePictureFileId":"file-ahmad"}';
      when(
        () => downloadAvatar('file-ahmad'),
      ).thenAnswer((_) async => const Right([9, 9, 9]));

      final cubitA = buildCubit('driver-a');
      await cubitA.load();
      expect(CurrentAvatar.bytes.value, isNotNull);
      await cubitA.close();

      // The sign-out path (injector.dart's SessionUnauthenticated branch)
      // clears this before the next driver's session begins — reproduced
      // directly here since this test is below the DI/router layer.
      CurrentAvatar.clear();
      expect(CurrentAvatar.bytes.value, isNull);

      // Driver B has no picture at all — if the previous bytes ever
      // survived, this is where a leak would show up as a stale photo
      // under the new driver's name.
      adapter.responses['/users/driver-b'] =
          '{"_id":"driver-b","role":"DRIVER","companyId":"c1",'
          '"fullName":"Sara","email":"s@example.com","phone":"+966502222222",'
          '"isActive":true,"createdAt":"2026-01-01T00:00:00.000Z"}';

      final cubitB = buildCubit('driver-b');
      await cubitB.load();
      expect(CurrentAvatar.bytes.value, isNull);
      expect((cubitB.state as ProfileLoaded).user.fullName, 'Sara');
      await cubitB.close();
    },
  );
}
