// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeliveryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeliveryState()';
}


}

/// @nodoc
class $DeliveryStateCopyWith<$Res>  {
$DeliveryStateCopyWith(DeliveryState _, $Res Function(DeliveryState) __);
}


/// Adds pattern-matching-related methods to [DeliveryState].
extension DeliveryStatePatterns on DeliveryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeliveryLoading value)?  loading,TResult Function( DeliveryNoActiveOrder value)?  noActiveOrder,TResult Function( DeliveryActive value)?  active,TResult Function( DeliveryFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeliveryLoading() when loading != null:
return loading(_that);case DeliveryNoActiveOrder() when noActiveOrder != null:
return noActiveOrder(_that);case DeliveryActive() when active != null:
return active(_that);case DeliveryFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeliveryLoading value)  loading,required TResult Function( DeliveryNoActiveOrder value)  noActiveOrder,required TResult Function( DeliveryActive value)  active,required TResult Function( DeliveryFailureState value)  failure,}){
final _that = this;
switch (_that) {
case DeliveryLoading():
return loading(_that);case DeliveryNoActiveOrder():
return noActiveOrder(_that);case DeliveryActive():
return active(_that);case DeliveryFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeliveryLoading value)?  loading,TResult? Function( DeliveryNoActiveOrder value)?  noActiveOrder,TResult? Function( DeliveryActive value)?  active,TResult? Function( DeliveryFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case DeliveryLoading() when loading != null:
return loading(_that);case DeliveryNoActiveOrder() when noActiveOrder != null:
return noActiveOrder(_that);case DeliveryActive() when active != null:
return active(_that);case DeliveryFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function()?  noActiveOrder,TResult Function( Order order,  bool streaming)?  active,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeliveryLoading() when loading != null:
return loading();case DeliveryNoActiveOrder() when noActiveOrder != null:
return noActiveOrder();case DeliveryActive() when active != null:
return active(_that.order,_that.streaming);case DeliveryFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function()  noActiveOrder,required TResult Function( Order order,  bool streaming)  active,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case DeliveryLoading():
return loading();case DeliveryNoActiveOrder():
return noActiveOrder();case DeliveryActive():
return active(_that.order,_that.streaming);case DeliveryFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function()?  noActiveOrder,TResult? Function( Order order,  bool streaming)?  active,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case DeliveryLoading() when loading != null:
return loading();case DeliveryNoActiveOrder() when noActiveOrder != null:
return noActiveOrder();case DeliveryActive() when active != null:
return active(_that.order,_that.streaming);case DeliveryFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DeliveryLoading implements DeliveryState {
  const DeliveryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeliveryState.loading()';
}


}




/// @nodoc


class DeliveryNoActiveOrder implements DeliveryState {
  const DeliveryNoActiveOrder();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryNoActiveOrder);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeliveryState.noActiveOrder()';
}


}




/// @nodoc


class DeliveryActive implements DeliveryState {
  const DeliveryActive(this.order, {this.streaming = false});
  

 final  Order order;
@JsonKey() final  bool streaming;

/// Create a copy of DeliveryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryActiveCopyWith<DeliveryActive> get copyWith => _$DeliveryActiveCopyWithImpl<DeliveryActive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryActive&&(identical(other.order, order) || other.order == order)&&(identical(other.streaming, streaming) || other.streaming == streaming));
}


@override
int get hashCode => Object.hash(runtimeType,order,streaming);

@override
String toString() {
  return 'DeliveryState.active(order: $order, streaming: $streaming)';
}


}

/// @nodoc
abstract mixin class $DeliveryActiveCopyWith<$Res> implements $DeliveryStateCopyWith<$Res> {
  factory $DeliveryActiveCopyWith(DeliveryActive value, $Res Function(DeliveryActive) _then) = _$DeliveryActiveCopyWithImpl;
@useResult
$Res call({
 Order order, bool streaming
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class _$DeliveryActiveCopyWithImpl<$Res>
    implements $DeliveryActiveCopyWith<$Res> {
  _$DeliveryActiveCopyWithImpl(this._self, this._then);

  final DeliveryActive _self;
  final $Res Function(DeliveryActive) _then;

/// Create a copy of DeliveryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,Object? streaming = null,}) {
  return _then(DeliveryActive(
null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,streaming: null == streaming ? _self.streaming : streaming // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DeliveryState
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


class DeliveryFailureState implements DeliveryState {
  const DeliveryFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of DeliveryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryFailureStateCopyWith<DeliveryFailureState> get copyWith => _$DeliveryFailureStateCopyWithImpl<DeliveryFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'DeliveryState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DeliveryFailureStateCopyWith<$Res> implements $DeliveryStateCopyWith<$Res> {
  factory $DeliveryFailureStateCopyWith(DeliveryFailureState value, $Res Function(DeliveryFailureState) _then) = _$DeliveryFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$DeliveryFailureStateCopyWithImpl<$Res>
    implements $DeliveryFailureStateCopyWith<$Res> {
  _$DeliveryFailureStateCopyWithImpl(this._self, this._then);

  final DeliveryFailureState _self;
  final $Res Function(DeliveryFailureState) _then;

/// Create a copy of DeliveryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DeliveryFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of DeliveryState
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
