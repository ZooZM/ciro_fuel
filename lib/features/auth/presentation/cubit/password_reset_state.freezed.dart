// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_reset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PasswordResetState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PasswordResetState()';
}


}

/// @nodoc
class $PasswordResetStateCopyWith<$Res>  {
$PasswordResetStateCopyWith(PasswordResetState _, $Res Function(PasswordResetState) __);
}


/// Adds pattern-matching-related methods to [PasswordResetState].
extension PasswordResetStatePatterns on PasswordResetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PasswordResetIdle value)?  idle,TResult Function( PasswordResetRequesting value)?  requesting,TResult Function( PasswordResetCodeSent value)?  codeSent,TResult Function( PasswordResetVerifying value)?  verifying,TResult Function( PasswordResetVerified value)?  verified,TResult Function( PasswordResetCompleting value)?  completing,TResult Function( PasswordResetCompleted value)?  completed,TResult Function( PasswordResetFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PasswordResetIdle() when idle != null:
return idle(_that);case PasswordResetRequesting() when requesting != null:
return requesting(_that);case PasswordResetCodeSent() when codeSent != null:
return codeSent(_that);case PasswordResetVerifying() when verifying != null:
return verifying(_that);case PasswordResetVerified() when verified != null:
return verified(_that);case PasswordResetCompleting() when completing != null:
return completing(_that);case PasswordResetCompleted() when completed != null:
return completed(_that);case PasswordResetFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PasswordResetIdle value)  idle,required TResult Function( PasswordResetRequesting value)  requesting,required TResult Function( PasswordResetCodeSent value)  codeSent,required TResult Function( PasswordResetVerifying value)  verifying,required TResult Function( PasswordResetVerified value)  verified,required TResult Function( PasswordResetCompleting value)  completing,required TResult Function( PasswordResetCompleted value)  completed,required TResult Function( PasswordResetFailureState value)  failure,}){
final _that = this;
switch (_that) {
case PasswordResetIdle():
return idle(_that);case PasswordResetRequesting():
return requesting(_that);case PasswordResetCodeSent():
return codeSent(_that);case PasswordResetVerifying():
return verifying(_that);case PasswordResetVerified():
return verified(_that);case PasswordResetCompleting():
return completing(_that);case PasswordResetCompleted():
return completed(_that);case PasswordResetFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PasswordResetIdle value)?  idle,TResult? Function( PasswordResetRequesting value)?  requesting,TResult? Function( PasswordResetCodeSent value)?  codeSent,TResult? Function( PasswordResetVerifying value)?  verifying,TResult? Function( PasswordResetVerified value)?  verified,TResult? Function( PasswordResetCompleting value)?  completing,TResult? Function( PasswordResetCompleted value)?  completed,TResult? Function( PasswordResetFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case PasswordResetIdle() when idle != null:
return idle(_that);case PasswordResetRequesting() when requesting != null:
return requesting(_that);case PasswordResetCodeSent() when codeSent != null:
return codeSent(_that);case PasswordResetVerifying() when verifying != null:
return verifying(_that);case PasswordResetVerified() when verified != null:
return verified(_that);case PasswordResetCompleting() when completing != null:
return completing(_that);case PasswordResetCompleted() when completed != null:
return completed(_that);case PasswordResetFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  requesting,TResult Function( String phone,  int expiresInMinutes)?  codeSent,TResult Function()?  verifying,TResult Function( String resetToken)?  verified,TResult Function()?  completing,TResult Function()?  completed,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PasswordResetIdle() when idle != null:
return idle();case PasswordResetRequesting() when requesting != null:
return requesting();case PasswordResetCodeSent() when codeSent != null:
return codeSent(_that.phone,_that.expiresInMinutes);case PasswordResetVerifying() when verifying != null:
return verifying();case PasswordResetVerified() when verified != null:
return verified(_that.resetToken);case PasswordResetCompleting() when completing != null:
return completing();case PasswordResetCompleted() when completed != null:
return completed();case PasswordResetFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  requesting,required TResult Function( String phone,  int expiresInMinutes)  codeSent,required TResult Function()  verifying,required TResult Function( String resetToken)  verified,required TResult Function()  completing,required TResult Function()  completed,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case PasswordResetIdle():
return idle();case PasswordResetRequesting():
return requesting();case PasswordResetCodeSent():
return codeSent(_that.phone,_that.expiresInMinutes);case PasswordResetVerifying():
return verifying();case PasswordResetVerified():
return verified(_that.resetToken);case PasswordResetCompleting():
return completing();case PasswordResetCompleted():
return completed();case PasswordResetFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  requesting,TResult? Function( String phone,  int expiresInMinutes)?  codeSent,TResult? Function()?  verifying,TResult? Function( String resetToken)?  verified,TResult? Function()?  completing,TResult? Function()?  completed,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case PasswordResetIdle() when idle != null:
return idle();case PasswordResetRequesting() when requesting != null:
return requesting();case PasswordResetCodeSent() when codeSent != null:
return codeSent(_that.phone,_that.expiresInMinutes);case PasswordResetVerifying() when verifying != null:
return verifying();case PasswordResetVerified() when verified != null:
return verified(_that.resetToken);case PasswordResetCompleting() when completing != null:
return completing();case PasswordResetCompleted() when completed != null:
return completed();case PasswordResetFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class PasswordResetIdle implements PasswordResetState {
  const PasswordResetIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PasswordResetState.idle()';
}


}




/// @nodoc


class PasswordResetRequesting implements PasswordResetState {
  const PasswordResetRequesting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetRequesting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PasswordResetState.requesting()';
}


}




/// @nodoc


class PasswordResetCodeSent implements PasswordResetState {
  const PasswordResetCodeSent({required this.phone, required this.expiresInMinutes});
  

 final  String phone;
 final  int expiresInMinutes;

/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordResetCodeSentCopyWith<PasswordResetCodeSent> get copyWith => _$PasswordResetCodeSentCopyWithImpl<PasswordResetCodeSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetCodeSent&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.expiresInMinutes, expiresInMinutes) || other.expiresInMinutes == expiresInMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,phone,expiresInMinutes);

@override
String toString() {
  return 'PasswordResetState.codeSent(phone: $phone, expiresInMinutes: $expiresInMinutes)';
}


}

/// @nodoc
abstract mixin class $PasswordResetCodeSentCopyWith<$Res> implements $PasswordResetStateCopyWith<$Res> {
  factory $PasswordResetCodeSentCopyWith(PasswordResetCodeSent value, $Res Function(PasswordResetCodeSent) _then) = _$PasswordResetCodeSentCopyWithImpl;
@useResult
$Res call({
 String phone, int expiresInMinutes
});




}
/// @nodoc
class _$PasswordResetCodeSentCopyWithImpl<$Res>
    implements $PasswordResetCodeSentCopyWith<$Res> {
  _$PasswordResetCodeSentCopyWithImpl(this._self, this._then);

  final PasswordResetCodeSent _self;
  final $Res Function(PasswordResetCodeSent) _then;

/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? expiresInMinutes = null,}) {
  return _then(PasswordResetCodeSent(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,expiresInMinutes: null == expiresInMinutes ? _self.expiresInMinutes : expiresInMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PasswordResetVerifying implements PasswordResetState {
  const PasswordResetVerifying();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetVerifying);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PasswordResetState.verifying()';
}


}




/// @nodoc


class PasswordResetVerified implements PasswordResetState {
  const PasswordResetVerified(this.resetToken);
  

 final  String resetToken;

/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordResetVerifiedCopyWith<PasswordResetVerified> get copyWith => _$PasswordResetVerifiedCopyWithImpl<PasswordResetVerified>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetVerified&&(identical(other.resetToken, resetToken) || other.resetToken == resetToken));
}


@override
int get hashCode => Object.hash(runtimeType,resetToken);

@override
String toString() {
  return 'PasswordResetState.verified(resetToken: $resetToken)';
}


}

/// @nodoc
abstract mixin class $PasswordResetVerifiedCopyWith<$Res> implements $PasswordResetStateCopyWith<$Res> {
  factory $PasswordResetVerifiedCopyWith(PasswordResetVerified value, $Res Function(PasswordResetVerified) _then) = _$PasswordResetVerifiedCopyWithImpl;
@useResult
$Res call({
 String resetToken
});




}
/// @nodoc
class _$PasswordResetVerifiedCopyWithImpl<$Res>
    implements $PasswordResetVerifiedCopyWith<$Res> {
  _$PasswordResetVerifiedCopyWithImpl(this._self, this._then);

  final PasswordResetVerified _self;
  final $Res Function(PasswordResetVerified) _then;

/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? resetToken = null,}) {
  return _then(PasswordResetVerified(
null == resetToken ? _self.resetToken : resetToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PasswordResetCompleting implements PasswordResetState {
  const PasswordResetCompleting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetCompleting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PasswordResetState.completing()';
}


}




/// @nodoc


class PasswordResetCompleted implements PasswordResetState {
  const PasswordResetCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PasswordResetState.completed()';
}


}




/// @nodoc


class PasswordResetFailureState implements PasswordResetState {
  const PasswordResetFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordResetFailureStateCopyWith<PasswordResetFailureState> get copyWith => _$PasswordResetFailureStateCopyWithImpl<PasswordResetFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'PasswordResetState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PasswordResetFailureStateCopyWith<$Res> implements $PasswordResetStateCopyWith<$Res> {
  factory $PasswordResetFailureStateCopyWith(PasswordResetFailureState value, $Res Function(PasswordResetFailureState) _then) = _$PasswordResetFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$PasswordResetFailureStateCopyWithImpl<$Res>
    implements $PasswordResetFailureStateCopyWith<$Res> {
  _$PasswordResetFailureStateCopyWithImpl(this._self, this._then);

  final PasswordResetFailureState _self;
  final $Res Function(PasswordResetFailureState) _then;

/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(PasswordResetFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of PasswordResetState
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
