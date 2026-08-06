import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignIn {
  const SignIn(this._repository);

  final AuthRepository _repository;

  /// [phone] is an E.164 identifier (e.g. `+9665XXXXXXX`) — compose it with
  /// [CountryDialCode.toE164] rather than passing raw user input.
  Future<Either<Failure, AuthUser>> call({
    required String phone,
    required String password,
  }) => _repository.signIn(phone: phone, password: password);
}
