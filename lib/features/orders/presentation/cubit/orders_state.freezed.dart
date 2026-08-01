// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrdersState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersState()';
}


}

/// @nodoc
class $OrdersStateCopyWith<$Res>  {
$OrdersStateCopyWith(OrdersState _, $Res Function(OrdersState) __);
}


/// Adds pattern-matching-related methods to [OrdersState].
extension OrdersStatePatterns on OrdersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OrdersLoading value)?  loading,TResult Function( OrdersLoaded value)?  loaded,TResult Function( OrdersLoadFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OrdersLoading() when loading != null:
return loading(_that);case OrdersLoaded() when loaded != null:
return loaded(_that);case OrdersLoadFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OrdersLoading value)  loading,required TResult Function( OrdersLoaded value)  loaded,required TResult Function( OrdersLoadFailure value)  failure,}){
final _that = this;
switch (_that) {
case OrdersLoading():
return loading(_that);case OrdersLoaded():
return loaded(_that);case OrdersLoadFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OrdersLoading value)?  loading,TResult? Function( OrdersLoaded value)?  loaded,TResult? Function( OrdersLoadFailure value)?  failure,}){
final _that = this;
switch (_that) {
case OrdersLoading() when loading != null:
return loading(_that);case OrdersLoaded() when loaded != null:
return loaded(_that);case OrdersLoadFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<Order> orders)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OrdersLoading() when loading != null:
return loading();case OrdersLoaded() when loaded != null:
return loaded(_that.orders);case OrdersLoadFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<Order> orders)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case OrdersLoading():
return loading();case OrdersLoaded():
return loaded(_that.orders);case OrdersLoadFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<Order> orders)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case OrdersLoading() when loading != null:
return loading();case OrdersLoaded() when loaded != null:
return loaded(_that.orders);case OrdersLoadFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class OrdersLoading implements OrdersState {
  const OrdersLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersState.loading()';
}


}




/// @nodoc


class OrdersLoaded implements OrdersState {
  const OrdersLoaded(final  List<Order> orders): _orders = orders;
  

 final  List<Order> _orders;
 List<Order> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}


/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersLoadedCopyWith<OrdersLoaded> get copyWith => _$OrdersLoadedCopyWithImpl<OrdersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersLoaded&&const DeepCollectionEquality().equals(other._orders, _orders));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders));

@override
String toString() {
  return 'OrdersState.loaded(orders: $orders)';
}


}

/// @nodoc
abstract mixin class $OrdersLoadedCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory $OrdersLoadedCopyWith(OrdersLoaded value, $Res Function(OrdersLoaded) _then) = _$OrdersLoadedCopyWithImpl;
@useResult
$Res call({
 List<Order> orders
});




}
/// @nodoc
class _$OrdersLoadedCopyWithImpl<$Res>
    implements $OrdersLoadedCopyWith<$Res> {
  _$OrdersLoadedCopyWithImpl(this._self, this._then);

  final OrdersLoaded _self;
  final $Res Function(OrdersLoaded) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orders = null,}) {
  return _then(OrdersLoaded(
null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<Order>,
  ));
}


}

/// @nodoc


class OrdersLoadFailure implements OrdersState {
  const OrdersLoadFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersLoadFailureCopyWith<OrdersLoadFailure> get copyWith => _$OrdersLoadFailureCopyWithImpl<OrdersLoadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersLoadFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'OrdersState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $OrdersLoadFailureCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory $OrdersLoadFailureCopyWith(OrdersLoadFailure value, $Res Function(OrdersLoadFailure) _then) = _$OrdersLoadFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$OrdersLoadFailureCopyWithImpl<$Res>
    implements $OrdersLoadFailureCopyWith<$Res> {
  _$OrdersLoadFailureCopyWithImpl(this._self, this._then);

  final OrdersLoadFailure _self;
  final $Res Function(OrdersLoadFailure) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(OrdersLoadFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of OrdersState
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
