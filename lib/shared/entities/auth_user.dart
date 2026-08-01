import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/converters.dart';
import '../enums/user_role.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// The signed-in identity (backend `/auth/login`, `/auth/refresh`,
/// `/auth/me` `user` payload). `role` selects the CLIENT vs DRIVER
/// experience (FR-026); `companyId` is the tenant scope and is never
/// client-settable (Principle II).
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    @UserRoleConverter() required UserRole role,
    required String companyId,
    required String fullName,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, Object?> json) =>
      _$AuthUserFromJson(json);
}
