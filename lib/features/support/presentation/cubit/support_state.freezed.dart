// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SupportState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SupportState()';
}


}

/// @nodoc
class $SupportStateCopyWith<$Res>  {
$SupportStateCopyWith(SupportState _, $Res Function(SupportState) __);
}


/// Adds pattern-matching-related methods to [SupportState].
extension SupportStatePatterns on SupportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SupportLoading value)?  loading,TResult Function( SupportLoaded value)?  loaded,TResult Function( SupportFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SupportLoading() when loading != null:
return loading(_that);case SupportLoaded() when loaded != null:
return loaded(_that);case SupportFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SupportLoading value)  loading,required TResult Function( SupportLoaded value)  loaded,required TResult Function( SupportFailureState value)  failure,}){
final _that = this;
switch (_that) {
case SupportLoading():
return loading(_that);case SupportLoaded():
return loaded(_that);case SupportFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SupportLoading value)?  loading,TResult? Function( SupportLoaded value)?  loaded,TResult? Function( SupportFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case SupportLoading() when loading != null:
return loading(_that);case SupportLoaded() when loaded != null:
return loaded(_that);case SupportFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<SupportRequest> requests,  bool isSubmitting,  Failure? submitError)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SupportLoading() when loading != null:
return loading();case SupportLoaded() when loaded != null:
return loaded(_that.requests,_that.isSubmitting,_that.submitError);case SupportFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<SupportRequest> requests,  bool isSubmitting,  Failure? submitError)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case SupportLoading():
return loading();case SupportLoaded():
return loaded(_that.requests,_that.isSubmitting,_that.submitError);case SupportFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<SupportRequest> requests,  bool isSubmitting,  Failure? submitError)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case SupportLoading() when loading != null:
return loading();case SupportLoaded() when loaded != null:
return loaded(_that.requests,_that.isSubmitting,_that.submitError);case SupportFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SupportLoading implements SupportState {
  const SupportLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SupportState.loading()';
}


}




/// @nodoc


class SupportLoaded implements SupportState {
  const SupportLoaded({required final  List<SupportRequest> requests, this.isSubmitting = false, this.submitError}): _requests = requests;
  

 final  List<SupportRequest> _requests;
 List<SupportRequest> get requests {
  if (_requests is EqualUnmodifiableListView) return _requests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requests);
}

@JsonKey() final  bool isSubmitting;
 final  Failure? submitError;

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportLoadedCopyWith<SupportLoaded> get copyWith => _$SupportLoadedCopyWithImpl<SupportLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportLoaded&&const DeepCollectionEquality().equals(other._requests, _requests)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitError, submitError) || other.submitError == submitError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_requests),isSubmitting,submitError);

@override
String toString() {
  return 'SupportState.loaded(requests: $requests, isSubmitting: $isSubmitting, submitError: $submitError)';
}


}

/// @nodoc
abstract mixin class $SupportLoadedCopyWith<$Res> implements $SupportStateCopyWith<$Res> {
  factory $SupportLoadedCopyWith(SupportLoaded value, $Res Function(SupportLoaded) _then) = _$SupportLoadedCopyWithImpl;
@useResult
$Res call({
 List<SupportRequest> requests, bool isSubmitting, Failure? submitError
});


$FailureCopyWith<$Res>? get submitError;

}
/// @nodoc
class _$SupportLoadedCopyWithImpl<$Res>
    implements $SupportLoadedCopyWith<$Res> {
  _$SupportLoadedCopyWithImpl(this._self, this._then);

  final SupportLoaded _self;
  final $Res Function(SupportLoaded) _then;

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requests = null,Object? isSubmitting = null,Object? submitError = freezed,}) {
  return _then(SupportLoaded(
requests: null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<SupportRequest>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitError: freezed == submitError ? _self.submitError : submitError // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get submitError {
    if (_self.submitError == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.submitError!, (value) {
    return _then(_self.copyWith(submitError: value));
  });
}
}

/// @nodoc


class SupportFailureState implements SupportState {
  const SupportFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportFailureStateCopyWith<SupportFailureState> get copyWith => _$SupportFailureStateCopyWithImpl<SupportFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'SupportState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SupportFailureStateCopyWith<$Res> implements $SupportStateCopyWith<$Res> {
  factory $SupportFailureStateCopyWith(SupportFailureState value, $Res Function(SupportFailureState) _then) = _$SupportFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$SupportFailureStateCopyWithImpl<$Res>
    implements $SupportFailureStateCopyWith<$Res> {
  _$SupportFailureStateCopyWithImpl(this._self, this._then);

  final SupportFailureState _self;
  final $Res Function(SupportFailureState) _then;

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(SupportFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of SupportState
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
