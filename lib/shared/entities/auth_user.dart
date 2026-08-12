import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/converters.dart';
import '../enums/user_role.dart';
import 'value_objects.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// spec 004 US3/FR-009 — a CLIENT's station, carried on `/auth/me` (`null`
/// for every other role). `addressText` is editable/geocode-suggested on
/// the backend and never re-derived from the pin (FR-012); this is the
/// only station data the app has, so the home dashboard shows exactly this.
@freezed
abstract class UserStation with _$UserStation {
  const factory UserStation({
    required String addressText,
    String? name,
    GeoPoint? location,
  }) = _UserStation;

  factory UserStation.fromJson(Map<String, Object?> json) =>
      _$UserStationFromJson(json);
}

/// The signed-in identity (backend `/auth/login`, `/auth/refresh`,
/// `/auth/me` `user` payload). `role` selects the CLIENT vs DRIVER
/// experience (FR-026); `companyId` is the tenant scope and is never
/// client-settable (Principle II). `station`/`creditLimit` are CLIENT-only
/// (spec 004 FR-009/FR-023) and only ever populated from `/auth/me` — the
/// thinner `/auth/login` response leaves them null until the first
/// `/auth/me` call the app makes right after signing in.
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    @UserRoleConverter() required UserRole role,
    required String companyId,
    required String fullName,
    UserStation? station,
    double? creditLimit,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, Object?> json) =>
      _$AuthUserFromJson(json);
}
