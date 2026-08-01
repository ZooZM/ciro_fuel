// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState()';
}


}

/// @nodoc
class $SessionStateCopyWith<$Res>  {
$SessionStateCopyWith(SessionState _, $Res Function(SessionState) __);
}


/// Adds pattern-matching-related methods to [SessionState].
extension SessionStatePatterns on SessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SessionUnknown value)?  unknown,TResult Function( SessionAuthenticated value)?  authenticated,TResult Function( SessionUnauthenticated value)?  unauthenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SessionUnknown() when unknown != null:
return unknown(_that);case SessionAuthenticated() when authenticated != null:
return authenticated(_that);case SessionUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SessionUnknown value)  unknown,required TResult Function( SessionAuthenticated value)  authenticated,required TResult Function( SessionUnauthenticated value)  unauthenticated,}){
final _that = this;
switch (_that) {
case SessionUnknown():
return unknown(_that);case SessionAuthenticated():
return authenticated(_that);case SessionUnauthenticated():
return unauthenticated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SessionUnknown value)?  unknown,TResult? Function( SessionAuthenticated value)?  authenticated,TResult? Function( SessionUnauthenticated value)?  unauthenticated,}){
final _that = this;
switch (_that) {
case SessionUnknown() when unknown != null:
return unknown(_that);case SessionAuthenticated() when authenticated != null:
return authenticated(_that);case SessionUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function( AuthUser user)?  authenticated,TResult Function( String? reason)?  unauthenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SessionUnknown() when unknown != null:
return unknown();case SessionAuthenticated() when authenticated != null:
return authenticated(_that.user);case SessionUnauthenticated() when unauthenticated != null:
return unauthenticated(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function( AuthUser user)  authenticated,required TResult Function( String? reason)  unauthenticated,}) {final _that = this;
switch (_that) {
case SessionUnknown():
return unknown();case SessionAuthenticated():
return authenticated(_that.user);case SessionUnauthenticated():
return unauthenticated(_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function( AuthUser user)?  authenticated,TResult? Function( String? reason)?  unauthenticated,}) {final _that = this;
switch (_that) {
case SessionUnknown() when unknown != null:
return unknown();case SessionAuthenticated() when authenticated != null:
return authenticated(_that.user);case SessionUnauthenticated() when unauthenticated != null:
return unauthenticated(_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class SessionUnknown implements SessionState {
  const SessionUnknown();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState.unknown()';
}


}




/// @nodoc


class SessionAuthenticated implements SessionState {
  const SessionAuthenticated(this.user);
  

 final  AuthUser user;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionAuthenticatedCopyWith<SessionAuthenticated> get copyWith => _$SessionAuthenticatedCopyWithImpl<SessionAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionAuthenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'SessionState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $SessionAuthenticatedCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory $SessionAuthenticatedCopyWith(SessionAuthenticated value, $Res Function(SessionAuthenticated) _then) = _$SessionAuthenticatedCopyWithImpl;
@useResult
$Res call({
 AuthUser user
});


$AuthUserCopyWith<$Res> get user;

}
/// @nodoc
class _$SessionAuthenticatedCopyWithImpl<$Res>
    implements $SessionAuthenticatedCopyWith<$Res> {
  _$SessionAuthenticatedCopyWithImpl(this._self, this._then);

  final SessionAuthenticated _self;
  final $Res Function(SessionAuthenticated) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(SessionAuthenticated(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser,
  ));
}

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res> get user {
  
  return $AuthUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class SessionUnauthenticated implements SessionState {
  const SessionUnauthenticated({this.reason});
  

 final  String? reason;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionUnauthenticatedCopyWith<SessionUnauthenticated> get copyWith => _$SessionUnauthenticatedCopyWithImpl<SessionUnauthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionUnauthenticated&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'SessionState.unauthenticated(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $SessionUnauthenticatedCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory $SessionUnauthenticatedCopyWith(SessionUnauthenticated value, $Res Function(SessionUnauthenticated) _then) = _$SessionUnauthenticatedCopyWithImpl;
@useResult
$Res call({
 String? reason
});




}
/// @nodoc
class _$SessionUnauthenticatedCopyWithImpl<$Res>
    implements $SessionUnauthenticatedCopyWith<$Res> {
  _$SessionUnauthenticatedCopyWithImpl(this._self, this._then);

  final SessionUnauthenticated _self;
  final $Res Function(SessionUnauthenticated) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = freezed,}) {
  return _then(SessionUnauthenticated(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
