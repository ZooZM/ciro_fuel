// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 String get id;@OrderStatusConverter() OrderStatus get status;@FuelTypeConverter() FuelType get fuelType; int get quantityLiters; Money? get estimatedPrice; Money? get finalPrice; String? get paymentReference; DateTime? get paymentWindowEndsAt; String? get assignedDriverId; GeoPoint? get destination; DateTime get statusChangedAt;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice)&&(identical(other.paymentReference, paymentReference) || other.paymentReference == paymentReference)&&(identical(other.paymentWindowEndsAt, paymentWindowEndsAt) || other.paymentWindowEndsAt == paymentWindowEndsAt)&&(identical(other.assignedDriverId, assignedDriverId) || other.assignedDriverId == assignedDriverId)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,fuelType,quantityLiters,estimatedPrice,finalPrice,paymentReference,paymentWindowEndsAt,assignedDriverId,destination,statusChangedAt);

@override
String toString() {
  return 'Order(id: $id, status: $status, fuelType: $fuelType, quantityLiters: $quantityLiters, estimatedPrice: $estimatedPrice, finalPrice: $finalPrice, paymentReference: $paymentReference, paymentWindowEndsAt: $paymentWindowEndsAt, assignedDriverId: $assignedDriverId, destination: $destination, statusChangedAt: $statusChangedAt)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id,@OrderStatusConverter() OrderStatus status,@FuelTypeConverter() FuelType fuelType, int quantityLiters, Money? estimatedPrice, Money? finalPrice, String? paymentReference, DateTime? paymentWindowEndsAt, String? assignedDriverId, GeoPoint? destination, DateTime statusChangedAt
});


$MoneyCopyWith<$Res>? get estimatedPrice;$MoneyCopyWith<$Res>? get finalPrice;$GeoPointCopyWith<$Res>? get destination;

}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? fuelType = null,Object? quantityLiters = null,Object? estimatedPrice = freezed,Object? finalPrice = freezed,Object? paymentReference = freezed,Object? paymentWindowEndsAt = freezed,Object? assignedDriverId = freezed,Object? destination = freezed,Object? statusChangedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as int,estimatedPrice: freezed == estimatedPrice ? _self.estimatedPrice : estimatedPrice // ignore: cast_nullable_to_non_nullable
as Money?,finalPrice: freezed == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as Money?,paymentReference: freezed == paymentReference ? _self.paymentReference : paymentReference // ignore: cast_nullable_to_non_nullable
as String?,paymentWindowEndsAt: freezed == paymentWindowEndsAt ? _self.paymentWindowEndsAt : paymentWindowEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,assignedDriverId: freezed == assignedDriverId ? _self.assignedDriverId : assignedDriverId // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as GeoPoint?,statusChangedAt: null == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res>? get estimatedPrice {
    if (_self.estimatedPrice == null) {
    return null;
  }

  return $MoneyCopyWith<$Res>(_self.estimatedPrice!, (value) {
    return _then(_self.copyWith(estimatedPrice: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res>? get finalPrice {
    if (_self.finalPrice == null) {
    return null;
  }

  return $MoneyCopyWith<$Res>(_self.finalPrice!, (value) {
    return _then(_self.copyWith(finalPrice: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get destination {
    if (_self.destination == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.destination!, (value) {
    return _then(_self.copyWith(destination: value));
  });
}
}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @OrderStatusConverter()  OrderStatus status, @FuelTypeConverter()  FuelType fuelType,  int quantityLiters,  Money? estimatedPrice,  Money? finalPrice,  String? paymentReference,  DateTime? paymentWindowEndsAt,  String? assignedDriverId,  GeoPoint? destination,  DateTime statusChangedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.status,_that.fuelType,_that.quantityLiters,_that.estimatedPrice,_that.finalPrice,_that.paymentReference,_that.paymentWindowEndsAt,_that.assignedDriverId,_that.destination,_that.statusChangedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @OrderStatusConverter()  OrderStatus status, @FuelTypeConverter()  FuelType fuelType,  int quantityLiters,  Money? estimatedPrice,  Money? finalPrice,  String? paymentReference,  DateTime? paymentWindowEndsAt,  String? assignedDriverId,  GeoPoint? destination,  DateTime statusChangedAt)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.status,_that.fuelType,_that.quantityLiters,_that.estimatedPrice,_that.finalPrice,_that.paymentReference,_that.paymentWindowEndsAt,_that.assignedDriverId,_that.destination,_that.statusChangedAt);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @OrderStatusConverter()  OrderStatus status, @FuelTypeConverter()  FuelType fuelType,  int quantityLiters,  Money? estimatedPrice,  Money? finalPrice,  String? paymentReference,  DateTime? paymentWindowEndsAt,  String? assignedDriverId,  GeoPoint? destination,  DateTime statusChangedAt)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.status,_that.fuelType,_that.quantityLiters,_that.estimatedPrice,_that.finalPrice,_that.paymentReference,_that.paymentWindowEndsAt,_that.assignedDriverId,_that.destination,_that.statusChangedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order implements Order {
  const _Order({required this.id, @OrderStatusConverter() required this.status, @FuelTypeConverter() required this.fuelType, required this.quantityLiters, this.estimatedPrice, this.finalPrice, this.paymentReference, this.paymentWindowEndsAt, this.assignedDriverId, this.destination, required this.statusChangedAt});
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
@override@OrderStatusConverter() final  OrderStatus status;
@override@FuelTypeConverter() final  FuelType fuelType;
@override final  int quantityLiters;
@override final  Money? estimatedPrice;
@override final  Money? finalPrice;
@override final  String? paymentReference;
@override final  DateTime? paymentWindowEndsAt;
@override final  String? assignedDriverId;
@override final  GeoPoint? destination;
@override final  DateTime statusChangedAt;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice)&&(identical(other.paymentReference, paymentReference) || other.paymentReference == paymentReference)&&(identical(other.paymentWindowEndsAt, paymentWindowEndsAt) || other.paymentWindowEndsAt == paymentWindowEndsAt)&&(identical(other.assignedDriverId, assignedDriverId) || other.assignedDriverId == assignedDriverId)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,fuelType,quantityLiters,estimatedPrice,finalPrice,paymentReference,paymentWindowEndsAt,assignedDriverId,destination,statusChangedAt);

@override
String toString() {
  return 'Order(id: $id, status: $status, fuelType: $fuelType, quantityLiters: $quantityLiters, estimatedPrice: $estimatedPrice, finalPrice: $finalPrice, paymentReference: $paymentReference, paymentWindowEndsAt: $paymentWindowEndsAt, assignedDriverId: $assignedDriverId, destination: $destination, statusChangedAt: $statusChangedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id,@OrderStatusConverter() OrderStatus status,@FuelTypeConverter() FuelType fuelType, int quantityLiters, Money? estimatedPrice, Money? finalPrice, String? paymentReference, DateTime? paymentWindowEndsAt, String? assignedDriverId, GeoPoint? destination, DateTime statusChangedAt
});


@override $MoneyCopyWith<$Res>? get estimatedPrice;@override $MoneyCopyWith<$Res>? get finalPrice;@override $GeoPointCopyWith<$Res>? get destination;

}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? fuelType = null,Object? quantityLiters = null,Object? estimatedPrice = freezed,Object? finalPrice = freezed,Object? paymentReference = freezed,Object? paymentWindowEndsAt = freezed,Object? assignedDriverId = freezed,Object? destination = freezed,Object? statusChangedAt = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as int,estimatedPrice: freezed == estimatedPrice ? _self.estimatedPrice : estimatedPrice // ignore: cast_nullable_to_non_nullable
as Money?,finalPrice: freezed == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as Money?,paymentReference: freezed == paymentReference ? _self.paymentReference : paymentReference // ignore: cast_nullable_to_non_nullable
as String?,paymentWindowEndsAt: freezed == paymentWindowEndsAt ? _self.paymentWindowEndsAt : paymentWindowEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,assignedDriverId: freezed == assignedDriverId ? _self.assignedDriverId : assignedDriverId // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as GeoPoint?,statusChangedAt: null == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res>? get estimatedPrice {
    if (_self.estimatedPrice == null) {
    return null;
  }

  return $MoneyCopyWith<$Res>(_self.estimatedPrice!, (value) {
    return _then(_self.copyWith(estimatedPrice: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res>? get finalPrice {
    if (_self.finalPrice == null) {
    return null;
  }

  return $MoneyCopyWith<$Res>(_self.finalPrice!, (value) {
    return _then(_self.copyWith(finalPrice: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get destination {
    if (_self.destination == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.destination!, (value) {
    return _then(_self.copyWith(destination: value));
  });
}
}

// dart format on
