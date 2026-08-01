// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaymentState()';
}


}

/// @nodoc
class $PaymentStateCopyWith<$Res>  {
$PaymentStateCopyWith(PaymentState _, $Res Function(PaymentState) __);
}


/// Adds pattern-matching-related methods to [PaymentState].
extension PaymentStatePatterns on PaymentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PaymentIdle value)?  idle,TResult Function( PaymentInitiating value)?  initiating,TResult Function( PaymentAwaitingConfirmation value)?  awaitingConfirmation,TResult Function( PaymentConfirmed value)?  confirmed,TResult Function( PaymentWindowExpired value)?  windowExpired,TResult Function( PaymentFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PaymentIdle() when idle != null:
return idle(_that);case PaymentInitiating() when initiating != null:
return initiating(_that);case PaymentAwaitingConfirmation() when awaitingConfirmation != null:
return awaitingConfirmation(_that);case PaymentConfirmed() when confirmed != null:
return confirmed(_that);case PaymentWindowExpired() when windowExpired != null:
return windowExpired(_that);case PaymentFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PaymentIdle value)  idle,required TResult Function( PaymentInitiating value)  initiating,required TResult Function( PaymentAwaitingConfirmation value)  awaitingConfirmation,required TResult Function( PaymentConfirmed value)  confirmed,required TResult Function( PaymentWindowExpired value)  windowExpired,required TResult Function( PaymentFailureState value)  failure,}){
final _that = this;
switch (_that) {
case PaymentIdle():
return idle(_that);case PaymentInitiating():
return initiating(_that);case PaymentAwaitingConfirmation():
return awaitingConfirmation(_that);case PaymentConfirmed():
return confirmed(_that);case PaymentWindowExpired():
return windowExpired(_that);case PaymentFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PaymentIdle value)?  idle,TResult? Function( PaymentInitiating value)?  initiating,TResult? Function( PaymentAwaitingConfirmation value)?  awaitingConfirmation,TResult? Function( PaymentConfirmed value)?  confirmed,TResult? Function( PaymentWindowExpired value)?  windowExpired,TResult? Function( PaymentFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case PaymentIdle() when idle != null:
return idle(_that);case PaymentInitiating() when initiating != null:
return initiating(_that);case PaymentAwaitingConfirmation() when awaitingConfirmation != null:
return awaitingConfirmation(_that);case PaymentConfirmed() when confirmed != null:
return confirmed(_that);case PaymentWindowExpired() when windowExpired != null:
return windowExpired(_that);case PaymentFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  initiating,TResult Function()?  awaitingConfirmation,TResult Function()?  confirmed,TResult Function()?  windowExpired,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PaymentIdle() when idle != null:
return idle();case PaymentInitiating() when initiating != null:
return initiating();case PaymentAwaitingConfirmation() when awaitingConfirmation != null:
return awaitingConfirmation();case PaymentConfirmed() when confirmed != null:
return confirmed();case PaymentWindowExpired() when windowExpired != null:
return windowExpired();case PaymentFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  initiating,required TResult Function()  awaitingConfirmation,required TResult Function()  confirmed,required TResult Function()  windowExpired,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case PaymentIdle():
return idle();case PaymentInitiating():
return initiating();case PaymentAwaitingConfirmation():
return awaitingConfirmation();case PaymentConfirmed():
return confirmed();case PaymentWindowExpired():
return windowExpired();case PaymentFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  initiating,TResult? Function()?  awaitingConfirmation,TResult? Function()?  confirmed,TResult? Function()?  windowExpired,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case PaymentIdle() when idle != null:
return idle();case PaymentInitiating() when initiating != null:
return initiating();case PaymentAwaitingConfirmation() when awaitingConfirmation != null:
return awaitingConfirmation();case PaymentConfirmed() when confirmed != null:
return confirmed();case PaymentWindowExpired() when windowExpired != null:
return windowExpired();case PaymentFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class PaymentIdle implements PaymentState {
  const PaymentIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaymentState.idle()';
}


}




/// @nodoc


class PaymentInitiating implements PaymentState {
  const PaymentInitiating();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentInitiating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaymentState.initiating()';
}


}




/// @nodoc


class PaymentAwaitingConfirmation implements PaymentState {
  const PaymentAwaitingConfirmation();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentAwaitingConfirmation);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaymentState.awaitingConfirmation()';
}


}




/// @nodoc


class PaymentConfirmed implements PaymentState {
  const PaymentConfirmed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentConfirmed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaymentState.confirmed()';
}


}




/// @nodoc


class PaymentWindowExpired implements PaymentState {
  const PaymentWindowExpired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentWindowExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaymentState.windowExpired()';
}


}




/// @nodoc


class PaymentFailureState implements PaymentState {
  const PaymentFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of PaymentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentFailureStateCopyWith<PaymentFailureState> get copyWith => _$PaymentFailureStateCopyWithImpl<PaymentFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'PaymentState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PaymentFailureStateCopyWith<$Res> implements $PaymentStateCopyWith<$Res> {
  factory $PaymentFailureStateCopyWith(PaymentFailureState value, $Res Function(PaymentFailureState) _then) = _$PaymentFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$PaymentFailureStateCopyWithImpl<$Res>
    implements $PaymentFailureStateCopyWith<$Res> {
  _$PaymentFailureStateCopyWithImpl(this._self, this._then);

  final PaymentFailureState _self;
  final $Res Function(PaymentFailureState) _then;

/// Create a copy of PaymentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(PaymentFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of PaymentState
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
