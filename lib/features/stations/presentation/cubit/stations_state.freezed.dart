// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stations_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StationsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StationsState()';
}


}

/// @nodoc
class $StationsStateCopyWith<$Res>  {
$StationsStateCopyWith(StationsState _, $Res Function(StationsState) __);
}


/// Adds pattern-matching-related methods to [StationsState].
extension StationsStatePatterns on StationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StationsLoading value)?  loading,TResult Function( StationsLoaded value)?  loaded,TResult Function( StationsFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StationsLoading() when loading != null:
return loading(_that);case StationsLoaded() when loaded != null:
return loaded(_that);case StationsFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StationsLoading value)  loading,required TResult Function( StationsLoaded value)  loaded,required TResult Function( StationsFailureState value)  failure,}){
final _that = this;
switch (_that) {
case StationsLoading():
return loading(_that);case StationsLoaded():
return loaded(_that);case StationsFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StationsLoading value)?  loading,TResult? Function( StationsLoaded value)?  loaded,TResult? Function( StationsFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case StationsLoading() when loading != null:
return loading(_that);case StationsLoaded() when loaded != null:
return loaded(_that);case StationsFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<Station> stations)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StationsLoading() when loading != null:
return loading();case StationsLoaded() when loaded != null:
return loaded(_that.stations);case StationsFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<Station> stations)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case StationsLoading():
return loading();case StationsLoaded():
return loaded(_that.stations);case StationsFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<Station> stations)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case StationsLoading() when loading != null:
return loading();case StationsLoaded() when loaded != null:
return loaded(_that.stations);case StationsFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class StationsLoading implements StationsState {
  const StationsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StationsState.loading()';
}


}




/// @nodoc


class StationsLoaded implements StationsState {
  const StationsLoaded(final  List<Station> stations): _stations = stations;
  

 final  List<Station> _stations;
 List<Station> get stations {
  if (_stations is EqualUnmodifiableListView) return _stations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stations);
}


/// Create a copy of StationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationsLoadedCopyWith<StationsLoaded> get copyWith => _$StationsLoadedCopyWithImpl<StationsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationsLoaded&&const DeepCollectionEquality().equals(other._stations, _stations));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_stations));

@override
String toString() {
  return 'StationsState.loaded(stations: $stations)';
}


}

/// @nodoc
abstract mixin class $StationsLoadedCopyWith<$Res> implements $StationsStateCopyWith<$Res> {
  factory $StationsLoadedCopyWith(StationsLoaded value, $Res Function(StationsLoaded) _then) = _$StationsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Station> stations
});




}
/// @nodoc
class _$StationsLoadedCopyWithImpl<$Res>
    implements $StationsLoadedCopyWith<$Res> {
  _$StationsLoadedCopyWithImpl(this._self, this._then);

  final StationsLoaded _self;
  final $Res Function(StationsLoaded) _then;

/// Create a copy of StationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stations = null,}) {
  return _then(StationsLoaded(
null == stations ? _self._stations : stations // ignore: cast_nullable_to_non_nullable
as List<Station>,
  ));
}


}

/// @nodoc


class StationsFailureState implements StationsState {
  const StationsFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of StationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationsFailureStateCopyWith<StationsFailureState> get copyWith => _$StationsFailureStateCopyWithImpl<StationsFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationsFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'StationsState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $StationsFailureStateCopyWith<$Res> implements $StationsStateCopyWith<$Res> {
  factory $StationsFailureStateCopyWith(StationsFailureState value, $Res Function(StationsFailureState) _then) = _$StationsFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$StationsFailureStateCopyWithImpl<$Res>
    implements $StationsFailureStateCopyWith<$Res> {
  _$StationsFailureStateCopyWithImpl(this._self, this._then);

  final StationsFailureState _self;
  final $Res Function(StationsFailureState) _then;

/// Create a copy of StationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(StationsFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of StationsState
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
