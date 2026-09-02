// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreditState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreditState()';
}


}

/// @nodoc
class $CreditStateCopyWith<$Res>  {
$CreditStateCopyWith(CreditState _, $Res Function(CreditState) __);
}


/// Adds pattern-matching-related methods to [CreditState].
extension CreditStatePatterns on CreditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CreditLoading value)?  loading,TResult Function( CreditLoaded value)?  loaded,TResult Function( CreditLoadFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CreditLoading() when loading != null:
return loading(_that);case CreditLoaded() when loaded != null:
return loaded(_that);case CreditLoadFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CreditLoading value)  loading,required TResult Function( CreditLoaded value)  loaded,required TResult Function( CreditLoadFailure value)  failure,}){
final _that = this;
switch (_that) {
case CreditLoading():
return loading(_that);case CreditLoaded():
return loaded(_that);case CreditLoadFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CreditLoading value)?  loading,TResult? Function( CreditLoaded value)?  loaded,TResult? Function( CreditLoadFailure value)?  failure,}){
final _that = this;
switch (_that) {
case CreditLoading() when loading != null:
return loading(_that);case CreditLoaded() when loaded != null:
return loaded(_that);case CreditLoadFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( CreditStanding standing)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CreditLoading() when loading != null:
return loading();case CreditLoaded() when loaded != null:
return loaded(_that.standing);case CreditLoadFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( CreditStanding standing)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case CreditLoading():
return loading();case CreditLoaded():
return loaded(_that.standing);case CreditLoadFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( CreditStanding standing)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case CreditLoading() when loading != null:
return loading();case CreditLoaded() when loaded != null:
return loaded(_that.standing);case CreditLoadFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class CreditLoading implements CreditState {
  const CreditLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreditState.loading()';
}


}




/// @nodoc


class CreditLoaded implements CreditState {
  const CreditLoaded(this.standing);
  

 final  CreditStanding standing;

/// Create a copy of CreditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreditLoadedCopyWith<CreditLoaded> get copyWith => _$CreditLoadedCopyWithImpl<CreditLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditLoaded&&(identical(other.standing, standing) || other.standing == standing));
}


@override
int get hashCode => Object.hash(runtimeType,standing);

@override
String toString() {
  return 'CreditState.loaded(standing: $standing)';
}


}

/// @nodoc
abstract mixin class $CreditLoadedCopyWith<$Res> implements $CreditStateCopyWith<$Res> {
  factory $CreditLoadedCopyWith(CreditLoaded value, $Res Function(CreditLoaded) _then) = _$CreditLoadedCopyWithImpl;
@useResult
$Res call({
 CreditStanding standing
});


$CreditStandingCopyWith<$Res> get standing;

}
/// @nodoc
class _$CreditLoadedCopyWithImpl<$Res>
    implements $CreditLoadedCopyWith<$Res> {
  _$CreditLoadedCopyWithImpl(this._self, this._then);

  final CreditLoaded _self;
  final $Res Function(CreditLoaded) _then;

/// Create a copy of CreditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? standing = null,}) {
  return _then(CreditLoaded(
null == standing ? _self.standing : standing // ignore: cast_nullable_to_non_nullable
as CreditStanding,
  ));
}

/// Create a copy of CreditState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreditStandingCopyWith<$Res> get standing {
  
  return $CreditStandingCopyWith<$Res>(_self.standing, (value) {
    return _then(_self.copyWith(standing: value));
  });
}
}

/// @nodoc


class CreditLoadFailure implements CreditState {
  const CreditLoadFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of CreditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreditLoadFailureCopyWith<CreditLoadFailure> get copyWith => _$CreditLoadFailureCopyWithImpl<CreditLoadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditLoadFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'CreditState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CreditLoadFailureCopyWith<$Res> implements $CreditStateCopyWith<$Res> {
  factory $CreditLoadFailureCopyWith(CreditLoadFailure value, $Res Function(CreditLoadFailure) _then) = _$CreditLoadFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$CreditLoadFailureCopyWithImpl<$Res>
    implements $CreditLoadFailureCopyWith<$Res> {
  _$CreditLoadFailureCopyWithImpl(this._self, this._then);

  final CreditLoadFailure _self;
  final $Res Function(CreditLoadFailure) _then;

/// Create a copy of CreditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(CreditLoadFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of CreditState
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
