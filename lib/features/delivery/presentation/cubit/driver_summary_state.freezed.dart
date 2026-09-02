// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_summary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DriverSummaryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverSummaryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DriverSummaryState()';
}


}

/// @nodoc
class $DriverSummaryStateCopyWith<$Res>  {
$DriverSummaryStateCopyWith(DriverSummaryState _, $Res Function(DriverSummaryState) __);
}


/// Adds pattern-matching-related methods to [DriverSummaryState].
extension DriverSummaryStatePatterns on DriverSummaryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DriverSummaryLoading value)?  loading,TResult Function( DriverSummaryLoaded value)?  loaded,TResult Function( DriverSummaryFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DriverSummaryLoading() when loading != null:
return loading(_that);case DriverSummaryLoaded() when loaded != null:
return loaded(_that);case DriverSummaryFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DriverSummaryLoading value)  loading,required TResult Function( DriverSummaryLoaded value)  loaded,required TResult Function( DriverSummaryFailureState value)  failure,}){
final _that = this;
switch (_that) {
case DriverSummaryLoading():
return loading(_that);case DriverSummaryLoaded():
return loaded(_that);case DriverSummaryFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DriverSummaryLoading value)?  loading,TResult? Function( DriverSummaryLoaded value)?  loaded,TResult? Function( DriverSummaryFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case DriverSummaryLoading() when loading != null:
return loading(_that);case DriverSummaryLoaded() when loaded != null:
return loaded(_that);case DriverSummaryFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( DriverStanding summary)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DriverSummaryLoading() when loading != null:
return loading();case DriverSummaryLoaded() when loaded != null:
return loaded(_that.summary);case DriverSummaryFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( DriverStanding summary)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case DriverSummaryLoading():
return loading();case DriverSummaryLoaded():
return loaded(_that.summary);case DriverSummaryFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( DriverStanding summary)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case DriverSummaryLoading() when loading != null:
return loading();case DriverSummaryLoaded() when loaded != null:
return loaded(_that.summary);case DriverSummaryFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DriverSummaryLoading implements DriverSummaryState {
  const DriverSummaryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverSummaryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DriverSummaryState.loading()';
}


}




/// @nodoc


class DriverSummaryLoaded implements DriverSummaryState {
  const DriverSummaryLoaded(this.summary);
  

 final  DriverStanding summary;

/// Create a copy of DriverSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverSummaryLoadedCopyWith<DriverSummaryLoaded> get copyWith => _$DriverSummaryLoadedCopyWithImpl<DriverSummaryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverSummaryLoaded&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,summary);

@override
String toString() {
  return 'DriverSummaryState.loaded(summary: $summary)';
}


}

/// @nodoc
abstract mixin class $DriverSummaryLoadedCopyWith<$Res> implements $DriverSummaryStateCopyWith<$Res> {
  factory $DriverSummaryLoadedCopyWith(DriverSummaryLoaded value, $Res Function(DriverSummaryLoaded) _then) = _$DriverSummaryLoadedCopyWithImpl;
@useResult
$Res call({
 DriverStanding summary
});


$DriverStandingCopyWith<$Res> get summary;

}
/// @nodoc
class _$DriverSummaryLoadedCopyWithImpl<$Res>
    implements $DriverSummaryLoadedCopyWith<$Res> {
  _$DriverSummaryLoadedCopyWithImpl(this._self, this._then);

  final DriverSummaryLoaded _self;
  final $Res Function(DriverSummaryLoaded) _then;

/// Create a copy of DriverSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? summary = null,}) {
  return _then(DriverSummaryLoaded(
null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DriverStanding,
  ));
}

/// Create a copy of DriverSummaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverStandingCopyWith<$Res> get summary {
  
  return $DriverStandingCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc


class DriverSummaryFailureState implements DriverSummaryState {
  const DriverSummaryFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of DriverSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverSummaryFailureStateCopyWith<DriverSummaryFailureState> get copyWith => _$DriverSummaryFailureStateCopyWithImpl<DriverSummaryFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverSummaryFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'DriverSummaryState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DriverSummaryFailureStateCopyWith<$Res> implements $DriverSummaryStateCopyWith<$Res> {
  factory $DriverSummaryFailureStateCopyWith(DriverSummaryFailureState value, $Res Function(DriverSummaryFailureState) _then) = _$DriverSummaryFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$DriverSummaryFailureStateCopyWithImpl<$Res>
    implements $DriverSummaryFailureStateCopyWith<$Res> {
  _$DriverSummaryFailureStateCopyWithImpl(this._self, this._then);

  final DriverSummaryFailureState _self;
  final $Res Function(DriverSummaryFailureState) _then;

/// Create a copy of DriverSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DriverSummaryFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of DriverSummaryState
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
