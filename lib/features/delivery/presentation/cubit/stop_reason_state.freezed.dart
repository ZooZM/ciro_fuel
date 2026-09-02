// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stop_reason_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StopReasonState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopReasonState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StopReasonState()';
}


}

/// @nodoc
class $StopReasonStateCopyWith<$Res>  {
$StopReasonStateCopyWith(StopReasonState _, $Res Function(StopReasonState) __);
}


/// Adds pattern-matching-related methods to [StopReasonState].
extension StopReasonStatePatterns on StopReasonState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StopReasonEditing value)?  editing,TResult Function( StopReasonSubmitting value)?  submitting,TResult Function( StopReasonSent value)?  sent,TResult Function( StopReasonFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StopReasonEditing() when editing != null:
return editing(_that);case StopReasonSubmitting() when submitting != null:
return submitting(_that);case StopReasonSent() when sent != null:
return sent(_that);case StopReasonFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StopReasonEditing value)  editing,required TResult Function( StopReasonSubmitting value)  submitting,required TResult Function( StopReasonSent value)  sent,required TResult Function( StopReasonFailed value)  failed,}){
final _that = this;
switch (_that) {
case StopReasonEditing():
return editing(_that);case StopReasonSubmitting():
return submitting(_that);case StopReasonSent():
return sent(_that);case StopReasonFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StopReasonEditing value)?  editing,TResult? Function( StopReasonSubmitting value)?  submitting,TResult? Function( StopReasonSent value)?  sent,TResult? Function( StopReasonFailed value)?  failed,}){
final _that = this;
switch (_that) {
case StopReasonEditing() when editing != null:
return editing(_that);case StopReasonSubmitting() when submitting != null:
return submitting(_that);case StopReasonSent() when sent != null:
return sent(_that);case StopReasonFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool needsText,  bool textMissing)?  editing,TResult Function()?  submitting,TResult Function()?  sent,TResult Function( Failure failure)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StopReasonEditing() when editing != null:
return editing(_that.needsText,_that.textMissing);case StopReasonSubmitting() when submitting != null:
return submitting();case StopReasonSent() when sent != null:
return sent();case StopReasonFailed() when failed != null:
return failed(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool needsText,  bool textMissing)  editing,required TResult Function()  submitting,required TResult Function()  sent,required TResult Function( Failure failure)  failed,}) {final _that = this;
switch (_that) {
case StopReasonEditing():
return editing(_that.needsText,_that.textMissing);case StopReasonSubmitting():
return submitting();case StopReasonSent():
return sent();case StopReasonFailed():
return failed(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool needsText,  bool textMissing)?  editing,TResult? Function()?  submitting,TResult? Function()?  sent,TResult? Function( Failure failure)?  failed,}) {final _that = this;
switch (_that) {
case StopReasonEditing() when editing != null:
return editing(_that.needsText,_that.textMissing);case StopReasonSubmitting() when submitting != null:
return submitting();case StopReasonSent() when sent != null:
return sent();case StopReasonFailed() when failed != null:
return failed(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class StopReasonEditing implements StopReasonState {
  const StopReasonEditing({this.needsText = false, this.textMissing = false});
  

@JsonKey() final  bool needsText;
@JsonKey() final  bool textMissing;

/// Create a copy of StopReasonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopReasonEditingCopyWith<StopReasonEditing> get copyWith => _$StopReasonEditingCopyWithImpl<StopReasonEditing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopReasonEditing&&(identical(other.needsText, needsText) || other.needsText == needsText)&&(identical(other.textMissing, textMissing) || other.textMissing == textMissing));
}


@override
int get hashCode => Object.hash(runtimeType,needsText,textMissing);

@override
String toString() {
  return 'StopReasonState.editing(needsText: $needsText, textMissing: $textMissing)';
}


}

/// @nodoc
abstract mixin class $StopReasonEditingCopyWith<$Res> implements $StopReasonStateCopyWith<$Res> {
  factory $StopReasonEditingCopyWith(StopReasonEditing value, $Res Function(StopReasonEditing) _then) = _$StopReasonEditingCopyWithImpl;
@useResult
$Res call({
 bool needsText, bool textMissing
});




}
/// @nodoc
class _$StopReasonEditingCopyWithImpl<$Res>
    implements $StopReasonEditingCopyWith<$Res> {
  _$StopReasonEditingCopyWithImpl(this._self, this._then);

  final StopReasonEditing _self;
  final $Res Function(StopReasonEditing) _then;

/// Create a copy of StopReasonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? needsText = null,Object? textMissing = null,}) {
  return _then(StopReasonEditing(
needsText: null == needsText ? _self.needsText : needsText // ignore: cast_nullable_to_non_nullable
as bool,textMissing: null == textMissing ? _self.textMissing : textMissing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class StopReasonSubmitting implements StopReasonState {
  const StopReasonSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopReasonSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StopReasonState.submitting()';
}


}




/// @nodoc


class StopReasonSent implements StopReasonState {
  const StopReasonSent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopReasonSent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StopReasonState.sent()';
}


}




/// @nodoc


class StopReasonFailed implements StopReasonState {
  const StopReasonFailed(this.failure);
  

 final  Failure failure;

/// Create a copy of StopReasonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopReasonFailedCopyWith<StopReasonFailed> get copyWith => _$StopReasonFailedCopyWithImpl<StopReasonFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopReasonFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'StopReasonState.failed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $StopReasonFailedCopyWith<$Res> implements $StopReasonStateCopyWith<$Res> {
  factory $StopReasonFailedCopyWith(StopReasonFailed value, $Res Function(StopReasonFailed) _then) = _$StopReasonFailedCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$StopReasonFailedCopyWithImpl<$Res>
    implements $StopReasonFailedCopyWith<$Res> {
  _$StopReasonFailedCopyWithImpl(this._self, this._then);

  final StopReasonFailed _self;
  final $Res Function(StopReasonFailed) _then;

/// Create a copy of StopReasonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(StopReasonFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of StopReasonState
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
