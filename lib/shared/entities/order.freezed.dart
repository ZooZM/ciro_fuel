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
mixin _$DriverSummary {

 String get fullName; String get phone; String get plateNumber;
/// Create a copy of DriverSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverSummaryCopyWith<DriverSummary> get copyWith => _$DriverSummaryCopyWithImpl<DriverSummary>(this as DriverSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverSummary&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber));
}


@override
int get hashCode => Object.hash(runtimeType,fullName,phone,plateNumber);

@override
String toString() {
  return 'DriverSummary(fullName: $fullName, phone: $phone, plateNumber: $plateNumber)';
}


}

/// @nodoc
abstract mixin class $DriverSummaryCopyWith<$Res>  {
  factory $DriverSummaryCopyWith(DriverSummary value, $Res Function(DriverSummary) _then) = _$DriverSummaryCopyWithImpl;
@useResult
$Res call({
 String fullName, String phone, String plateNumber
});




}
/// @nodoc
class _$DriverSummaryCopyWithImpl<$Res>
    implements $DriverSummaryCopyWith<$Res> {
  _$DriverSummaryCopyWithImpl(this._self, this._then);

  final DriverSummary _self;
  final $Res Function(DriverSummary) _then;

/// Create a copy of DriverSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? phone = null,Object? plateNumber = null,}) {
  return _then(_self.copyWith(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,plateNumber: null == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverSummary].
extension DriverSummaryPatterns on DriverSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverSummary value)  $default,){
final _that = this;
switch (_that) {
case _DriverSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DriverSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName,  String phone,  String plateNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverSummary() when $default != null:
return $default(_that.fullName,_that.phone,_that.plateNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName,  String phone,  String plateNumber)  $default,) {final _that = this;
switch (_that) {
case _DriverSummary():
return $default(_that.fullName,_that.phone,_that.plateNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName,  String phone,  String plateNumber)?  $default,) {final _that = this;
switch (_that) {
case _DriverSummary() when $default != null:
return $default(_that.fullName,_that.phone,_that.plateNumber);case _:
  return null;

}
}

}

/// @nodoc


class _DriverSummary implements DriverSummary {
  const _DriverSummary({required this.fullName, required this.phone, required this.plateNumber});
  

@override final  String fullName;
@override final  String phone;
@override final  String plateNumber;

/// Create a copy of DriverSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverSummaryCopyWith<_DriverSummary> get copyWith => __$DriverSummaryCopyWithImpl<_DriverSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverSummary&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber));
}


@override
int get hashCode => Object.hash(runtimeType,fullName,phone,plateNumber);

@override
String toString() {
  return 'DriverSummary(fullName: $fullName, phone: $phone, plateNumber: $plateNumber)';
}


}

/// @nodoc
abstract mixin class _$DriverSummaryCopyWith<$Res> implements $DriverSummaryCopyWith<$Res> {
  factory _$DriverSummaryCopyWith(_DriverSummary value, $Res Function(_DriverSummary) _then) = __$DriverSummaryCopyWithImpl;
@override @useResult
$Res call({
 String fullName, String phone, String plateNumber
});




}
/// @nodoc
class __$DriverSummaryCopyWithImpl<$Res>
    implements _$DriverSummaryCopyWith<$Res> {
  __$DriverSummaryCopyWithImpl(this._self, this._then);

  final _DriverSummary _self;
  final $Res Function(_DriverSummary) _then;

/// Create a copy of DriverSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? phone = null,Object? plateNumber = null,}) {
  return _then(_DriverSummary(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,plateNumber: null == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$Order {

 String get id; OrderStatus get status; FuelType get fuelType; int get quantityLiters; Money? get estimatedPrice; Money? get finalPrice; PaymentMethod? get paymentMethod; String? get invoiceId;// Set once the invoice is issued at approval and unset on settlement —
// absent for DEFERRED/CREDIT orders, which never gate on payment.
 DateTime? get paymentDeadline; String? get driverId; DriverSummary? get driverSummary;// spec 004 FR-029: derived live from the driver's last known position —
// absent (never fabricated) until a driver is assigned and has reported one.
 int? get etaMinutes;// The driver's last known position, as the platform holds it — the same
// point `etaMinutes` was derived from. Lets the tracking map draw the
// truck on open instead of staying blank until the driver's next
// throttled socket ping; live movement still arrives over `/tracking`.
 GeoPoint? get driverLocation; GeoPoint? get destination;// spec 004 FR-009/FR-030: the client's station address, snapshotted at
// order creation — the only human-readable destination the backend
// stores (coordinates remain the fallback when it is empty).
 String? get deliveryAddressText;// The station as it stands *now*, used only to fill in for an empty
// snapshot above — an order placed before the station had an address
// would otherwise show the client raw coordinates forever. Kept as plain
// strings rather than the stations feature's `Station`, so this shared
// entity does not depend on a feature package.
 String? get stationName; String? get stationAddressText; DateTime get statusChangedAt;// spec 005 D3/FR-011e: absent for orders placed before this feature or
// created without a quote token — a total-only receipt then, never a
// fabricated or zeroed-out breakdown.
 PriceBreakdown? get priceBreakdown;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.paymentDeadline, paymentDeadline) || other.paymentDeadline == paymentDeadline)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.driverSummary, driverSummary) || other.driverSummary == driverSummary)&&(identical(other.etaMinutes, etaMinutes) || other.etaMinutes == etaMinutes)&&(identical(other.driverLocation, driverLocation) || other.driverLocation == driverLocation)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.deliveryAddressText, deliveryAddressText) || other.deliveryAddressText == deliveryAddressText)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.stationAddressText, stationAddressText) || other.stationAddressText == stationAddressText)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt)&&(identical(other.priceBreakdown, priceBreakdown) || other.priceBreakdown == priceBreakdown));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,status,fuelType,quantityLiters,estimatedPrice,finalPrice,paymentMethod,invoiceId,paymentDeadline,driverId,driverSummary,etaMinutes,driverLocation,destination,deliveryAddressText,stationName,stationAddressText,statusChangedAt,priceBreakdown]);

@override
String toString() {
  return 'Order(id: $id, status: $status, fuelType: $fuelType, quantityLiters: $quantityLiters, estimatedPrice: $estimatedPrice, finalPrice: $finalPrice, paymentMethod: $paymentMethod, invoiceId: $invoiceId, paymentDeadline: $paymentDeadline, driverId: $driverId, driverSummary: $driverSummary, etaMinutes: $etaMinutes, driverLocation: $driverLocation, destination: $destination, deliveryAddressText: $deliveryAddressText, stationName: $stationName, stationAddressText: $stationAddressText, statusChangedAt: $statusChangedAt, priceBreakdown: $priceBreakdown)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, OrderStatus status, FuelType fuelType, int quantityLiters, Money? estimatedPrice, Money? finalPrice, PaymentMethod? paymentMethod, String? invoiceId, DateTime? paymentDeadline, String? driverId, DriverSummary? driverSummary, int? etaMinutes, GeoPoint? driverLocation, GeoPoint? destination, String? deliveryAddressText, String? stationName, String? stationAddressText, DateTime statusChangedAt, PriceBreakdown? priceBreakdown
});


$MoneyCopyWith<$Res>? get estimatedPrice;$MoneyCopyWith<$Res>? get finalPrice;$DriverSummaryCopyWith<$Res>? get driverSummary;$GeoPointCopyWith<$Res>? get driverLocation;$GeoPointCopyWith<$Res>? get destination;$PriceBreakdownCopyWith<$Res>? get priceBreakdown;

}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? fuelType = null,Object? quantityLiters = null,Object? estimatedPrice = freezed,Object? finalPrice = freezed,Object? paymentMethod = freezed,Object? invoiceId = freezed,Object? paymentDeadline = freezed,Object? driverId = freezed,Object? driverSummary = freezed,Object? etaMinutes = freezed,Object? driverLocation = freezed,Object? destination = freezed,Object? deliveryAddressText = freezed,Object? stationName = freezed,Object? stationAddressText = freezed,Object? statusChangedAt = null,Object? priceBreakdown = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as int,estimatedPrice: freezed == estimatedPrice ? _self.estimatedPrice : estimatedPrice // ignore: cast_nullable_to_non_nullable
as Money?,finalPrice: freezed == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as Money?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod?,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String?,paymentDeadline: freezed == paymentDeadline ? _self.paymentDeadline : paymentDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as String?,driverSummary: freezed == driverSummary ? _self.driverSummary : driverSummary // ignore: cast_nullable_to_non_nullable
as DriverSummary?,etaMinutes: freezed == etaMinutes ? _self.etaMinutes : etaMinutes // ignore: cast_nullable_to_non_nullable
as int?,driverLocation: freezed == driverLocation ? _self.driverLocation : driverLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as GeoPoint?,deliveryAddressText: freezed == deliveryAddressText ? _self.deliveryAddressText : deliveryAddressText // ignore: cast_nullable_to_non_nullable
as String?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,stationAddressText: freezed == stationAddressText ? _self.stationAddressText : stationAddressText // ignore: cast_nullable_to_non_nullable
as String?,statusChangedAt: null == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priceBreakdown: freezed == priceBreakdown ? _self.priceBreakdown : priceBreakdown // ignore: cast_nullable_to_non_nullable
as PriceBreakdown?,
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
$DriverSummaryCopyWith<$Res>? get driverSummary {
    if (_self.driverSummary == null) {
    return null;
  }

  return $DriverSummaryCopyWith<$Res>(_self.driverSummary!, (value) {
    return _then(_self.copyWith(driverSummary: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get driverLocation {
    if (_self.driverLocation == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.driverLocation!, (value) {
    return _then(_self.copyWith(driverLocation: value));
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
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceBreakdownCopyWith<$Res>? get priceBreakdown {
    if (_self.priceBreakdown == null) {
    return null;
  }

  return $PriceBreakdownCopyWith<$Res>(_self.priceBreakdown!, (value) {
    return _then(_self.copyWith(priceBreakdown: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  OrderStatus status,  FuelType fuelType,  int quantityLiters,  Money? estimatedPrice,  Money? finalPrice,  PaymentMethod? paymentMethod,  String? invoiceId,  DateTime? paymentDeadline,  String? driverId,  DriverSummary? driverSummary,  int? etaMinutes,  GeoPoint? driverLocation,  GeoPoint? destination,  String? deliveryAddressText,  String? stationName,  String? stationAddressText,  DateTime statusChangedAt,  PriceBreakdown? priceBreakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.status,_that.fuelType,_that.quantityLiters,_that.estimatedPrice,_that.finalPrice,_that.paymentMethod,_that.invoiceId,_that.paymentDeadline,_that.driverId,_that.driverSummary,_that.etaMinutes,_that.driverLocation,_that.destination,_that.deliveryAddressText,_that.stationName,_that.stationAddressText,_that.statusChangedAt,_that.priceBreakdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  OrderStatus status,  FuelType fuelType,  int quantityLiters,  Money? estimatedPrice,  Money? finalPrice,  PaymentMethod? paymentMethod,  String? invoiceId,  DateTime? paymentDeadline,  String? driverId,  DriverSummary? driverSummary,  int? etaMinutes,  GeoPoint? driverLocation,  GeoPoint? destination,  String? deliveryAddressText,  String? stationName,  String? stationAddressText,  DateTime statusChangedAt,  PriceBreakdown? priceBreakdown)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.status,_that.fuelType,_that.quantityLiters,_that.estimatedPrice,_that.finalPrice,_that.paymentMethod,_that.invoiceId,_that.paymentDeadline,_that.driverId,_that.driverSummary,_that.etaMinutes,_that.driverLocation,_that.destination,_that.deliveryAddressText,_that.stationName,_that.stationAddressText,_that.statusChangedAt,_that.priceBreakdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  OrderStatus status,  FuelType fuelType,  int quantityLiters,  Money? estimatedPrice,  Money? finalPrice,  PaymentMethod? paymentMethod,  String? invoiceId,  DateTime? paymentDeadline,  String? driverId,  DriverSummary? driverSummary,  int? etaMinutes,  GeoPoint? driverLocation,  GeoPoint? destination,  String? deliveryAddressText,  String? stationName,  String? stationAddressText,  DateTime statusChangedAt,  PriceBreakdown? priceBreakdown)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.status,_that.fuelType,_that.quantityLiters,_that.estimatedPrice,_that.finalPrice,_that.paymentMethod,_that.invoiceId,_that.paymentDeadline,_that.driverId,_that.driverSummary,_that.etaMinutes,_that.driverLocation,_that.destination,_that.deliveryAddressText,_that.stationName,_that.stationAddressText,_that.statusChangedAt,_that.priceBreakdown);case _:
  return null;

}
}

}

/// @nodoc


class _Order implements Order {
  const _Order({required this.id, required this.status, required this.fuelType, required this.quantityLiters, this.estimatedPrice, this.finalPrice, this.paymentMethod, this.invoiceId, this.paymentDeadline, this.driverId, this.driverSummary, this.etaMinutes, this.driverLocation, this.destination, this.deliveryAddressText, this.stationName, this.stationAddressText, required this.statusChangedAt, this.priceBreakdown});
  

@override final  String id;
@override final  OrderStatus status;
@override final  FuelType fuelType;
@override final  int quantityLiters;
@override final  Money? estimatedPrice;
@override final  Money? finalPrice;
@override final  PaymentMethod? paymentMethod;
@override final  String? invoiceId;
// Set once the invoice is issued at approval and unset on settlement —
// absent for DEFERRED/CREDIT orders, which never gate on payment.
@override final  DateTime? paymentDeadline;
@override final  String? driverId;
@override final  DriverSummary? driverSummary;
// spec 004 FR-029: derived live from the driver's last known position —
// absent (never fabricated) until a driver is assigned and has reported one.
@override final  int? etaMinutes;
// The driver's last known position, as the platform holds it — the same
// point `etaMinutes` was derived from. Lets the tracking map draw the
// truck on open instead of staying blank until the driver's next
// throttled socket ping; live movement still arrives over `/tracking`.
@override final  GeoPoint? driverLocation;
@override final  GeoPoint? destination;
// spec 004 FR-009/FR-030: the client's station address, snapshotted at
// order creation — the only human-readable destination the backend
// stores (coordinates remain the fallback when it is empty).
@override final  String? deliveryAddressText;
// The station as it stands *now*, used only to fill in for an empty
// snapshot above — an order placed before the station had an address
// would otherwise show the client raw coordinates forever. Kept as plain
// strings rather than the stations feature's `Station`, so this shared
// entity does not depend on a feature package.
@override final  String? stationName;
@override final  String? stationAddressText;
@override final  DateTime statusChangedAt;
// spec 005 D3/FR-011e: absent for orders placed before this feature or
// created without a quote token — a total-only receipt then, never a
// fabricated or zeroed-out breakdown.
@override final  PriceBreakdown? priceBreakdown;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.paymentDeadline, paymentDeadline) || other.paymentDeadline == paymentDeadline)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.driverSummary, driverSummary) || other.driverSummary == driverSummary)&&(identical(other.etaMinutes, etaMinutes) || other.etaMinutes == etaMinutes)&&(identical(other.driverLocation, driverLocation) || other.driverLocation == driverLocation)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.deliveryAddressText, deliveryAddressText) || other.deliveryAddressText == deliveryAddressText)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.stationAddressText, stationAddressText) || other.stationAddressText == stationAddressText)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt)&&(identical(other.priceBreakdown, priceBreakdown) || other.priceBreakdown == priceBreakdown));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,status,fuelType,quantityLiters,estimatedPrice,finalPrice,paymentMethod,invoiceId,paymentDeadline,driverId,driverSummary,etaMinutes,driverLocation,destination,deliveryAddressText,stationName,stationAddressText,statusChangedAt,priceBreakdown]);

@override
String toString() {
  return 'Order(id: $id, status: $status, fuelType: $fuelType, quantityLiters: $quantityLiters, estimatedPrice: $estimatedPrice, finalPrice: $finalPrice, paymentMethod: $paymentMethod, invoiceId: $invoiceId, paymentDeadline: $paymentDeadline, driverId: $driverId, driverSummary: $driverSummary, etaMinutes: $etaMinutes, driverLocation: $driverLocation, destination: $destination, deliveryAddressText: $deliveryAddressText, stationName: $stationName, stationAddressText: $stationAddressText, statusChangedAt: $statusChangedAt, priceBreakdown: $priceBreakdown)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, OrderStatus status, FuelType fuelType, int quantityLiters, Money? estimatedPrice, Money? finalPrice, PaymentMethod? paymentMethod, String? invoiceId, DateTime? paymentDeadline, String? driverId, DriverSummary? driverSummary, int? etaMinutes, GeoPoint? driverLocation, GeoPoint? destination, String? deliveryAddressText, String? stationName, String? stationAddressText, DateTime statusChangedAt, PriceBreakdown? priceBreakdown
});


@override $MoneyCopyWith<$Res>? get estimatedPrice;@override $MoneyCopyWith<$Res>? get finalPrice;@override $DriverSummaryCopyWith<$Res>? get driverSummary;@override $GeoPointCopyWith<$Res>? get driverLocation;@override $GeoPointCopyWith<$Res>? get destination;@override $PriceBreakdownCopyWith<$Res>? get priceBreakdown;

}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? fuelType = null,Object? quantityLiters = null,Object? estimatedPrice = freezed,Object? finalPrice = freezed,Object? paymentMethod = freezed,Object? invoiceId = freezed,Object? paymentDeadline = freezed,Object? driverId = freezed,Object? driverSummary = freezed,Object? etaMinutes = freezed,Object? driverLocation = freezed,Object? destination = freezed,Object? deliveryAddressText = freezed,Object? stationName = freezed,Object? stationAddressText = freezed,Object? statusChangedAt = null,Object? priceBreakdown = freezed,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,quantityLiters: null == quantityLiters ? _self.quantityLiters : quantityLiters // ignore: cast_nullable_to_non_nullable
as int,estimatedPrice: freezed == estimatedPrice ? _self.estimatedPrice : estimatedPrice // ignore: cast_nullable_to_non_nullable
as Money?,finalPrice: freezed == finalPrice ? _self.finalPrice : finalPrice // ignore: cast_nullable_to_non_nullable
as Money?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod?,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String?,paymentDeadline: freezed == paymentDeadline ? _self.paymentDeadline : paymentDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as String?,driverSummary: freezed == driverSummary ? _self.driverSummary : driverSummary // ignore: cast_nullable_to_non_nullable
as DriverSummary?,etaMinutes: freezed == etaMinutes ? _self.etaMinutes : etaMinutes // ignore: cast_nullable_to_non_nullable
as int?,driverLocation: freezed == driverLocation ? _self.driverLocation : driverLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as GeoPoint?,deliveryAddressText: freezed == deliveryAddressText ? _self.deliveryAddressText : deliveryAddressText // ignore: cast_nullable_to_non_nullable
as String?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,stationAddressText: freezed == stationAddressText ? _self.stationAddressText : stationAddressText // ignore: cast_nullable_to_non_nullable
as String?,statusChangedAt: null == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priceBreakdown: freezed == priceBreakdown ? _self.priceBreakdown : priceBreakdown // ignore: cast_nullable_to_non_nullable
as PriceBreakdown?,
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
$DriverSummaryCopyWith<$Res>? get driverSummary {
    if (_self.driverSummary == null) {
    return null;
  }

  return $DriverSummaryCopyWith<$Res>(_self.driverSummary!, (value) {
    return _then(_self.copyWith(driverSummary: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get driverLocation {
    if (_self.driverLocation == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.driverLocation!, (value) {
    return _then(_self.copyWith(driverLocation: value));
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
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceBreakdownCopyWith<$Res>? get priceBreakdown {
    if (_self.priceBreakdown == null) {
    return null;
  }

  return $PriceBreakdownCopyWith<$Res>(_self.priceBreakdown!, (value) {
    return _then(_self.copyWith(priceBreakdown: value));
  });
}
}

// dart format on
