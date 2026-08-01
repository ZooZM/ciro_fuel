// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingState()';
}


}

/// @nodoc
class $TrackingStateCopyWith<$Res>  {
$TrackingStateCopyWith(TrackingState _, $Res Function(TrackingState) __);
}


/// Adds pattern-matching-related methods to [TrackingState].
extension TrackingStatePatterns on TrackingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TrackingDisconnected value)?  disconnected,TResult Function( TrackingConnecting value)?  connecting,TResult Function( TrackingWatching value)?  watching,TResult Function( TrackingNotTrackable value)?  notTrackable,TResult Function( TrackingFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TrackingDisconnected() when disconnected != null:
return disconnected(_that);case TrackingConnecting() when connecting != null:
return connecting(_that);case TrackingWatching() when watching != null:
return watching(_that);case TrackingNotTrackable() when notTrackable != null:
return notTrackable(_that);case TrackingFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TrackingDisconnected value)  disconnected,required TResult Function( TrackingConnecting value)  connecting,required TResult Function( TrackingWatching value)  watching,required TResult Function( TrackingNotTrackable value)  notTrackable,required TResult Function( TrackingFailureState value)  failure,}){
final _that = this;
switch (_that) {
case TrackingDisconnected():
return disconnected(_that);case TrackingConnecting():
return connecting(_that);case TrackingWatching():
return watching(_that);case TrackingNotTrackable():
return notTrackable(_that);case TrackingFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TrackingDisconnected value)?  disconnected,TResult? Function( TrackingConnecting value)?  connecting,TResult? Function( TrackingWatching value)?  watching,TResult? Function( TrackingNotTrackable value)?  notTrackable,TResult? Function( TrackingFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case TrackingDisconnected() when disconnected != null:
return disconnected(_that);case TrackingConnecting() when connecting != null:
return connecting(_that);case TrackingWatching() when watching != null:
return watching(_that);case TrackingNotTrackable() when notTrackable != null:
return notTrackable(_that);case TrackingFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  disconnected,TResult Function()?  connecting,TResult Function( LocationSample? location,  bool stale)?  watching,TResult Function()?  notTrackable,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TrackingDisconnected() when disconnected != null:
return disconnected();case TrackingConnecting() when connecting != null:
return connecting();case TrackingWatching() when watching != null:
return watching(_that.location,_that.stale);case TrackingNotTrackable() when notTrackable != null:
return notTrackable();case TrackingFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  disconnected,required TResult Function()  connecting,required TResult Function( LocationSample? location,  bool stale)  watching,required TResult Function()  notTrackable,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case TrackingDisconnected():
return disconnected();case TrackingConnecting():
return connecting();case TrackingWatching():
return watching(_that.location,_that.stale);case TrackingNotTrackable():
return notTrackable();case TrackingFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  disconnected,TResult? Function()?  connecting,TResult? Function( LocationSample? location,  bool stale)?  watching,TResult? Function()?  notTrackable,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case TrackingDisconnected() when disconnected != null:
return disconnected();case TrackingConnecting() when connecting != null:
return connecting();case TrackingWatching() when watching != null:
return watching(_that.location,_that.stale);case TrackingNotTrackable() when notTrackable != null:
return notTrackable();case TrackingFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class TrackingDisconnected implements TrackingState {
  const TrackingDisconnected();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingDisconnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingState.disconnected()';
}


}




/// @nodoc


class TrackingConnecting implements TrackingState {
  const TrackingConnecting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingConnecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingState.connecting()';
}


}




/// @nodoc


class TrackingWatching implements TrackingState {
  const TrackingWatching({this.location, this.stale = false});
  

 final  LocationSample? location;
@JsonKey() final  bool stale;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingWatchingCopyWith<TrackingWatching> get copyWith => _$TrackingWatchingCopyWithImpl<TrackingWatching>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingWatching&&(identical(other.location, location) || other.location == location)&&(identical(other.stale, stale) || other.stale == stale));
}


@override
int get hashCode => Object.hash(runtimeType,location,stale);

@override
String toString() {
  return 'TrackingState.watching(location: $location, stale: $stale)';
}


}

/// @nodoc
abstract mixin class $TrackingWatchingCopyWith<$Res> implements $TrackingStateCopyWith<$Res> {
  factory $TrackingWatchingCopyWith(TrackingWatching value, $Res Function(TrackingWatching) _then) = _$TrackingWatchingCopyWithImpl;
@useResult
$Res call({
 LocationSample? location, bool stale
});


$LocationSampleCopyWith<$Res>? get location;

}
/// @nodoc
class _$TrackingWatchingCopyWithImpl<$Res>
    implements $TrackingWatchingCopyWith<$Res> {
  _$TrackingWatchingCopyWithImpl(this._self, this._then);

  final TrackingWatching _self;
  final $Res Function(TrackingWatching) _then;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? location = freezed,Object? stale = null,}) {
  return _then(TrackingWatching(
location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationSample?,stale: null == stale ? _self.stale : stale // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationSampleCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $LocationSampleCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

/// @nodoc


class TrackingNotTrackable implements TrackingState {
  const TrackingNotTrackable();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingNotTrackable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingState.notTrackable()';
}


}




/// @nodoc


class TrackingFailureState implements TrackingState {
  const TrackingFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingFailureStateCopyWith<TrackingFailureState> get copyWith => _$TrackingFailureStateCopyWithImpl<TrackingFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'TrackingState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $TrackingFailureStateCopyWith<$Res> implements $TrackingStateCopyWith<$Res> {
  factory $TrackingFailureStateCopyWith(TrackingFailureState value, $Res Function(TrackingFailureState) _then) = _$TrackingFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$TrackingFailureStateCopyWithImpl<$Res>
    implements $TrackingFailureStateCopyWith<$Res> {
  _$TrackingFailureStateCopyWithImpl(this._self, this._then);

  final TrackingFailureState _self;
  final $Res Function(TrackingFailureState) _then;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(TrackingFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of TrackingState
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
