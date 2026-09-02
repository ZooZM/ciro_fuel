import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/token_store.dart';
import 'package:mobile_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mobile_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockTokenStore extends Mock implements TokenStore {}

void main() {
  late _MockAuthRemoteDataSource remoteDataSource;
  late _MockTokenStore tokenStore;
  late AuthRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockAuthRemoteDataSource();
    tokenStore = _MockTokenStore();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      tokenStore: tokenStore,
    );
    when(() => tokenStore.clear()).thenAnswer((_) async {});
  });

  test(
    'signOut clears the local session even when the server logout call '
    'fails (spec 006 FR-031) — a driver out of coverage must never be '
    'trapped in a session they cannot leave',
    () async {
      when(() => remoteDataSource.logout()).thenAnswer(
        (_) async => throw DioException(
          requestOptions: RequestOptions(path: '/auth/logout'),
        ),
      );

      await repository.signOut();

      verify(() => tokenStore.clear()).called(1);
    },
  );

  test(
    'signOut completes and clears the local session even when the remote '
    'call throws synchronously, not just when it rejects asynchronously',
    () async {
      when(() => remoteDataSource.logout()).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/auth/logout')),
      );

      await repository.signOut();

      verify(() => tokenStore.clear()).called(1);
    },
  );

  test('signOut clears the local session when the server call succeeds too', () async {
    when(() => remoteDataSource.logout()).thenAnswer((_) async {});

    await repository.signOut();

    verify(() => tokenStore.clear()).called(1);
  });
}
