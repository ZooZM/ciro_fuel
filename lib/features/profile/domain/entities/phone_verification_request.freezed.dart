// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_verification_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PhoneVerificationRequest {

 DateTime get expiresAt; int get attemptsRemaining;
/// Create a copy of PhoneVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneVerificationRequestCopyWith<PhoneVerificationRequest> get copyWith => _$PhoneVerificationRequestCopyWithImpl<PhoneVerificationRequest>(this as PhoneVerificationRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneVerificationRequest&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.attemptsRemaining, attemptsRemaining) || other.attemptsRemaining == attemptsRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,expiresAt,attemptsRemaining);

@override
String toString() {
  return 'PhoneVerificationRequest(expiresAt: $expiresAt, attemptsRemaining: $attemptsRemaining)';
}


}

/// @nodoc
abstract mixin class $PhoneVerificationRequestCopyWith<$Res>  {
  factory $PhoneVerificationRequestCopyWith(PhoneVerificationRequest value, $Res Function(PhoneVerificationRequest) _then) = _$PhoneVerificationRequestCopyWithImpl;
@useResult
$Res call({
 DateTime expiresAt, int attemptsRemaining
});




}
/// @nodoc
class _$PhoneVerificationRequestCopyWithImpl<$Res>
    implements $PhoneVerificationRequestCopyWith<$Res> {
  _$PhoneVerificationRequestCopyWithImpl(this._self, this._then);

  final PhoneVerificationRequest _self;
  final $Res Function(PhoneVerificationRequest) _then;

/// Create a copy of PhoneVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expiresAt = null,Object? attemptsRemaining = null,}) {
  return _then(_self.copyWith(
expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,attemptsRemaining: null == attemptsRemaining ? _self.attemptsRemaining : attemptsRemaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PhoneVerificationRequest].
extension PhoneVerificationRequestPatterns on PhoneVerificationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneVerificationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneVerificationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneVerificationRequest value)  $default,){
final _that = this;
switch (_that) {
case _PhoneVerificationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneVerificationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneVerificationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime expiresAt,  int attemptsRemaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneVerificationRequest() when $default != null:
return $default(_that.expiresAt,_that.attemptsRemaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime expiresAt,  int attemptsRemaining)  $default,) {final _that = this;
switch (_that) {
case _PhoneVerificationRequest():
return $default(_that.expiresAt,_that.attemptsRemaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime expiresAt,  int attemptsRemaining)?  $default,) {final _that = this;
switch (_that) {
case _PhoneVerificationRequest() when $default != null:
return $default(_that.expiresAt,_that.attemptsRemaining);case _:
  return null;

}
}

}

/// @nodoc


class _PhoneVerificationRequest implements PhoneVerificationRequest {
  const _PhoneVerificationRequest({required this.expiresAt, required this.attemptsRemaining});
  

@override final  DateTime expiresAt;
@override final  int attemptsRemaining;

/// Create a copy of PhoneVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneVerificationRequestCopyWith<_PhoneVerificationRequest> get copyWith => __$PhoneVerificationRequestCopyWithImpl<_PhoneVerificationRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneVerificationRequest&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.attemptsRemaining, attemptsRemaining) || other.attemptsRemaining == attemptsRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,expiresAt,attemptsRemaining);

@override
String toString() {
  return 'PhoneVerificationRequest(expiresAt: $expiresAt, attemptsRemaining: $attemptsRemaining)';
}


}

/// @nodoc
abstract mixin class _$PhoneVerificationRequestCopyWith<$Res> implements $PhoneVerificationRequestCopyWith<$Res> {
  factory _$PhoneVerificationRequestCopyWith(_PhoneVerificationRequest value, $Res Function(_PhoneVerificationRequest) _then) = __$PhoneVerificationRequestCopyWithImpl;
@override @useResult
$Res call({
 DateTime expiresAt, int attemptsRemaining
});




}
/// @nodoc
class __$PhoneVerificationRequestCopyWithImpl<$Res>
    implements _$PhoneVerificationRequestCopyWith<$Res> {
  __$PhoneVerificationRequestCopyWithImpl(this._self, this._then);

  final _PhoneVerificationRequest _self;
  final $Res Function(_PhoneVerificationRequest) _then;

/// Create a copy of PhoneVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expiresAt = null,Object? attemptsRemaining = null,}) {
  return _then(_PhoneVerificationRequest(
expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,attemptsRemaining: null == attemptsRemaining ? _self.attemptsRemaining : attemptsRemaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
