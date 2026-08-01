// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_verify_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpVerifyState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerifyState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpVerifyState()';
}


}

/// @nodoc
class $OtpVerifyStateCopyWith<$Res>  {
$OtpVerifyStateCopyWith(OtpVerifyState _, $Res Function(OtpVerifyState) __);
}


/// Adds pattern-matching-related methods to [OtpVerifyState].
extension OtpVerifyStatePatterns on OtpVerifyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OtpVerifyIdle value)?  idle,TResult Function( OtpVerifying value)?  verifying,TResult Function( OtpVerifyAdvanced value)?  advanced,TResult Function( OtpVerifyRejected value)?  rejected,TResult Function( OtpVerifyThrottled value)?  throttled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OtpVerifyIdle() when idle != null:
return idle(_that);case OtpVerifying() when verifying != null:
return verifying(_that);case OtpVerifyAdvanced() when advanced != null:
return advanced(_that);case OtpVerifyRejected() when rejected != null:
return rejected(_that);case OtpVerifyThrottled() when throttled != null:
return throttled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OtpVerifyIdle value)  idle,required TResult Function( OtpVerifying value)  verifying,required TResult Function( OtpVerifyAdvanced value)  advanced,required TResult Function( OtpVerifyRejected value)  rejected,required TResult Function( OtpVerifyThrottled value)  throttled,}){
final _that = this;
switch (_that) {
case OtpVerifyIdle():
return idle(_that);case OtpVerifying():
return verifying(_that);case OtpVerifyAdvanced():
return advanced(_that);case OtpVerifyRejected():
return rejected(_that);case OtpVerifyThrottled():
return throttled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OtpVerifyIdle value)?  idle,TResult? Function( OtpVerifying value)?  verifying,TResult? Function( OtpVerifyAdvanced value)?  advanced,TResult? Function( OtpVerifyRejected value)?  rejected,TResult? Function( OtpVerifyThrottled value)?  throttled,}){
final _that = this;
switch (_that) {
case OtpVerifyIdle() when idle != null:
return idle(_that);case OtpVerifying() when verifying != null:
return verifying(_that);case OtpVerifyAdvanced() when advanced != null:
return advanced(_that);case OtpVerifyRejected() when rejected != null:
return rejected(_that);case OtpVerifyThrottled() when throttled != null:
return throttled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  verifying,TResult Function( OrderStatus to)?  advanced,TResult Function()?  rejected,TResult Function( Duration? retryAfter)?  throttled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OtpVerifyIdle() when idle != null:
return idle();case OtpVerifying() when verifying != null:
return verifying();case OtpVerifyAdvanced() when advanced != null:
return advanced(_that.to);case OtpVerifyRejected() when rejected != null:
return rejected();case OtpVerifyThrottled() when throttled != null:
return throttled(_that.retryAfter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  verifying,required TResult Function( OrderStatus to)  advanced,required TResult Function()  rejected,required TResult Function( Duration? retryAfter)  throttled,}) {final _that = this;
switch (_that) {
case OtpVerifyIdle():
return idle();case OtpVerifying():
return verifying();case OtpVerifyAdvanced():
return advanced(_that.to);case OtpVerifyRejected():
return rejected();case OtpVerifyThrottled():
return throttled(_that.retryAfter);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  verifying,TResult? Function( OrderStatus to)?  advanced,TResult? Function()?  rejected,TResult? Function( Duration? retryAfter)?  throttled,}) {final _that = this;
switch (_that) {
case OtpVerifyIdle() when idle != null:
return idle();case OtpVerifying() when verifying != null:
return verifying();case OtpVerifyAdvanced() when advanced != null:
return advanced(_that.to);case OtpVerifyRejected() when rejected != null:
return rejected();case OtpVerifyThrottled() when throttled != null:
return throttled(_that.retryAfter);case _:
  return null;

}
}

}

/// @nodoc


class OtpVerifyIdle implements OtpVerifyState {
  const OtpVerifyIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerifyIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpVerifyState.idle()';
}


}




/// @nodoc


class OtpVerifying implements OtpVerifyState {
  const OtpVerifying();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerifying);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpVerifyState.verifying()';
}


}




/// @nodoc


class OtpVerifyAdvanced implements OtpVerifyState {
  const OtpVerifyAdvanced(this.to);
  

 final  OrderStatus to;

/// Create a copy of OtpVerifyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpVerifyAdvancedCopyWith<OtpVerifyAdvanced> get copyWith => _$OtpVerifyAdvancedCopyWithImpl<OtpVerifyAdvanced>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerifyAdvanced&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,to);

@override
String toString() {
  return 'OtpVerifyState.advanced(to: $to)';
}


}

/// @nodoc
abstract mixin class $OtpVerifyAdvancedCopyWith<$Res> implements $OtpVerifyStateCopyWith<$Res> {
  factory $OtpVerifyAdvancedCopyWith(OtpVerifyAdvanced value, $Res Function(OtpVerifyAdvanced) _then) = _$OtpVerifyAdvancedCopyWithImpl;
@useResult
$Res call({
 OrderStatus to
});




}
/// @nodoc
class _$OtpVerifyAdvancedCopyWithImpl<$Res>
    implements $OtpVerifyAdvancedCopyWith<$Res> {
  _$OtpVerifyAdvancedCopyWithImpl(this._self, this._then);

  final OtpVerifyAdvanced _self;
  final $Res Function(OtpVerifyAdvanced) _then;

/// Create a copy of OtpVerifyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? to = null,}) {
  return _then(OtpVerifyAdvanced(
null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as OrderStatus,
  ));
}


}

/// @nodoc


class OtpVerifyRejected implements OtpVerifyState {
  const OtpVerifyRejected();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerifyRejected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpVerifyState.rejected()';
}


}




/// @nodoc


class OtpVerifyThrottled implements OtpVerifyState {
  const OtpVerifyThrottled({this.retryAfter});
  

 final  Duration? retryAfter;

/// Create a copy of OtpVerifyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpVerifyThrottledCopyWith<OtpVerifyThrottled> get copyWith => _$OtpVerifyThrottledCopyWithImpl<OtpVerifyThrottled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerifyThrottled&&(identical(other.retryAfter, retryAfter) || other.retryAfter == retryAfter));
}


@override
int get hashCode => Object.hash(runtimeType,retryAfter);

@override
String toString() {
  return 'OtpVerifyState.throttled(retryAfter: $retryAfter)';
}


}

/// @nodoc
abstract mixin class $OtpVerifyThrottledCopyWith<$Res> implements $OtpVerifyStateCopyWith<$Res> {
  factory $OtpVerifyThrottledCopyWith(OtpVerifyThrottled value, $Res Function(OtpVerifyThrottled) _then) = _$OtpVerifyThrottledCopyWithImpl;
@useResult
$Res call({
 Duration? retryAfter
});




}
/// @nodoc
class _$OtpVerifyThrottledCopyWithImpl<$Res>
    implements $OtpVerifyThrottledCopyWith<$Res> {
  _$OtpVerifyThrottledCopyWithImpl(this._self, this._then);

  final OtpVerifyThrottled _self;
  final $Res Function(OtpVerifyThrottled) _then;

/// Create a copy of OtpVerifyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? retryAfter = freezed,}) {
  return _then(OtpVerifyThrottled(
retryAfter: freezed == retryAfter ? _self.retryAfter : retryAfter // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

// dart format on
