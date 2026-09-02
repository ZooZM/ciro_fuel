// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileUser {

 String get id; String get fullName; String get email; String get phone; bool get isActive; DateTime get createdAt; String? get profilePictureFileId; String? get companyName;
/// Create a copy of ProfileUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileUserCopyWith<ProfileUser> get copyWith => _$ProfileUserCopyWithImpl<ProfileUser>(this as ProfileUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUser&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.profilePictureFileId, profilePictureFileId) || other.profilePictureFileId == profilePictureFileId)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,email,phone,isActive,createdAt,profilePictureFileId,companyName);

@override
String toString() {
  return 'ProfileUser(id: $id, fullName: $fullName, email: $email, phone: $phone, isActive: $isActive, createdAt: $createdAt, profilePictureFileId: $profilePictureFileId, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class $ProfileUserCopyWith<$Res>  {
  factory $ProfileUserCopyWith(ProfileUser value, $Res Function(ProfileUser) _then) = _$ProfileUserCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String email, String phone, bool isActive, DateTime createdAt, String? profilePictureFileId, String? companyName
});




}
/// @nodoc
class _$ProfileUserCopyWithImpl<$Res>
    implements $ProfileUserCopyWith<$Res> {
  _$ProfileUserCopyWithImpl(this._self, this._then);

  final ProfileUser _self;
  final $Res Function(ProfileUser) _then;

/// Create a copy of ProfileUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? email = null,Object? phone = null,Object? isActive = null,Object? createdAt = null,Object? profilePictureFileId = freezed,Object? companyName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,profilePictureFileId: freezed == profilePictureFileId ? _self.profilePictureFileId : profilePictureFileId // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileUser].
extension ProfileUserPatterns on ProfileUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileUser value)  $default,){
final _that = this;
switch (_that) {
case _ProfileUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileUser value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String email,  String phone,  bool isActive,  DateTime createdAt,  String? profilePictureFileId,  String? companyName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileUser() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.isActive,_that.createdAt,_that.profilePictureFileId,_that.companyName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String email,  String phone,  bool isActive,  DateTime createdAt,  String? profilePictureFileId,  String? companyName)  $default,) {final _that = this;
switch (_that) {
case _ProfileUser():
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.isActive,_that.createdAt,_that.profilePictureFileId,_that.companyName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String email,  String phone,  bool isActive,  DateTime createdAt,  String? profilePictureFileId,  String? companyName)?  $default,) {final _that = this;
switch (_that) {
case _ProfileUser() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.isActive,_that.createdAt,_that.profilePictureFileId,_that.companyName);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileUser implements ProfileUser {
  const _ProfileUser({required this.id, required this.fullName, required this.email, required this.phone, required this.isActive, required this.createdAt, this.profilePictureFileId, this.companyName});
  

@override final  String id;
@override final  String fullName;
@override final  String email;
@override final  String phone;
@override final  bool isActive;
@override final  DateTime createdAt;
@override final  String? profilePictureFileId;
@override final  String? companyName;

/// Create a copy of ProfileUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileUserCopyWith<_ProfileUser> get copyWith => __$ProfileUserCopyWithImpl<_ProfileUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileUser&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.profilePictureFileId, profilePictureFileId) || other.profilePictureFileId == profilePictureFileId)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,email,phone,isActive,createdAt,profilePictureFileId,companyName);

@override
String toString() {
  return 'ProfileUser(id: $id, fullName: $fullName, email: $email, phone: $phone, isActive: $isActive, createdAt: $createdAt, profilePictureFileId: $profilePictureFileId, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class _$ProfileUserCopyWith<$Res> implements $ProfileUserCopyWith<$Res> {
  factory _$ProfileUserCopyWith(_ProfileUser value, $Res Function(_ProfileUser) _then) = __$ProfileUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String email, String phone, bool isActive, DateTime createdAt, String? profilePictureFileId, String? companyName
});




}
/// @nodoc
class __$ProfileUserCopyWithImpl<$Res>
    implements _$ProfileUserCopyWith<$Res> {
  __$ProfileUserCopyWithImpl(this._self, this._then);

  final _ProfileUser _self;
  final $Res Function(_ProfileUser) _then;

/// Create a copy of ProfileUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? email = null,Object? phone = null,Object? isActive = null,Object? createdAt = null,Object? profilePictureFileId = freezed,Object? companyName = freezed,}) {
  return _then(_ProfileUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,profilePictureFileId: freezed == profilePictureFileId ? _self.profilePictureFileId : profilePictureFileId // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
