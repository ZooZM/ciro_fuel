// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_verification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VehicleVerificationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleVerificationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VehicleVerificationState()';
}


}

/// @nodoc
class $VehicleVerificationStateCopyWith<$Res>  {
$VehicleVerificationStateCopyWith(VehicleVerificationState _, $Res Function(VehicleVerificationState) __);
}


/// Adds pattern-matching-related methods to [VehicleVerificationState].
extension VehicleVerificationStatePatterns on VehicleVerificationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( VehicleVerificationIdle value)?  idle,TResult Function( VehicleVerificationReading value)?  reading,TResult Function( VehicleVerificationSubmitting value)?  submitting,TResult Function( VehicleVerificationVerified value)?  verified,TResult Function( VehicleVerificationMismatch value)?  mismatch,TResult Function( VehicleVerificationNotAtWarehouse value)?  notAtWarehouse,TResult Function( VehicleVerificationLocationUnavailable value)?  locationUnavailable,TResult Function( VehicleVerificationThrottled value)?  throttled,TResult Function( VehicleVerificationFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case VehicleVerificationIdle() when idle != null:
return idle(_that);case VehicleVerificationReading() when reading != null:
return reading(_that);case VehicleVerificationSubmitting() when submitting != null:
return submitting(_that);case VehicleVerificationVerified() when verified != null:
return verified(_that);case VehicleVerificationMismatch() when mismatch != null:
return mismatch(_that);case VehicleVerificationNotAtWarehouse() when notAtWarehouse != null:
return notAtWarehouse(_that);case VehicleVerificationLocationUnavailable() when locationUnavailable != null:
return locationUnavailable(_that);case VehicleVerificationThrottled() when throttled != null:
return throttled(_that);case VehicleVerificationFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( VehicleVerificationIdle value)  idle,required TResult Function( VehicleVerificationReading value)  reading,required TResult Function( VehicleVerificationSubmitting value)  submitting,required TResult Function( VehicleVerificationVerified value)  verified,required TResult Function( VehicleVerificationMismatch value)  mismatch,required TResult Function( VehicleVerificationNotAtWarehouse value)  notAtWarehouse,required TResult Function( VehicleVerificationLocationUnavailable value)  locationUnavailable,required TResult Function( VehicleVerificationThrottled value)  throttled,required TResult Function( VehicleVerificationFailure value)  failure,}){
final _that = this;
switch (_that) {
case VehicleVerificationIdle():
return idle(_that);case VehicleVerificationReading():
return reading(_that);case VehicleVerificationSubmitting():
return submitting(_that);case VehicleVerificationVerified():
return verified(_that);case VehicleVerificationMismatch():
return mismatch(_that);case VehicleVerificationNotAtWarehouse():
return notAtWarehouse(_that);case VehicleVerificationLocationUnavailable():
return locationUnavailable(_that);case VehicleVerificationThrottled():
return throttled(_that);case VehicleVerificationFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( VehicleVerificationIdle value)?  idle,TResult? Function( VehicleVerificationReading value)?  reading,TResult? Function( VehicleVerificationSubmitting value)?  submitting,TResult? Function( VehicleVerificationVerified value)?  verified,TResult? Function( VehicleVerificationMismatch value)?  mismatch,TResult? Function( VehicleVerificationNotAtWarehouse value)?  notAtWarehouse,TResult? Function( VehicleVerificationLocationUnavailable value)?  locationUnavailable,TResult? Function( VehicleVerificationThrottled value)?  throttled,TResult? Function( VehicleVerificationFailure value)?  failure,}){
final _that = this;
switch (_that) {
case VehicleVerificationIdle() when idle != null:
return idle(_that);case VehicleVerificationReading() when reading != null:
return reading(_that);case VehicleVerificationSubmitting() when submitting != null:
return submitting(_that);case VehicleVerificationVerified() when verified != null:
return verified(_that);case VehicleVerificationMismatch() when mismatch != null:
return mismatch(_that);case VehicleVerificationNotAtWarehouse() when notAtWarehouse != null:
return notAtWarehouse(_that);case VehicleVerificationLocationUnavailable() when locationUnavailable != null:
return locationUnavailable(_that);case VehicleVerificationThrottled() when throttled != null:
return throttled(_that);case VehicleVerificationFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool nfcAvailable)?  idle,TResult Function()?  reading,TResult Function()?  submitting,TResult Function( Order order)?  verified,TResult Function()?  mismatch,TResult Function( double? distanceMeters)?  notAtWarehouse,TResult Function()?  locationUnavailable,TResult Function( Duration? retryAfter)?  throttled,TResult Function( bool unreachable)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case VehicleVerificationIdle() when idle != null:
return idle(_that.nfcAvailable);case VehicleVerificationReading() when reading != null:
return reading();case VehicleVerificationSubmitting() when submitting != null:
return submitting();case VehicleVerificationVerified() when verified != null:
return verified(_that.order);case VehicleVerificationMismatch() when mismatch != null:
return mismatch();case VehicleVerificationNotAtWarehouse() when notAtWarehouse != null:
return notAtWarehouse(_that.distanceMeters);case VehicleVerificationLocationUnavailable() when locationUnavailable != null:
return locationUnavailable();case VehicleVerificationThrottled() when throttled != null:
return throttled(_that.retryAfter);case VehicleVerificationFailure() when failure != null:
return failure(_that.unreachable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool nfcAvailable)  idle,required TResult Function()  reading,required TResult Function()  submitting,required TResult Function( Order order)  verified,required TResult Function()  mismatch,required TResult Function( double? distanceMeters)  notAtWarehouse,required TResult Function()  locationUnavailable,required TResult Function( Duration? retryAfter)  throttled,required TResult Function( bool unreachable)  failure,}) {final _that = this;
switch (_that) {
case VehicleVerificationIdle():
return idle(_that.nfcAvailable);case VehicleVerificationReading():
return reading();case VehicleVerificationSubmitting():
return submitting();case VehicleVerificationVerified():
return verified(_that.order);case VehicleVerificationMismatch():
return mismatch();case VehicleVerificationNotAtWarehouse():
return notAtWarehouse(_that.distanceMeters);case VehicleVerificationLocationUnavailable():
return locationUnavailable();case VehicleVerificationThrottled():
return throttled(_that.retryAfter);case VehicleVerificationFailure():
return failure(_that.unreachable);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool nfcAvailable)?  idle,TResult? Function()?  reading,TResult? Function()?  submitting,TResult? Function( Order order)?  verified,TResult? Function()?  mismatch,TResult? Function( double? distanceMeters)?  notAtWarehouse,TResult? Function()?  locationUnavailable,TResult? Function( Duration? retryAfter)?  throttled,TResult? Function( bool unreachable)?  failure,}) {final _that = this;
switch (_that) {
case VehicleVerificationIdle() when idle != null:
return idle(_that.nfcAvailable);case VehicleVerificationReading() when reading != null:
return reading();case VehicleVerificationSubmitting() when submitting != null:
return submitting();case VehicleVerificationVerified() when verified != null:
return verified(_that.order);case VehicleVerificationMismatch() when mismatch != null:
return mismatch();case VehicleVerificationNotAtWarehouse() when notAtWarehouse != null:
return notAtWarehouse(_that.distanceMeters);case VehicleVerificationLocationUnavailable() when locationUnavailable != null:
return locationUnavailable();case VehicleVerificationThrottled() when throttled != null:
return throttled(_that.retryAfter);case VehicleVerificationFailure() when failure != null:
return failure(_that.unreachable);case _:
  return null;

}
}

}

/// @nodoc


class VehicleVerificationIdle implements VehicleVerificationState {
  const VehicleVerificationIdle({required this.nfcAvailable});
  

 final  bool nfcAvailable;

/// Create a copy of VehicleVerificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleVerificationIdleCopyWith<VehicleVerificationIdle> get copyWith => _$VehicleVerificationIdleCopyWithImpl<VehicleVerificationIdle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleVerificationIdle&&(identical(other.nfcAvailable, nfcAvailable) || other.nfcAvailable == nfcAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,nfcAvailable);

@override
String toString() {
  return 'VehicleVerificationState.idle(nfcAvailable: $nfcAvailable)';
}


}

/// @nodoc
abstract mixin class $VehicleVerificationIdleCopyWith<$Res> implements $VehicleVerificationStateCopyWith<$Res> {
  factory $VehicleVerificationIdleCopyWith(VehicleVerificationIdle value, $Res Function(VehicleVerificationIdle) _then) = _$VehicleVerificationIdleCopyWithImpl;
@useResult
$Res call({
 bool nfcAvailable
});




}
/// @nodoc
class _$VehicleVerificationIdleCopyWithImpl<$Res>
    implements $VehicleVerificationIdleCopyWith<$Res> {
  _$VehicleVerificationIdleCopyWithImpl(this._self, this._then);

  final VehicleVerificationIdle _self;
  final $Res Function(VehicleVerificationIdle) _then;

/// Create a copy of VehicleVerificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? nfcAvailable = null,}) {
  return _then(VehicleVerificationIdle(
nfcAvailable: null == nfcAvailable ? _self.nfcAvailable : nfcAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class VehicleVerificationReading implements VehicleVerificationState {
  const VehicleVerificationReading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleVerificationReading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VehicleVerificationState.reading()';
}


}




/// @nodoc


class VehicleVerificationSubmitting implements VehicleVerificationState {
  const VehicleVerificationSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleVerificationSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VehicleVerificationState.submitting()';
}


}




/// @nodoc


class VehicleVerificationVerified implements VehicleVerificationState {
  const VehicleVerificationVerified(this.order);
  

 final  Order order;

/// Create a copy of VehicleVerificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleVerificationVerifiedCopyWith<VehicleVerificationVerified> get copyWith => _$VehicleVerificationVerifiedCopyWithImpl<VehicleVerificationVerified>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleVerificationVerified&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'VehicleVerificationState.verified(order: $order)';
}


}

/// @nodoc
abstract mixin class $VehicleVerificationVerifiedCopyWith<$Res> implements $VehicleVerificationStateCopyWith<$Res> {
  factory $VehicleVerificationVerifiedCopyWith(VehicleVerificationVerified value, $Res Function(VehicleVerificationVerified) _then) = _$VehicleVerificationVerifiedCopyWithImpl;
@useResult
$Res call({
 Order order
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class _$VehicleVerificationVerifiedCopyWithImpl<$Res>
    implements $VehicleVerificationVerifiedCopyWith<$Res> {
  _$VehicleVerificationVerifiedCopyWithImpl(this._self, this._then);

  final VehicleVerificationVerified _self;
  final $Res Function(VehicleVerificationVerified) _then;

/// Create a copy of VehicleVerificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(VehicleVerificationVerified(
null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,
  ));
}

/// Create a copy of VehicleVerificationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

/// @nodoc


class VehicleVerificationMismatch implements VehicleVerificationState {
  const VehicleVerificationMismatch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleVerificationMismatch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VehicleVerificationState.mismatch()';
}


}




/// @nodoc


class VehicleVerificationNotAtWarehouse implements VehicleVerificationState {
  const VehicleVerificationNotAtWarehouse({this.distanceMeters});
  

 final  double? distanceMeters;

/// Create a copy of VehicleVerificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleVerificationNotAtWarehouseCopyWith<VehicleVerificationNotAtWarehouse> get copyWith => _$VehicleVerificationNotAtWarehouseCopyWithImpl<VehicleVerificationNotAtWarehouse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleVerificationNotAtWarehouse&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters));
}


@override
int get hashCode => Object.hash(runtimeType,distanceMeters);

@override
String toString() {
  return 'VehicleVerificationState.notAtWarehouse(distanceMeters: $distanceMeters)';
}


}

/// @nodoc
abstract mixin class $VehicleVerificationNotAtWarehouseCopyWith<$Res> implements $VehicleVerificationStateCopyWith<$Res> {
  factory $VehicleVerificationNotAtWarehouseCopyWith(VehicleVerificationNotAtWarehouse value, $Res Function(VehicleVerificationNotAtWarehouse) _then) = _$VehicleVerificationNotAtWarehouseCopyWithImpl;
@useResult
$Res call({
 double? distanceMeters
});




}
/// @nodoc
class _$VehicleVerificationNotAtWarehouseCopyWithImpl<$Res>
    implements $VehicleVerificationNotAtWarehouseCopyWith<$Res> {
  _$VehicleVerificationNotAtWarehouseCopyWithImpl(this._self, this._then);

  final VehicleVerificationNotAtWarehouse _self;
  final $Res Function(VehicleVerificationNotAtWarehouse) _then;

/// Create a copy of VehicleVerificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? distanceMeters = freezed,}) {
  return _then(VehicleVerificationNotAtWarehouse(
distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc


class VehicleVerificationLocationUnavailable implements VehicleVerificationState {
  const VehicleVerificationLocationUnavailable();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleVerificationLocationUnavailable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VehicleVerificationState.locationUnavailable()';
}


}




/// @nodoc


class VehicleVerificationThrottled implements VehicleVerificationState {
  const VehicleVerificationThrottled({this.retryAfter});
  

 final  Duration? retryAfter;

/// Create a copy of VehicleVerificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleVerificationThrottledCopyWith<VehicleVerificationThrottled> get copyWith => _$VehicleVerificationThrottledCopyWithImpl<VehicleVerificationThrottled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleVerificationThrottled&&(identical(other.retryAfter, retryAfter) || other.retryAfter == retryAfter));
}


@override
int get hashCode => Object.hash(runtimeType,retryAfter);

@override
String toString() {
  return 'VehicleVerificationState.throttled(retryAfter: $retryAfter)';
}


}

/// @nodoc
abstract mixin class $VehicleVerificationThrottledCopyWith<$Res> implements $VehicleVerificationStateCopyWith<$Res> {
  factory $VehicleVerificationThrottledCopyWith(VehicleVerificationThrottled value, $Res Function(VehicleVerificationThrottled) _then) = _$VehicleVerificationThrottledCopyWithImpl;
@useResult
$Res call({
 Duration? retryAfter
});




}
/// @nodoc
class _$VehicleVerificationThrottledCopyWithImpl<$Res>
    implements $VehicleVerificationThrottledCopyWith<$Res> {
  _$VehicleVerificationThrottledCopyWithImpl(this._self, this._then);

  final VehicleVerificationThrottled _self;
  final $Res Function(VehicleVerificationThrottled) _then;

/// Create a copy of VehicleVerificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? retryAfter = freezed,}) {
  return _then(VehicleVerificationThrottled(
retryAfter: freezed == retryAfter ? _self.retryAfter : retryAfter // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

/// @nodoc


class VehicleVerificationFailure implements VehicleVerificationState {
  const VehicleVerificationFailure({this.unreachable = false});
  

@JsonKey() final  bool unreachable;

/// Create a copy of VehicleVerificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleVerificationFailureCopyWith<VehicleVerificationFailure> get copyWith => _$VehicleVerificationFailureCopyWithImpl<VehicleVerificationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleVerificationFailure&&(identical(other.unreachable, unreachable) || other.unreachable == unreachable));
}


@override
int get hashCode => Object.hash(runtimeType,unreachable);

@override
String toString() {
  return 'VehicleVerificationState.failure(unreachable: $unreachable)';
}


}

/// @nodoc
abstract mixin class $VehicleVerificationFailureCopyWith<$Res> implements $VehicleVerificationStateCopyWith<$Res> {
  factory $VehicleVerificationFailureCopyWith(VehicleVerificationFailure value, $Res Function(VehicleVerificationFailure) _then) = _$VehicleVerificationFailureCopyWithImpl;
@useResult
$Res call({
 bool unreachable
});




}
/// @nodoc
class _$VehicleVerificationFailureCopyWithImpl<$Res>
    implements $VehicleVerificationFailureCopyWith<$Res> {
  _$VehicleVerificationFailureCopyWithImpl(this._self, this._then);

  final VehicleVerificationFailure _self;
  final $Res Function(VehicleVerificationFailure) _then;

/// Create a copy of VehicleVerificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? unreachable = null,}) {
  return _then(VehicleVerificationFailure(
unreachable: null == unreachable ? _self.unreachable : unreachable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
