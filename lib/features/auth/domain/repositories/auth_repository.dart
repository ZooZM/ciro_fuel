import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AuthUser>> signIn({
    required String email,
    required String password,
  });

  /// Validates/refreshes the persisted session on launch (FR-002). Returns
  /// `Left(Failure.auth())` immediately, with no network call, when no
  /// session is persisted at all.
  Future<Either<Failure, AuthUser>> restoreSession();

  Future<void> signOut();
}
