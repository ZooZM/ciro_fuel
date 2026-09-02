// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_verification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PhoneVerificationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneVerificationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PhoneVerificationState()';
}


}

/// @nodoc
class $PhoneVerificationStateCopyWith<$Res>  {
$PhoneVerificationStateCopyWith(PhoneVerificationState _, $Res Function(PhoneVerificationState) __);
}


/// Adds pattern-matching-related methods to [PhoneVerificationState].
extension PhoneVerificationStatePatterns on PhoneVerificationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PhoneVerificationIdle value)?  idle,TResult Function( PhoneVerificationSending value)?  sending,TResult Function( PhoneVerificationCodeSent value)?  codeSent,TResult Function( PhoneVerificationConfirming value)?  confirming,TResult Function( PhoneVerificationConfirmed value)?  confirmed,TResult Function( PhoneVerificationFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PhoneVerificationIdle() when idle != null:
return idle(_that);case PhoneVerificationSending() when sending != null:
return sending(_that);case PhoneVerificationCodeSent() when codeSent != null:
return codeSent(_that);case PhoneVerificationConfirming() when confirming != null:
return confirming(_that);case PhoneVerificationConfirmed() when confirmed != null:
return confirmed(_that);case PhoneVerificationFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PhoneVerificationIdle value)  idle,required TResult Function( PhoneVerificationSending value)  sending,required TResult Function( PhoneVerificationCodeSent value)  codeSent,required TResult Function( PhoneVerificationConfirming value)  confirming,required TResult Function( PhoneVerificationConfirmed value)  confirmed,required TResult Function( PhoneVerificationFailureState value)  failure,}){
final _that = this;
switch (_that) {
case PhoneVerificationIdle():
return idle(_that);case PhoneVerificationSending():
return sending(_that);case PhoneVerificationCodeSent():
return codeSent(_that);case PhoneVerificationConfirming():
return confirming(_that);case PhoneVerificationConfirmed():
return confirmed(_that);case PhoneVerificationFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PhoneVerificationIdle value)?  idle,TResult? Function( PhoneVerificationSending value)?  sending,TResult? Function( PhoneVerificationCodeSent value)?  codeSent,TResult? Function( PhoneVerificationConfirming value)?  confirming,TResult? Function( PhoneVerificationConfirmed value)?  confirmed,TResult? Function( PhoneVerificationFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case PhoneVerificationIdle() when idle != null:
return idle(_that);case PhoneVerificationSending() when sending != null:
return sending(_that);case PhoneVerificationCodeSent() when codeSent != null:
return codeSent(_that);case PhoneVerificationConfirming() when confirming != null:
return confirming(_that);case PhoneVerificationConfirmed() when confirmed != null:
return confirmed(_that);case PhoneVerificationFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  sending,TResult Function( String newPhone,  DateTime expiresAt,  int attemptsRemaining)?  codeSent,TResult Function()?  confirming,TResult Function()?  confirmed,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PhoneVerificationIdle() when idle != null:
return idle();case PhoneVerificationSending() when sending != null:
return sending();case PhoneVerificationCodeSent() when codeSent != null:
return codeSent(_that.newPhone,_that.expiresAt,_that.attemptsRemaining);case PhoneVerificationConfirming() when confirming != null:
return confirming();case PhoneVerificationConfirmed() when confirmed != null:
return confirmed();case PhoneVerificationFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  sending,required TResult Function( String newPhone,  DateTime expiresAt,  int attemptsRemaining)  codeSent,required TResult Function()  confirming,required TResult Function()  confirmed,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case PhoneVerificationIdle():
return idle();case PhoneVerificationSending():
return sending();case PhoneVerificationCodeSent():
return codeSent(_that.newPhone,_that.expiresAt,_that.attemptsRemaining);case PhoneVerificationConfirming():
return confirming();case PhoneVerificationConfirmed():
return confirmed();case PhoneVerificationFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  sending,TResult? Function( String newPhone,  DateTime expiresAt,  int attemptsRemaining)?  codeSent,TResult? Function()?  confirming,TResult? Function()?  confirmed,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case PhoneVerificationIdle() when idle != null:
return idle();case PhoneVerificationSending() when sending != null:
return sending();case PhoneVerificationCodeSent() when codeSent != null:
return codeSent(_that.newPhone,_that.expiresAt,_that.attemptsRemaining);case PhoneVerificationConfirming() when confirming != null:
return confirming();case PhoneVerificationConfirmed() when confirmed != null:
return confirmed();case PhoneVerificationFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class PhoneVerificationIdle implements PhoneVerificationState {
  const PhoneVerificationIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneVerificationIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PhoneVerificationState.idle()';
}


}




/// @nodoc


class PhoneVerificationSending implements PhoneVerificationState {
  const PhoneVerificationSending();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneVerificationSending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PhoneVerificationState.sending()';
}


}




/// @nodoc


class PhoneVerificationCodeSent implements PhoneVerificationState {
  const PhoneVerificationCodeSent({required this.newPhone, required this.expiresAt, required this.attemptsRemaining});
  

 final  String newPhone;
 final  DateTime expiresAt;
 final  int attemptsRemaining;

/// Create a copy of PhoneVerificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneVerificationCodeSentCopyWith<PhoneVerificationCodeSent> get copyWith => _$PhoneVerificationCodeSentCopyWithImpl<PhoneVerificationCodeSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneVerificationCodeSent&&(identical(other.newPhone, newPhone) || other.newPhone == newPhone)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.attemptsRemaining, attemptsRemaining) || other.attemptsRemaining == attemptsRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,newPhone,expiresAt,attemptsRemaining);

@override
String toString() {
  return 'PhoneVerificationState.codeSent(newPhone: $newPhone, expiresAt: $expiresAt, attemptsRemaining: $attemptsRemaining)';
}


}

/// @nodoc
abstract mixin class $PhoneVerificationCodeSentCopyWith<$Res> implements $PhoneVerificationStateCopyWith<$Res> {
  factory $PhoneVerificationCodeSentCopyWith(PhoneVerificationCodeSent value, $Res Function(PhoneVerificationCodeSent) _then) = _$PhoneVerificationCodeSentCopyWithImpl;
@useResult
$Res call({
 String newPhone, DateTime expiresAt, int attemptsRemaining
});




}
/// @nodoc
class _$PhoneVerificationCodeSentCopyWithImpl<$Res>
    implements $PhoneVerificationCodeSentCopyWith<$Res> {
  _$PhoneVerificationCodeSentCopyWithImpl(this._self, this._then);

  final PhoneVerificationCodeSent _self;
  final $Res Function(PhoneVerificationCodeSent) _then;

/// Create a copy of PhoneVerificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? newPhone = null,Object? expiresAt = null,Object? attemptsRemaining = null,}) {
  return _then(PhoneVerificationCodeSent(
newPhone: null == newPhone ? _self.newPhone : newPhone // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,attemptsRemaining: null == attemptsRemaining ? _self.attemptsRemaining : attemptsRemaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PhoneVerificationConfirming implements PhoneVerificationState {
  const PhoneVerificationConfirming();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneVerificationConfirming);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PhoneVerificationState.confirming()';
}


}




/// @nodoc


class PhoneVerificationConfirmed implements PhoneVerificationState {
  const PhoneVerificationConfirmed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneVerificationConfirmed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PhoneVerificationState.confirmed()';
}


}




/// @nodoc


class PhoneVerificationFailureState implements PhoneVerificationState {
  const PhoneVerificationFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of PhoneVerificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneVerificationFailureStateCopyWith<PhoneVerificationFailureState> get copyWith => _$PhoneVerificationFailureStateCopyWithImpl<PhoneVerificationFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneVerificationFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'PhoneVerificationState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PhoneVerificationFailureStateCopyWith<$Res> implements $PhoneVerificationStateCopyWith<$Res> {
  factory $PhoneVerificationFailureStateCopyWith(PhoneVerificationFailureState value, $Res Function(PhoneVerificationFailureState) _then) = _$PhoneVerificationFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$PhoneVerificationFailureStateCopyWithImpl<$Res>
    implements $PhoneVerificationFailureStateCopyWith<$Res> {
  _$PhoneVerificationFailureStateCopyWithImpl(this._self, this._then);

  final PhoneVerificationFailureState _self;
  final $Res Function(PhoneVerificationFailureState) _then;

/// Create a copy of PhoneVerificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(PhoneVerificationFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of PhoneVerificationState
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
