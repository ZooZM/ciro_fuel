import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/token_store.dart';
import '../../../../shared/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenStore tokenStore,
  }) : _remoteDataSource = remoteDataSource,
       _tokenStore = tokenStore;

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStore _tokenStore;

  @override
  Future<Either<Failure, AuthUser>> signIn({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        phone: phone,
        password: password,
      );
      await _tokenStore.save(
        access: response.accessToken,
        refresh: response.refreshToken,
      );
      // `/auth/login`'s own `user` is the thin SafeUser shape (no
      // station/creditLimit — spec 004 FR-009/FR-023); fetching `/auth/me`
      // here keeps a freshly-signed-in session identical to a restored one
      // rather than only gaining the richer profile after an app restart.
      final me = await _remoteDataSource.me();
      return Right(me);
    } on DioException catch (e) {
      return Left(_failureOf(e));
    } catch (e) {
      print(e.toString());
      return const Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, AuthUser>> restoreSession() async {
    if (!await _tokenStore.hasSession) {
      return const Left(Failure.auth());
    }
    try {
      final user = await _remoteDataSource.me();
      return Right(user);
    } on DioException catch (e) {
      return Left(_failureOf(e));
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }

  @override
  Future<void> signOut() async {
    // Fire-and-forget (spec 006 T070): the local clear must succeed
    // whether or not the network call does — a driver out of coverage
    // must never be trapped in a session they cannot leave (FR-031). The
    // outer try/catch guards a call that fails before returning a Future
    // at all, not just one that rejects after.
    try {
      unawaited(_remoteDataSource.logout().catchError((_) {}));
    } catch (_) {}
    await _tokenStore.clear();
  }

  Failure _failureOf(DioException e) =>
      e.error is Failure ? e.error as Failure : const Failure.server();
}
