// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pricing_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FuelPrice {

 FuelType get fuelType; double get basePricePerLiter;
/// Create a copy of FuelPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FuelPriceCopyWith<FuelPrice> get copyWith => _$FuelPriceCopyWithImpl<FuelPrice>(this as FuelPrice, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FuelPrice&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.basePricePerLiter, basePricePerLiter) || other.basePricePerLiter == basePricePerLiter));
}


@override
int get hashCode => Object.hash(runtimeType,fuelType,basePricePerLiter);

@override
String toString() {
  return 'FuelPrice(fuelType: $fuelType, basePricePerLiter: $basePricePerLiter)';
}


}

/// @nodoc
abstract mixin class $FuelPriceCopyWith<$Res>  {
  factory $FuelPriceCopyWith(FuelPrice value, $Res Function(FuelPrice) _then) = _$FuelPriceCopyWithImpl;
@useResult
$Res call({
 FuelType fuelType, double basePricePerLiter
});




}
/// @nodoc
class _$FuelPriceCopyWithImpl<$Res>
    implements $FuelPriceCopyWith<$Res> {
  _$FuelPriceCopyWithImpl(this._self, this._then);

  final FuelPrice _self;
  final $Res Function(FuelPrice) _then;

/// Create a copy of FuelPrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fuelType = null,Object? basePricePerLiter = null,}) {
  return _then(_self.copyWith(
fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,basePricePerLiter: null == basePricePerLiter ? _self.basePricePerLiter : basePricePerLiter // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FuelPrice].
extension FuelPricePatterns on FuelPrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FuelPrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FuelPrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FuelPrice value)  $default,){
final _that = this;
switch (_that) {
case _FuelPrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FuelPrice value)?  $default,){
final _that = this;
switch (_that) {
case _FuelPrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FuelType fuelType,  double basePricePerLiter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FuelPrice() when $default != null:
return $default(_that.fuelType,_that.basePricePerLiter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FuelType fuelType,  double basePricePerLiter)  $default,) {final _that = this;
switch (_that) {
case _FuelPrice():
return $default(_that.fuelType,_that.basePricePerLiter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FuelType fuelType,  double basePricePerLiter)?  $default,) {final _that = this;
switch (_that) {
case _FuelPrice() when $default != null:
return $default(_that.fuelType,_that.basePricePerLiter);case _:
  return null;

}
}

}

/// @nodoc


class _FuelPrice implements FuelPrice {
  const _FuelPrice({required this.fuelType, required this.basePricePerLiter});
  

@override final  FuelType fuelType;
@override final  double basePricePerLiter;

/// Create a copy of FuelPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FuelPriceCopyWith<_FuelPrice> get copyWith => __$FuelPriceCopyWithImpl<_FuelPrice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FuelPrice&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.basePricePerLiter, basePricePerLiter) || other.basePricePerLiter == basePricePerLiter));
}


@override
int get hashCode => Object.hash(runtimeType,fuelType,basePricePerLiter);

@override
String toString() {
  return 'FuelPrice(fuelType: $fuelType, basePricePerLiter: $basePricePerLiter)';
}


}

/// @nodoc
abstract mixin class _$FuelPriceCopyWith<$Res> implements $FuelPriceCopyWith<$Res> {
  factory _$FuelPriceCopyWith(_FuelPrice value, $Res Function(_FuelPrice) _then) = __$FuelPriceCopyWithImpl;
@override @useResult
$Res call({
 FuelType fuelType, double basePricePerLiter
});




}
/// @nodoc
class __$FuelPriceCopyWithImpl<$Res>
    implements _$FuelPriceCopyWith<$Res> {
  __$FuelPriceCopyWithImpl(this._self, this._then);

  final _FuelPrice _self;
  final $Res Function(_FuelPrice) _then;

/// Create a copy of FuelPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fuelType = null,Object? basePricePerLiter = null,}) {
  return _then(_FuelPrice(
fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,basePricePerLiter: null == basePricePerLiter ? _self.basePricePerLiter : basePricePerLiter // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$PricingConfig {

 double get deliveryFee; double get serviceFeePercent; double get taxRatePercent; List<int> get tankerCapacitiesLiters;
/// Create a copy of PricingConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PricingConfigCopyWith<PricingConfig> get copyWith => _$PricingConfigCopyWithImpl<PricingConfig>(this as PricingConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PricingConfig&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.serviceFeePercent, serviceFeePercent) || other.serviceFeePercent == serviceFeePercent)&&(identical(other.taxRatePercent, taxRatePercent) || other.taxRatePercent == taxRatePercent)&&const DeepCollectionEquality().equals(other.tankerCapacitiesLiters, tankerCapacitiesLiters));
}


@override
int get hashCode => Object.hash(runtimeType,deliveryFee,serviceFeePercent,taxRatePercent,const DeepCollectionEquality().hash(tankerCapacitiesLiters));

@override
String toString() {
  return 'PricingConfig(deliveryFee: $deliveryFee, serviceFeePercent: $serviceFeePercent, taxRatePercent: $taxRatePercent, tankerCapacitiesLiters: $tankerCapacitiesLiters)';
}


}

/// @nodoc
abstract mixin class $PricingConfigCopyWith<$Res>  {
  factory $PricingConfigCopyWith(PricingConfig value, $Res Function(PricingConfig) _then) = _$PricingConfigCopyWithImpl;
@useResult
$Res call({
 double deliveryFee, double serviceFeePercent, double taxRatePercent, List<int> tankerCapacitiesLiters
});




}
/// @nodoc
class _$PricingConfigCopyWithImpl<$Res>
    implements $PricingConfigCopyWith<$Res> {
  _$PricingConfigCopyWithImpl(this._self, this._then);

  final PricingConfig _self;
  final $Res Function(PricingConfig) _then;

/// Create a copy of PricingConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deliveryFee = null,Object? serviceFeePercent = null,Object? taxRatePercent = null,Object? tankerCapacitiesLiters = null,}) {
  return _then(_self.copyWith(
deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,serviceFeePercent: null == serviceFeePercent ? _self.serviceFeePercent : serviceFeePercent // ignore: cast_nullable_to_non_nullable
as double,taxRatePercent: null == taxRatePercent ? _self.taxRatePercent : taxRatePercent // ignore: cast_nullable_to_non_nullable
as double,tankerCapacitiesLiters: null == tankerCapacitiesLiters ? _self.tankerCapacitiesLiters : tankerCapacitiesLiters // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [PricingConfig].
extension PricingConfigPatterns on PricingConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PricingConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PricingConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PricingConfig value)  $default,){
final _that = this;
switch (_that) {
case _PricingConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PricingConfig value)?  $default,){
final _that = this;
switch (_that) {
case _PricingConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double deliveryFee,  double serviceFeePercent,  double taxRatePercent,  List<int> tankerCapacitiesLiters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PricingConfig() when $default != null:
return $default(_that.deliveryFee,_that.serviceFeePercent,_that.taxRatePercent,_that.tankerCapacitiesLiters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double deliveryFee,  double serviceFeePercent,  double taxRatePercent,  List<int> tankerCapacitiesLiters)  $default,) {final _that = this;
switch (_that) {
case _PricingConfig():
return $default(_that.deliveryFee,_that.serviceFeePercent,_that.taxRatePercent,_that.tankerCapacitiesLiters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double deliveryFee,  double serviceFeePercent,  double taxRatePercent,  List<int> tankerCapacitiesLiters)?  $default,) {final _that = this;
switch (_that) {
case _PricingConfig() when $default != null:
return $default(_that.deliveryFee,_that.serviceFeePercent,_that.taxRatePercent,_that.tankerCapacitiesLiters);case _:
  return null;

}
}

}

/// @nodoc


class _PricingConfig implements PricingConfig {
  const _PricingConfig({required this.deliveryFee, required this.serviceFeePercent, required this.taxRatePercent, required final  List<int> tankerCapacitiesLiters}): _tankerCapacitiesLiters = tankerCapacitiesLiters;
  

@override final  double deliveryFee;
@override final  double serviceFeePercent;
@override final  double taxRatePercent;
 final  List<int> _tankerCapacitiesLiters;
@override List<int> get tankerCapacitiesLiters {
  if (_tankerCapacitiesLiters is EqualUnmodifiableListView) return _tankerCapacitiesLiters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tankerCapacitiesLiters);
}


/// Create a copy of PricingConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PricingConfigCopyWith<_PricingConfig> get copyWith => __$PricingConfigCopyWithImpl<_PricingConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PricingConfig&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.serviceFeePercent, serviceFeePercent) || other.serviceFeePercent == serviceFeePercent)&&(identical(other.taxRatePercent, taxRatePercent) || other.taxRatePercent == taxRatePercent)&&const DeepCollectionEquality().equals(other._tankerCapacitiesLiters, _tankerCapacitiesLiters));
}


@override
int get hashCode => Object.hash(runtimeType,deliveryFee,serviceFeePercent,taxRatePercent,const DeepCollectionEquality().hash(_tankerCapacitiesLiters));

@override
String toString() {
  return 'PricingConfig(deliveryFee: $deliveryFee, serviceFeePercent: $serviceFeePercent, taxRatePercent: $taxRatePercent, tankerCapacitiesLiters: $tankerCapacitiesLiters)';
}


}

/// @nodoc
abstract mixin class _$PricingConfigCopyWith<$Res> implements $PricingConfigCopyWith<$Res> {
  factory _$PricingConfigCopyWith(_PricingConfig value, $Res Function(_PricingConfig) _then) = __$PricingConfigCopyWithImpl;
@override @useResult
$Res call({
 double deliveryFee, double serviceFeePercent, double taxRatePercent, List<int> tankerCapacitiesLiters
});




}
/// @nodoc
class __$PricingConfigCopyWithImpl<$Res>
    implements _$PricingConfigCopyWith<$Res> {
  __$PricingConfigCopyWithImpl(this._self, this._then);

  final _PricingConfig _self;
  final $Res Function(_PricingConfig) _then;

/// Create a copy of PricingConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deliveryFee = null,Object? serviceFeePercent = null,Object? taxRatePercent = null,Object? tankerCapacitiesLiters = null,}) {
  return _then(_PricingConfig(
deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,serviceFeePercent: null == serviceFeePercent ? _self.serviceFeePercent : serviceFeePercent // ignore: cast_nullable_to_non_nullable
as double,taxRatePercent: null == taxRatePercent ? _self.taxRatePercent : taxRatePercent // ignore: cast_nullable_to_non_nullable
as double,tankerCapacitiesLiters: null == tankerCapacitiesLiters ? _self._tankerCapacitiesLiters : tankerCapacitiesLiters // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
