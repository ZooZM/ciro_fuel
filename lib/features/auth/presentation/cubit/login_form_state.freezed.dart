// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginFormState {

 CountryDialCode get country; bool get rememberMe; bool get obscurePassword; BiometricMethod get biometricMethod;/// The number restored from a previous "remember me", or `null` when
/// there is nothing to prefill. The view copies it into its controller
/// once, on the transition away from `null`.
 String? get rememberedNumber;
/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginFormStateCopyWith<LoginFormState> get copyWith => _$LoginFormStateCopyWithImpl<LoginFormState>(this as LoginFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginFormState&&(identical(other.country, country) || other.country == country)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.biometricMethod, biometricMethod) || other.biometricMethod == biometricMethod)&&(identical(other.rememberedNumber, rememberedNumber) || other.rememberedNumber == rememberedNumber));
}


@override
int get hashCode => Object.hash(runtimeType,country,rememberMe,obscurePassword,biometricMethod,rememberedNumber);

@override
String toString() {
  return 'LoginFormState(country: $country, rememberMe: $rememberMe, obscurePassword: $obscurePassword, biometricMethod: $biometricMethod, rememberedNumber: $rememberedNumber)';
}


}

/// @nodoc
abstract mixin class $LoginFormStateCopyWith<$Res>  {
  factory $LoginFormStateCopyWith(LoginFormState value, $Res Function(LoginFormState) _then) = _$LoginFormStateCopyWithImpl;
@useResult
$Res call({
 CountryDialCode country, bool rememberMe, bool obscurePassword, BiometricMethod biometricMethod, String? rememberedNumber
});




}
/// @nodoc
class _$LoginFormStateCopyWithImpl<$Res>
    implements $LoginFormStateCopyWith<$Res> {
  _$LoginFormStateCopyWithImpl(this._self, this._then);

  final LoginFormState _self;
  final $Res Function(LoginFormState) _then;

/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? country = null,Object? rememberMe = null,Object? obscurePassword = null,Object? biometricMethod = null,Object? rememberedNumber = freezed,}) {
  return _then(_self.copyWith(
country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as CountryDialCode,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,biometricMethod: null == biometricMethod ? _self.biometricMethod : biometricMethod // ignore: cast_nullable_to_non_nullable
as BiometricMethod,rememberedNumber: freezed == rememberedNumber ? _self.rememberedNumber : rememberedNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginFormState].
extension LoginFormStatePatterns on LoginFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginFormState value)  $default,){
final _that = this;
switch (_that) {
case _LoginFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginFormState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CountryDialCode country,  bool rememberMe,  bool obscurePassword,  BiometricMethod biometricMethod,  String? rememberedNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
return $default(_that.country,_that.rememberMe,_that.obscurePassword,_that.biometricMethod,_that.rememberedNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CountryDialCode country,  bool rememberMe,  bool obscurePassword,  BiometricMethod biometricMethod,  String? rememberedNumber)  $default,) {final _that = this;
switch (_that) {
case _LoginFormState():
return $default(_that.country,_that.rememberMe,_that.obscurePassword,_that.biometricMethod,_that.rememberedNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CountryDialCode country,  bool rememberMe,  bool obscurePassword,  BiometricMethod biometricMethod,  String? rememberedNumber)?  $default,) {final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
return $default(_that.country,_that.rememberMe,_that.obscurePassword,_that.biometricMethod,_that.rememberedNumber);case _:
  return null;

}
}

}

/// @nodoc


class _LoginFormState extends LoginFormState {
  const _LoginFormState({this.country = CountryDialCode.saudiArabia, this.rememberMe = true, this.obscurePassword = true, this.biometricMethod = BiometricMethod.none, this.rememberedNumber}): super._();
  

@override@JsonKey() final  CountryDialCode country;
@override@JsonKey() final  bool rememberMe;
@override@JsonKey() final  bool obscurePassword;
@override@JsonKey() final  BiometricMethod biometricMethod;
/// The number restored from a previous "remember me", or `null` when
/// there is nothing to prefill. The view copies it into its controller
/// once, on the transition away from `null`.
@override final  String? rememberedNumber;

/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginFormStateCopyWith<_LoginFormState> get copyWith => __$LoginFormStateCopyWithImpl<_LoginFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginFormState&&(identical(other.country, country) || other.country == country)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.biometricMethod, biometricMethod) || other.biometricMethod == biometricMethod)&&(identical(other.rememberedNumber, rememberedNumber) || other.rememberedNumber == rememberedNumber));
}


@override
int get hashCode => Object.hash(runtimeType,country,rememberMe,obscurePassword,biometricMethod,rememberedNumber);

@override
String toString() {
  return 'LoginFormState(country: $country, rememberMe: $rememberMe, obscurePassword: $obscurePassword, biometricMethod: $biometricMethod, rememberedNumber: $rememberedNumber)';
}


}

/// @nodoc
abstract mixin class _$LoginFormStateCopyWith<$Res> implements $LoginFormStateCopyWith<$Res> {
  factory _$LoginFormStateCopyWith(_LoginFormState value, $Res Function(_LoginFormState) _then) = __$LoginFormStateCopyWithImpl;
@override @useResult
$Res call({
 CountryDialCode country, bool rememberMe, bool obscurePassword, BiometricMethod biometricMethod, String? rememberedNumber
});




}
/// @nodoc
class __$LoginFormStateCopyWithImpl<$Res>
    implements _$LoginFormStateCopyWith<$Res> {
  __$LoginFormStateCopyWithImpl(this._self, this._then);

  final _LoginFormState _self;
  final $Res Function(_LoginFormState) _then;

/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? country = null,Object? rememberMe = null,Object? obscurePassword = null,Object? biometricMethod = null,Object? rememberedNumber = freezed,}) {
  return _then(_LoginFormState(
country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as CountryDialCode,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,biometricMethod: null == biometricMethod ? _self.biometricMethod : biometricMethod // ignore: cast_nullable_to_non_nullable
as BiometricMethod,rememberedNumber: freezed == rememberedNumber ? _self.rememberedNumber : rememberedNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
