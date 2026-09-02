// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_lock_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppLockState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLockState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppLockState()';
}


}

/// @nodoc
class $AppLockStateCopyWith<$Res>  {
$AppLockStateCopyWith(AppLockState _, $Res Function(AppLockState) __);
}


/// Adds pattern-matching-related methods to [AppLockState].
extension AppLockStatePatterns on AppLockState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AppLockUnlocked value)?  unlocked,TResult Function( AppLockLocked value)?  locked,TResult Function( AppLockAuthenticating value)?  authenticating,TResult Function( AppLockUnavailable value)?  unavailable,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AppLockUnlocked() when unlocked != null:
return unlocked(_that);case AppLockLocked() when locked != null:
return locked(_that);case AppLockAuthenticating() when authenticating != null:
return authenticating(_that);case AppLockUnavailable() when unavailable != null:
return unavailable(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AppLockUnlocked value)  unlocked,required TResult Function( AppLockLocked value)  locked,required TResult Function( AppLockAuthenticating value)  authenticating,required TResult Function( AppLockUnavailable value)  unavailable,}){
final _that = this;
switch (_that) {
case AppLockUnlocked():
return unlocked(_that);case AppLockLocked():
return locked(_that);case AppLockAuthenticating():
return authenticating(_that);case AppLockUnavailable():
return unavailable(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AppLockUnlocked value)?  unlocked,TResult? Function( AppLockLocked value)?  locked,TResult? Function( AppLockAuthenticating value)?  authenticating,TResult? Function( AppLockUnavailable value)?  unavailable,}){
final _that = this;
switch (_that) {
case AppLockUnlocked() when unlocked != null:
return unlocked(_that);case AppLockLocked() when locked != null:
return locked(_that);case AppLockAuthenticating() when authenticating != null:
return authenticating(_that);case AppLockUnavailable() when unavailable != null:
return unavailable(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unlocked,TResult Function()?  locked,TResult Function()?  authenticating,TResult Function()?  unavailable,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AppLockUnlocked() when unlocked != null:
return unlocked();case AppLockLocked() when locked != null:
return locked();case AppLockAuthenticating() when authenticating != null:
return authenticating();case AppLockUnavailable() when unavailable != null:
return unavailable();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unlocked,required TResult Function()  locked,required TResult Function()  authenticating,required TResult Function()  unavailable,}) {final _that = this;
switch (_that) {
case AppLockUnlocked():
return unlocked();case AppLockLocked():
return locked();case AppLockAuthenticating():
return authenticating();case AppLockUnavailable():
return unavailable();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unlocked,TResult? Function()?  locked,TResult? Function()?  authenticating,TResult? Function()?  unavailable,}) {final _that = this;
switch (_that) {
case AppLockUnlocked() when unlocked != null:
return unlocked();case AppLockLocked() when locked != null:
return locked();case AppLockAuthenticating() when authenticating != null:
return authenticating();case AppLockUnavailable() when unavailable != null:
return unavailable();case _:
  return null;

}
}

}

/// @nodoc


class AppLockUnlocked implements AppLockState {
  const AppLockUnlocked();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLockUnlocked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppLockState.unlocked()';
}


}




/// @nodoc


class AppLockLocked implements AppLockState {
  const AppLockLocked();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLockLocked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppLockState.locked()';
}


}




/// @nodoc


class AppLockAuthenticating implements AppLockState {
  const AppLockAuthenticating();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLockAuthenticating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppLockState.authenticating()';
}


}




/// @nodoc


class AppLockUnavailable implements AppLockState {
  const AppLockUnavailable();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLockUnavailable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppLockState.unavailable()';
}


}




// dart format on
