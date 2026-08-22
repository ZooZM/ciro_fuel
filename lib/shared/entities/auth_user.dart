import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/user_role.dart';
import 'value_objects.dart';

part 'auth_user.freezed.dart';

/// spec 004 US3/FR-009 — a CLIENT's station, carried on `/auth/me` (`null`
/// for every other role). `addressText` is editable/geocode-suggested on
/// the backend and never re-derived from the pin (FR-012); this is the
/// only station data the app has, so the home dashboard shows exactly this.
///
/// No generated `fromJson`: `location` is a [GeoPoint], whose own
/// `fromJson` reads several incompatible wire shapes by hand (see that
/// class's doc comment) — a shape `json_serializable` cannot derive a
/// matching `toJson` for on an enclosing class, so any class nesting a
/// `GeoPoint` is mapped by hand here rather than via codegen (same
/// reasoning as `ProfileMapper`/`StationMapper`).
@freezed
abstract class UserStation with _$UserStation {
  const factory UserStation({
    required String addressText,
    String? name,
    GeoPoint? location,
  }) = _UserStation;

  // Block body (`{ return }`), not `=>`: per `Freezed.toJson`'s own doc
  // comment, an arrow-bodied `fromJson` is what freezed's generator reads
  // as "generate a matching toJson", regardless of what the arrow body
  // calls — the syntax is the signal, not the implementation. `GeoPoint`
  // (`value_objects.dart`) established this exact pattern first.
  factory UserStation.fromJson(Map<String, Object?> json) {
    return UserStation(
      addressText: json['addressText'] as String? ?? '',
      name: json['name'] as String?,
      location: json['location'] != null
          ? GeoPoint.fromJson(json['location'] as Map<String, Object?>)
          : null,
    );
  }
}

/// The signed-in identity (backend `/auth/login`, `/auth/refresh`,
/// `/auth/me` `user` payload). `role` selects the CLIENT vs DRIVER
/// experience (FR-026); `companyId` is the tenant scope and is never
/// client-settable (Principle II). `station`/`creditLimit` are CLIENT-only
/// (spec 004 FR-009/FR-023) and only ever populated from `/auth/me` — the
/// thinner `/auth/login` response leaves them null until the first
/// `/auth/me` call the app makes right after signing in.
///
/// No generated `fromJson`, for the same reason as [UserStation]: it nests
/// one (transitively, via `station.location`).
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required UserRole role,
    required String companyId,
    required String fullName,
    UserStation? station,
    double? creditLimit,
  }) = _AuthUser;

  // Block body — see UserStation.fromJson's comment above.
  factory AuthUser.fromJson(Map<String, Object?> json) {
    return AuthUser(
      id: json['id'] as String,
      role: UserRole.fromWire(json['role'] as String),
      companyId: json['companyId'] as String,
      fullName: json['fullName'] as String,
      station: json['station'] != null
          ? UserStation.fromJson(json['station'] as Map<String, Object?>)
          : null,
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
    );
  }
}
