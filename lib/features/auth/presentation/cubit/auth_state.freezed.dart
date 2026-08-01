// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthIdle value)?  idle,TResult Function( AuthSubmitting value)?  submitting,TResult Function( AuthLoginSuccess value)?  success,TResult Function( AuthLoginFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthIdle() when idle != null:
return idle(_that);case AuthSubmitting() when submitting != null:
return submitting(_that);case AuthLoginSuccess() when success != null:
return success(_that);case AuthLoginFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthIdle value)  idle,required TResult Function( AuthSubmitting value)  submitting,required TResult Function( AuthLoginSuccess value)  success,required TResult Function( AuthLoginFailure value)  failure,}){
final _that = this;
switch (_that) {
case AuthIdle():
return idle(_that);case AuthSubmitting():
return submitting(_that);case AuthLoginSuccess():
return success(_that);case AuthLoginFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthIdle value)?  idle,TResult? Function( AuthSubmitting value)?  submitting,TResult? Function( AuthLoginSuccess value)?  success,TResult? Function( AuthLoginFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AuthIdle() when idle != null:
return idle(_that);case AuthSubmitting() when submitting != null:
return submitting(_that);case AuthLoginSuccess() when success != null:
return success(_that);case AuthLoginFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function()?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthIdle() when idle != null:
return idle();case AuthSubmitting() when submitting != null:
return submitting();case AuthLoginSuccess() when success != null:
return success();case AuthLoginFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function()  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case AuthIdle():
return idle();case AuthSubmitting():
return submitting();case AuthLoginSuccess():
return success();case AuthLoginFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function()?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case AuthIdle() when idle != null:
return idle();case AuthSubmitting() when submitting != null:
return submitting();case AuthLoginSuccess() when success != null:
return success();case AuthLoginFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class AuthIdle implements AuthState {
  const AuthIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.idle()';
}


}




/// @nodoc


class AuthSubmitting implements AuthState {
  const AuthSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.submitting()';
}


}




/// @nodoc


class AuthLoginSuccess implements AuthState {
  const AuthLoginSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLoginSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.success()';
}


}




/// @nodoc


class AuthLoginFailure implements AuthState {
  const AuthLoginFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthLoginFailureCopyWith<AuthLoginFailure> get copyWith => _$AuthLoginFailureCopyWithImpl<AuthLoginFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLoginFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'AuthState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AuthLoginFailureCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthLoginFailureCopyWith(AuthLoginFailure value, $Res Function(AuthLoginFailure) _then) = _$AuthLoginFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$AuthLoginFailureCopyWithImpl<$Res>
    implements $AuthLoginFailureCopyWith<$Res> {
  _$AuthLoginFailureCopyWithImpl(this._self, this._then);

  final AuthLoginFailure _self;
  final $Res Function(AuthLoginFailure) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(AuthLoginFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
