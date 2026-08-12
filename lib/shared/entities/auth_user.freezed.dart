// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserStation {

 String get addressText; String? get name; GeoPoint? get location;
/// Create a copy of UserStation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStationCopyWith<UserStation> get copyWith => _$UserStationCopyWithImpl<UserStation>(this as UserStation, _$identity);

  /// Serializes this UserStation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStation&&(identical(other.addressText, addressText) || other.addressText == addressText)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,addressText,name,location);

@override
String toString() {
  return 'UserStation(addressText: $addressText, name: $name, location: $location)';
}


}

/// @nodoc
abstract mixin class $UserStationCopyWith<$Res>  {
  factory $UserStationCopyWith(UserStation value, $Res Function(UserStation) _then) = _$UserStationCopyWithImpl;
@useResult
$Res call({
 String addressText, String? name, GeoPoint? location
});


$GeoPointCopyWith<$Res>? get location;

}
/// @nodoc
class _$UserStationCopyWithImpl<$Res>
    implements $UserStationCopyWith<$Res> {
  _$UserStationCopyWithImpl(this._self, this._then);

  final UserStation _self;
  final $Res Function(UserStation) _then;

/// Create a copy of UserStation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? addressText = null,Object? name = freezed,Object? location = freezed,}) {
  return _then(_self.copyWith(
addressText: null == addressText ? _self.addressText : addressText // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,
  ));
}
/// Create a copy of UserStation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserStation].
extension UserStationPatterns on UserStation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStation value)  $default,){
final _that = this;
switch (_that) {
case _UserStation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStation value)?  $default,){
final _that = this;
switch (_that) {
case _UserStation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String addressText,  String? name,  GeoPoint? location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStation() when $default != null:
return $default(_that.addressText,_that.name,_that.location);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String addressText,  String? name,  GeoPoint? location)  $default,) {final _that = this;
switch (_that) {
case _UserStation():
return $default(_that.addressText,_that.name,_that.location);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String addressText,  String? name,  GeoPoint? location)?  $default,) {final _that = this;
switch (_that) {
case _UserStation() when $default != null:
return $default(_that.addressText,_that.name,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserStation implements UserStation {
  const _UserStation({required this.addressText, this.name, this.location});
  factory _UserStation.fromJson(Map<String, dynamic> json) => _$UserStationFromJson(json);

@override final  String addressText;
@override final  String? name;
@override final  GeoPoint? location;

/// Create a copy of UserStation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStationCopyWith<_UserStation> get copyWith => __$UserStationCopyWithImpl<_UserStation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserStationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStation&&(identical(other.addressText, addressText) || other.addressText == addressText)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,addressText,name,location);

@override
String toString() {
  return 'UserStation(addressText: $addressText, name: $name, location: $location)';
}


}

/// @nodoc
abstract mixin class _$UserStationCopyWith<$Res> implements $UserStationCopyWith<$Res> {
  factory _$UserStationCopyWith(_UserStation value, $Res Function(_UserStation) _then) = __$UserStationCopyWithImpl;
@override @useResult
$Res call({
 String addressText, String? name, GeoPoint? location
});


@override $GeoPointCopyWith<$Res>? get location;

}
/// @nodoc
class __$UserStationCopyWithImpl<$Res>
    implements _$UserStationCopyWith<$Res> {
  __$UserStationCopyWithImpl(this._self, this._then);

  final _UserStation _self;
  final $Res Function(_UserStation) _then;

/// Create a copy of UserStation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? addressText = null,Object? name = freezed,Object? location = freezed,}) {
  return _then(_UserStation(
addressText: null == addressText ? _self.addressText : addressText // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,
  ));
}

/// Create a copy of UserStation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// @nodoc
mixin _$AuthUser {

 String get id;@UserRoleConverter() UserRole get role; String get companyId; String get fullName; UserStation? get station; double? get creditLimit;
/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUserCopyWith<AuthUser> get copyWith => _$AuthUserCopyWithImpl<AuthUser>(this as AuthUser, _$identity);

  /// Serializes this AuthUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUser&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.station, station) || other.station == station)&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,companyId,fullName,station,creditLimit);

@override
String toString() {
  return 'AuthUser(id: $id, role: $role, companyId: $companyId, fullName: $fullName, station: $station, creditLimit: $creditLimit)';
}


}

/// @nodoc
abstract mixin class $AuthUserCopyWith<$Res>  {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) _then) = _$AuthUserCopyWithImpl;
@useResult
$Res call({
 String id,@UserRoleConverter() UserRole role, String companyId, String fullName, UserStation? station, double? creditLimit
});


$UserStationCopyWith<$Res>? get station;

}
/// @nodoc
class _$AuthUserCopyWithImpl<$Res>
    implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._self, this._then);

  final AuthUser _self;
  final $Res Function(AuthUser) _then;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? companyId = null,Object? fullName = null,Object? station = freezed,Object? creditLimit = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,station: freezed == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as UserStation?,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserStationCopyWith<$Res>? get station {
    if (_self.station == null) {
    return null;
  }

  return $UserStationCopyWith<$Res>(_self.station!, (value) {
    return _then(_self.copyWith(station: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthUser].
extension AuthUserPatterns on AuthUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthUser value)  $default,){
final _that = this;
switch (_that) {
case _AuthUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthUser value)?  $default,){
final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @UserRoleConverter()  UserRole role,  String companyId,  String fullName,  UserStation? station,  double? creditLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that.id,_that.role,_that.companyId,_that.fullName,_that.station,_that.creditLimit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @UserRoleConverter()  UserRole role,  String companyId,  String fullName,  UserStation? station,  double? creditLimit)  $default,) {final _that = this;
switch (_that) {
case _AuthUser():
return $default(_that.id,_that.role,_that.companyId,_that.fullName,_that.station,_that.creditLimit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @UserRoleConverter()  UserRole role,  String companyId,  String fullName,  UserStation? station,  double? creditLimit)?  $default,) {final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that.id,_that.role,_that.companyId,_that.fullName,_that.station,_that.creditLimit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthUser implements AuthUser {
  const _AuthUser({required this.id, @UserRoleConverter() required this.role, required this.companyId, required this.fullName, this.station, this.creditLimit});
  factory _AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);

@override final  String id;
@override@UserRoleConverter() final  UserRole role;
@override final  String companyId;
@override final  String fullName;
@override final  UserStation? station;
@override final  double? creditLimit;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthUserCopyWith<_AuthUser> get copyWith => __$AuthUserCopyWithImpl<_AuthUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUser&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.station, station) || other.station == station)&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,companyId,fullName,station,creditLimit);

@override
String toString() {
  return 'AuthUser(id: $id, role: $role, companyId: $companyId, fullName: $fullName, station: $station, creditLimit: $creditLimit)';
}


}

/// @nodoc
abstract mixin class _$AuthUserCopyWith<$Res> implements $AuthUserCopyWith<$Res> {
  factory _$AuthUserCopyWith(_AuthUser value, $Res Function(_AuthUser) _then) = __$AuthUserCopyWithImpl;
@override @useResult
$Res call({
 String id,@UserRoleConverter() UserRole role, String companyId, String fullName, UserStation? station, double? creditLimit
});


@override $UserStationCopyWith<$Res>? get station;

}
/// @nodoc
class __$AuthUserCopyWithImpl<$Res>
    implements _$AuthUserCopyWith<$Res> {
  __$AuthUserCopyWithImpl(this._self, this._then);

  final _AuthUser _self;
  final $Res Function(_AuthUser) _then;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? companyId = null,Object? fullName = null,Object? station = freezed,Object? creditLimit = freezed,}) {
  return _then(_AuthUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,station: freezed == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as UserStation?,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserStationCopyWith<$Res>? get station {
    if (_self.station == null) {
    return null;
  }

  return $UserStationCopyWith<$Res>(_self.station!, (value) {
    return _then(_self.copyWith(station: value));
  });
}
}

// dart format on
