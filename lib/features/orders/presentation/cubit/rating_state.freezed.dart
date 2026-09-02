// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RatingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RatingState()';
}


}

/// @nodoc
class $RatingStateCopyWith<$Res>  {
$RatingStateCopyWith(RatingState _, $Res Function(RatingState) __);
}


/// Adds pattern-matching-related methods to [RatingState].
extension RatingStatePatterns on RatingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RatingIdle value)?  idle,TResult Function( RatingSubmitting value)?  submitting,TResult Function( RatingSubmitted value)?  submitted,TResult Function( RatingFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RatingIdle() when idle != null:
return idle(_that);case RatingSubmitting() when submitting != null:
return submitting(_that);case RatingSubmitted() when submitted != null:
return submitted(_that);case RatingFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RatingIdle value)  idle,required TResult Function( RatingSubmitting value)  submitting,required TResult Function( RatingSubmitted value)  submitted,required TResult Function( RatingFailureState value)  failure,}){
final _that = this;
switch (_that) {
case RatingIdle():
return idle(_that);case RatingSubmitting():
return submitting(_that);case RatingSubmitted():
return submitted(_that);case RatingFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RatingIdle value)?  idle,TResult? Function( RatingSubmitting value)?  submitting,TResult? Function( RatingSubmitted value)?  submitted,TResult? Function( RatingFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case RatingIdle() when idle != null:
return idle(_that);case RatingSubmitting() when submitting != null:
return submitting(_that);case RatingSubmitted() when submitted != null:
return submitted(_that);case RatingFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function( OrderRating rating)?  submitted,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RatingIdle() when idle != null:
return idle();case RatingSubmitting() when submitting != null:
return submitting();case RatingSubmitted() when submitted != null:
return submitted(_that.rating);case RatingFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function( OrderRating rating)  submitted,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case RatingIdle():
return idle();case RatingSubmitting():
return submitting();case RatingSubmitted():
return submitted(_that.rating);case RatingFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function( OrderRating rating)?  submitted,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case RatingIdle() when idle != null:
return idle();case RatingSubmitting() when submitting != null:
return submitting();case RatingSubmitted() when submitted != null:
return submitted(_that.rating);case RatingFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class RatingIdle implements RatingState {
  const RatingIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RatingState.idle()';
}


}




/// @nodoc


class RatingSubmitting implements RatingState {
  const RatingSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RatingState.submitting()';
}


}




/// @nodoc


class RatingSubmitted implements RatingState {
  const RatingSubmitted(this.rating);
  

 final  OrderRating rating;

/// Create a copy of RatingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RatingSubmittedCopyWith<RatingSubmitted> get copyWith => _$RatingSubmittedCopyWithImpl<RatingSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingSubmitted&&(identical(other.rating, rating) || other.rating == rating));
}


@override
int get hashCode => Object.hash(runtimeType,rating);

@override
String toString() {
  return 'RatingState.submitted(rating: $rating)';
}


}

/// @nodoc
abstract mixin class $RatingSubmittedCopyWith<$Res> implements $RatingStateCopyWith<$Res> {
  factory $RatingSubmittedCopyWith(RatingSubmitted value, $Res Function(RatingSubmitted) _then) = _$RatingSubmittedCopyWithImpl;
@useResult
$Res call({
 OrderRating rating
});


$OrderRatingCopyWith<$Res> get rating;

}
/// @nodoc
class _$RatingSubmittedCopyWithImpl<$Res>
    implements $RatingSubmittedCopyWith<$Res> {
  _$RatingSubmittedCopyWithImpl(this._self, this._then);

  final RatingSubmitted _self;
  final $Res Function(RatingSubmitted) _then;

/// Create a copy of RatingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rating = null,}) {
  return _then(RatingSubmitted(
null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as OrderRating,
  ));
}

/// Create a copy of RatingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderRatingCopyWith<$Res> get rating {
  
  return $OrderRatingCopyWith<$Res>(_self.rating, (value) {
    return _then(_self.copyWith(rating: value));
  });
}
}

/// @nodoc


class RatingFailureState implements RatingState {
  const RatingFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of RatingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RatingFailureStateCopyWith<RatingFailureState> get copyWith => _$RatingFailureStateCopyWithImpl<RatingFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'RatingState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $RatingFailureStateCopyWith<$Res> implements $RatingStateCopyWith<$Res> {
  factory $RatingFailureStateCopyWith(RatingFailureState value, $Res Function(RatingFailureState) _then) = _$RatingFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$RatingFailureStateCopyWithImpl<$Res>
    implements $RatingFailureStateCopyWith<$Res> {
  _$RatingFailureStateCopyWithImpl(this._self, this._then);

  final RatingFailureState _self;
  final $Res Function(RatingFailureState) _then;

/// Create a copy of RatingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(RatingFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of RatingState
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
