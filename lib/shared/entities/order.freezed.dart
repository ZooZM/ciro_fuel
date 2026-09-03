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
mixin _$ClientSummary {

 String get fullName; String get phone;
/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientSummaryCopyWith<ClientSummary> get copyWith => _$ClientSummaryCopyWithImpl<ClientSummary>(this as ClientSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientSummary&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,fullName,phone);

@override
String toString() {
  return 'ClientSummary(fullName: $fullName, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $ClientSummaryCopyWith<$Res>  {
  factory $ClientSummaryCopyWith(ClientSummary value, $Res Function(ClientSummary) _then) = _$ClientSummaryCopyWithImpl;
@useResult
$Res call({
 String fullName, String phone
});




}
/// @nodoc
class _$ClientSummaryCopyWithImpl<$Res>
    implements $ClientSummaryCopyWith<$Res> {
  _$ClientSummaryCopyWithImpl(this._self, this._then);

  final ClientSummary _self;
  final $Res Function(ClientSummary) _then;

/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? phone = null,}) {
  return _then(_self.copyWith(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientSummary].
extension ClientSummaryPatterns on ClientSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientSummary value)  $default,){
final _that = this;
switch (_that) {
case _ClientSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName,  String phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
return $default(_that.fullName,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName,  String phone)  $default,) {final _that = this;
switch (_that) {
case _ClientSummary():
return $default(_that.fullName,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName,  String phone)?  $default,) {final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
return $default(_that.fullName,_that.phone);case _:
  return null;

}
}

}

/// @nodoc


class _ClientSummary implements ClientSummary {
  const _ClientSummary({required this.fullName, required this.phone});
  

@override final  String fullName;
@override final  String phone;

/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientSummaryCopyWith<_ClientSummary> get copyWith => __$ClientSummaryCopyWithImpl<_ClientSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientSummary&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,fullName,phone);

@override
String toString() {
  return 'ClientSummary(fullName: $fullName, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$ClientSummaryCopyWith<$Res> implements $ClientSummaryCopyWith<$Res> {
  factory _$ClientSummaryCopyWith(_ClientSummary value, $Res Function(_ClientSummary) _then) = __$ClientSummaryCopyWithImpl;
@override @useResult
$Res call({
 String fullName, String phone
});




}
/// @nodoc
class __$ClientSummaryCopyWithImpl<$Res>
    implements _$ClientSummaryCopyWith<$Res> {
  __$ClientSummaryCopyWithImpl(this._self, this._then);

  final _ClientSummary _self;
  final $Res Function(_ClientSummary) _then;

/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? phone = null,}) {
  return _then(_ClientSummary(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$OrderRating {

 int get score; String? get review;
/// Create a copy of OrderRating
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderRatingCopyWith<OrderRating> get copyWith => _$OrderRatingCopyWithImpl<OrderRating>(this as OrderRating, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderRating&&(identical(other.score, score) || other.score == score)&&(identical(other.review, review) || other.review == review));
}


@override
int get hashCode => Object.hash(runtimeType,score,review);

@override
String toString() {
  return 'OrderRating(score: $score, review: $review)';
}


}

/// @nodoc
abstract mixin class $OrderRatingCopyWith<$Res>  {
  factory $OrderRatingCopyWith(OrderRating value, $Res Function(OrderRating) _then) = _$OrderRatingCopyWithImpl;
@useResult
$Res call({
 int score, String? review
});




}
/// @nodoc
class _$OrderRatingCopyWithImpl<$Res>
    implements $OrderRatingCopyWith<$Res> {
  _$OrderRatingCopyWithImpl(this._self, this._then);

  final OrderRating _self;
  final $Res Function(OrderRating) _then;

/// Create a copy of OrderRating
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? review = freezed,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderRating].
extension OrderRatingPatterns on OrderRating {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderRating value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderRating() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderRating value)  $default,){
final _that = this;
switch (_that) {
case _OrderRating():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderRating value)?  $default,){
final _that = this;
switch (_that) {
case _OrderRating() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int score,  String? review)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderRating() when $default != null:
return $default(_that.score,_that.review);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int score,  String? review)  $default,) {final _that = this;
switch (_that) {
case _OrderRating():
return $default(_that.score,_that.review);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int score,  String? review)?  $default,) {final _that = this;
switch (_that) {
case _OrderRating() when $default != null:
return $default(_that.score,_that.review);case _:
  return null;

}
}

}

/// @nodoc


class _OrderRating implements OrderRating {
  const _OrderRating({required this.score, this.review});
  

@override final  int score;
@override final  String? review;

/// Create a copy of OrderRating
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderRatingCopyWith<_OrderRating> get copyWith => __$OrderRatingCopyWithImpl<_OrderRating>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderRating&&(identical(other.score, score) || other.score == score)&&(identical(other.review, review) || other.review == review));
}


@override
int get hashCode => Object.hash(runtimeType,score,review);

@override
String toString() {
  return 'OrderRating(score: $score, review: $review)';
}


}

/// @nodoc
abstract mixin class _$OrderRatingCopyWith<$Res> implements $OrderRatingCopyWith<$Res> {
  factory _$OrderRatingCopyWith(_OrderRating value, $Res Function(_OrderRating) _then) = __$OrderRatingCopyWithImpl;
@override @useResult
$Res call({
 int score, String? review
});




}
/// @nodoc
class __$OrderRatingCopyWithImpl<$Res>
    implements _$OrderRatingCopyWith<$Res> {
  __$OrderRatingCopyWithImpl(this._self, this._then);

  final _OrderRating _self;
  final $Res Function(_OrderRating) _then;

/// Create a copy of OrderRating
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? review = freezed,}) {
  return _then(_OrderRating(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$TankSummary {

 String get code; TankMaterial get material;
/// Create a copy of TankSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TankSummaryCopyWith<TankSummary> get copyWith => _$TankSummaryCopyWithImpl<TankSummary>(this as TankSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TankSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.material, material) || other.material == material));
}


@override
int get hashCode => Object.hash(runtimeType,code,material);

@override
String toString() {
  return 'TankSummary(code: $code, material: $material)';
}


}

/// @nodoc
abstract mixin class $TankSummaryCopyWith<$Res>  {
  factory $TankSummaryCopyWith(TankSummary value, $Res Function(TankSummary) _then) = _$TankSummaryCopyWithImpl;
@useResult
$Res call({
 String code, TankMaterial material
});




}
/// @nodoc
class _$TankSummaryCopyWithImpl<$Res>
    implements $TankSummaryCopyWith<$Res> {
  _$TankSummaryCopyWithImpl(this._self, this._then);

  final TankSummary _self;
  final $Res Function(TankSummary) _then;

/// Create a copy of TankSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? material = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as TankMaterial,
  ));
}

}


/// Adds pattern-matching-related methods to [TankSummary].
extension TankSummaryPatterns on TankSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TankSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TankSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TankSummary value)  $default,){
final _that = this;
switch (_that) {
case _TankSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TankSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TankSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  TankMaterial material)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TankSummary() when $default != null:
return $default(_that.code,_that.material);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  TankMaterial material)  $default,) {final _that = this;
switch (_that) {
case _TankSummary():
return $default(_that.code,_that.material);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  TankMaterial material)?  $default,) {final _that = this;
switch (_that) {
case _TankSummary() when $default != null:
return $default(_that.code,_that.material);case _:
  return null;

}
}

}

/// @nodoc


class _TankSummary implements TankSummary {
  const _TankSummary({required this.code, required this.material});
  

@override final  String code;
@override final  TankMaterial material;

/// Create a copy of TankSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TankSummaryCopyWith<_TankSummary> get copyWith => __$TankSummaryCopyWithImpl<_TankSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TankSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.material, material) || other.material == material));
}


@override
int get hashCode => Object.hash(runtimeType,code,material);

@override
String toString() {
  return 'TankSummary(code: $code, material: $material)';
}


}

/// @nodoc
abstract mixin class _$TankSummaryCopyWith<$Res> implements $TankSummaryCopyWith<$Res> {
  factory _$TankSummaryCopyWith(_TankSummary value, $Res Function(_TankSummary) _then) = __$TankSummaryCopyWithImpl;
@override @useResult
$Res call({
 String code, TankMaterial material
});




}
/// @nodoc
class __$TankSummaryCopyWithImpl<$Res>
    implements _$TankSummaryCopyWith<$Res> {
  __$TankSummaryCopyWithImpl(this._self, this._then);

  final _TankSummary _self;
  final $Res Function(_TankSummary) _then;

/// Create a copy of TankSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? material = null,}) {
  return _then(_TankSummary(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as TankMaterial,
  ));
}


}

/// @nodoc
mixin _$WarehouseSummary {

 String get name; String get addressText; GeoPoint get location;
/// Create a copy of WarehouseSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<WarehouseSummary> get copyWith => _$WarehouseSummaryCopyWithImpl<WarehouseSummary>(this as WarehouseSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WarehouseSummary&&(identical(other.name, name) || other.name == name)&&(identical(other.addressText, addressText) || other.addressText == addressText)&&(identical(other.location, location) || other.location == location));
}


@override
int get hashCode => Object.hash(runtimeType,name,addressText,location);

@override
String toString() {
  return 'WarehouseSummary(name: $name, addressText: $addressText, location: $location)';
}


}

/// @nodoc
abstract mixin class $WarehouseSummaryCopyWith<$Res>  {
  factory $WarehouseSummaryCopyWith(WarehouseSummary value, $Res Function(WarehouseSummary) _then) = _$WarehouseSummaryCopyWithImpl;
@useResult
$Res call({
 String name, String addressText, GeoPoint location
});


$GeoPointCopyWith<$Res> get location;

}
/// @nodoc
class _$WarehouseSummaryCopyWithImpl<$Res>
    implements $WarehouseSummaryCopyWith<$Res> {
  _$WarehouseSummaryCopyWithImpl(this._self, this._then);

  final WarehouseSummary _self;
  final $Res Function(WarehouseSummary) _then;

/// Create a copy of WarehouseSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? addressText = null,Object? location = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,addressText: null == addressText ? _self.addressText : addressText // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,
  ));
}
/// Create a copy of WarehouseSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get location {
  
  return $GeoPointCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [WarehouseSummary].
extension WarehouseSummaryPatterns on WarehouseSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WarehouseSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WarehouseSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WarehouseSummary value)  $default,){
final _that = this;
switch (_that) {
case _WarehouseSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WarehouseSummary value)?  $default,){
final _that = this;
switch (_that) {
case _WarehouseSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String addressText,  GeoPoint location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WarehouseSummary() when $default != null:
return $default(_that.name,_that.addressText,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String addressText,  GeoPoint location)  $default,) {final _that = this;
switch (_that) {
case _WarehouseSummary():
return $default(_that.name,_that.addressText,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String addressText,  GeoPoint location)?  $default,) {final _that = this;
switch (_that) {
case _WarehouseSummary() when $default != null:
return $default(_that.name,_that.addressText,_that.location);case _:
  return null;

}
}

}

/// @nodoc


class _WarehouseSummary implements WarehouseSummary {
  const _WarehouseSummary({required this.name, required this.addressText, required this.location});
  

@override final  String name;
@override final  String addressText;
@override final  GeoPoint location;

/// Create a copy of WarehouseSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WarehouseSummaryCopyWith<_WarehouseSummary> get copyWith => __$WarehouseSummaryCopyWithImpl<_WarehouseSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WarehouseSummary&&(identical(other.name, name) || other.name == name)&&(identical(other.addressText, addressText) || other.addressText == addressText)&&(identical(other.location, location) || other.location == location));
}


@override
int get hashCode => Object.hash(runtimeType,name,addressText,location);

@override
String toString() {
  return 'WarehouseSummary(name: $name, addressText: $addressText, location: $location)';
}


}

/// @nodoc
abstract mixin class _$WarehouseSummaryCopyWith<$Res> implements $WarehouseSummaryCopyWith<$Res> {
  factory _$WarehouseSummaryCopyWith(_WarehouseSummary value, $Res Function(_WarehouseSummary) _then) = __$WarehouseSummaryCopyWithImpl;
@override @useResult
$Res call({
 String name, String addressText, GeoPoint location
});


@override $GeoPointCopyWith<$Res> get location;

}
/// @nodoc
class __$WarehouseSummaryCopyWithImpl<$Res>
    implements _$WarehouseSummaryCopyWith<$Res> {
  __$WarehouseSummaryCopyWithImpl(this._self, this._then);

  final _WarehouseSummary _self;
  final $Res Function(_WarehouseSummary) _then;

/// Create a copy of WarehouseSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? addressText = null,Object? location = null,}) {
  return _then(_WarehouseSummary(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,addressText: null == addressText ? _self.addressText : addressText // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,
  ));
}

/// Create a copy of WarehouseSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get location {
  
  return $GeoPointCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

/// @nodoc
mixin _$Order {

 String get id; OrderStatus get status; FuelType get fuelType; int get quantityLiters; Money? get estimatedPrice; Money? get finalPrice; PaymentMethod? get paymentMethod; String? get invoiceId;// Set once the invoice is issued at approval and unset on settlement —
// absent for DEFERRED/CREDIT orders, which never gate on payment.
 DateTime? get paymentDeadline; String? get driverId; DriverSummary? get driverSummary; ClientSummary? get clientSummary;// spec 004 FR-029: derived live from the driver's last known position —
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
 PriceBreakdown? get priceBreakdown;// spec 007 FR-037d/FR-041: absent until the customer rates this
// delivery — never a zero or an empty star row in that case (FR-041a).
 OrderRating? get rating;// spec 008: absent pre-cutover and before assignment (research R12).
 String? get truckId;// Driver/operator-facing only — never present on the customer's own
// read of this order (backend FR-042/T130).
 TankSummary? get tankSummary; WarehouseSummary? get warehouseSummary;// Set once loading is confirmed (normal flow or override) — absent
// before then.
 DateTime? get loadingConfirmedAt;// spec 010 FR-010: set once this driver has explicitly acknowledged
// the assignment (`AcknowledgeAssignment`) — absent until then, which
// is exactly the signal `DeliveryCubit.load` checks before firing that
// call, so it fires at most once per assignment.
 DateTime? get assignmentAcknowledgedAt;// FR-047d: false for an overridden departure, since an override
// deliberately writes no verification record — read this, never
// `driverSummary`'s mere presence, before ever presenting the vehicle
// as "verified" to a customer.
 bool get vehicleVerified;// spec 011 / feature 013 US1: the delivery's stop events, as the
// platform holds them. Returned to a DRIVER by `GET /orders/:id`;
// `toRoleScopedShape` strips the key entirely for a CLIENT — so the
// empty default is load-bearing, not tidiness: both personas share this
// one entity and one parsing path, and a non-nullable field with no
// default would make every client order fail to parse (FR-042).
 List<StopEvent> get stopEvents;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.paymentDeadline, paymentDeadline) || other.paymentDeadline == paymentDeadline)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.driverSummary, driverSummary) || other.driverSummary == driverSummary)&&(identical(other.clientSummary, clientSummary) || other.clientSummary == clientSummary)&&(identical(other.etaMinutes, etaMinutes) || other.etaMinutes == etaMinutes)&&(identical(other.driverLocation, driverLocation) || other.driverLocation == driverLocation)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.deliveryAddressText, deliveryAddressText) || other.deliveryAddressText == deliveryAddressText)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.stationAddressText, stationAddressText) || other.stationAddressText == stationAddressText)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt)&&(identical(other.priceBreakdown, priceBreakdown) || other.priceBreakdown == priceBreakdown)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.tankSummary, tankSummary) || other.tankSummary == tankSummary)&&(identical(other.warehouseSummary, warehouseSummary) || other.warehouseSummary == warehouseSummary)&&(identical(other.loadingConfirmedAt, loadingConfirmedAt) || other.loadingConfirmedAt == loadingConfirmedAt)&&(identical(other.assignmentAcknowledgedAt, assignmentAcknowledgedAt) || other.assignmentAcknowledgedAt == assignmentAcknowledgedAt)&&(identical(other.vehicleVerified, vehicleVerified) || other.vehicleVerified == vehicleVerified)&&const DeepCollectionEquality().equals(other.stopEvents, stopEvents));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,status,fuelType,quantityLiters,estimatedPrice,finalPrice,paymentMethod,invoiceId,paymentDeadline,driverId,driverSummary,clientSummary,etaMinutes,driverLocation,destination,deliveryAddressText,stationName,stationAddressText,statusChangedAt,priceBreakdown,rating,truckId,tankSummary,warehouseSummary,loadingConfirmedAt,assignmentAcknowledgedAt,vehicleVerified,const DeepCollectionEquality().hash(stopEvents)]);

@override
String toString() {
  return 'Order(id: $id, status: $status, fuelType: $fuelType, quantityLiters: $quantityLiters, estimatedPrice: $estimatedPrice, finalPrice: $finalPrice, paymentMethod: $paymentMethod, invoiceId: $invoiceId, paymentDeadline: $paymentDeadline, driverId: $driverId, driverSummary: $driverSummary, clientSummary: $clientSummary, etaMinutes: $etaMinutes, driverLocation: $driverLocation, destination: $destination, deliveryAddressText: $deliveryAddressText, stationName: $stationName, stationAddressText: $stationAddressText, statusChangedAt: $statusChangedAt, priceBreakdown: $priceBreakdown, rating: $rating, truckId: $truckId, tankSummary: $tankSummary, warehouseSummary: $warehouseSummary, loadingConfirmedAt: $loadingConfirmedAt, assignmentAcknowledgedAt: $assignmentAcknowledgedAt, vehicleVerified: $vehicleVerified, stopEvents: $stopEvents)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, OrderStatus status, FuelType fuelType, int quantityLiters, Money? estimatedPrice, Money? finalPrice, PaymentMethod? paymentMethod, String? invoiceId, DateTime? paymentDeadline, String? driverId, DriverSummary? driverSummary, ClientSummary? clientSummary, int? etaMinutes, GeoPoint? driverLocation, GeoPoint? destination, String? deliveryAddressText, String? stationName, String? stationAddressText, DateTime statusChangedAt, PriceBreakdown? priceBreakdown, OrderRating? rating, String? truckId, TankSummary? tankSummary, WarehouseSummary? warehouseSummary, DateTime? loadingConfirmedAt, DateTime? assignmentAcknowledgedAt, bool vehicleVerified, List<StopEvent> stopEvents
});


$MoneyCopyWith<$Res>? get estimatedPrice;$MoneyCopyWith<$Res>? get finalPrice;$DriverSummaryCopyWith<$Res>? get driverSummary;$ClientSummaryCopyWith<$Res>? get clientSummary;$GeoPointCopyWith<$Res>? get driverLocation;$GeoPointCopyWith<$Res>? get destination;$PriceBreakdownCopyWith<$Res>? get priceBreakdown;$OrderRatingCopyWith<$Res>? get rating;$TankSummaryCopyWith<$Res>? get tankSummary;$WarehouseSummaryCopyWith<$Res>? get warehouseSummary;

}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? fuelType = null,Object? quantityLiters = null,Object? estimatedPrice = freezed,Object? finalPrice = freezed,Object? paymentMethod = freezed,Object? invoiceId = freezed,Object? paymentDeadline = freezed,Object? driverId = freezed,Object? driverSummary = freezed,Object? clientSummary = freezed,Object? etaMinutes = freezed,Object? driverLocation = freezed,Object? destination = freezed,Object? deliveryAddressText = freezed,Object? stationName = freezed,Object? stationAddressText = freezed,Object? statusChangedAt = null,Object? priceBreakdown = freezed,Object? rating = freezed,Object? truckId = freezed,Object? tankSummary = freezed,Object? warehouseSummary = freezed,Object? loadingConfirmedAt = freezed,Object? assignmentAcknowledgedAt = freezed,Object? vehicleVerified = null,Object? stopEvents = null,}) {
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
as DriverSummary?,clientSummary: freezed == clientSummary ? _self.clientSummary : clientSummary // ignore: cast_nullable_to_non_nullable
as ClientSummary?,etaMinutes: freezed == etaMinutes ? _self.etaMinutes : etaMinutes // ignore: cast_nullable_to_non_nullable
as int?,driverLocation: freezed == driverLocation ? _self.driverLocation : driverLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as GeoPoint?,deliveryAddressText: freezed == deliveryAddressText ? _self.deliveryAddressText : deliveryAddressText // ignore: cast_nullable_to_non_nullable
as String?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,stationAddressText: freezed == stationAddressText ? _self.stationAddressText : stationAddressText // ignore: cast_nullable_to_non_nullable
as String?,statusChangedAt: null == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priceBreakdown: freezed == priceBreakdown ? _self.priceBreakdown : priceBreakdown // ignore: cast_nullable_to_non_nullable
as PriceBreakdown?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as OrderRating?,truckId: freezed == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String?,tankSummary: freezed == tankSummary ? _self.tankSummary : tankSummary // ignore: cast_nullable_to_non_nullable
as TankSummary?,warehouseSummary: freezed == warehouseSummary ? _self.warehouseSummary : warehouseSummary // ignore: cast_nullable_to_non_nullable
as WarehouseSummary?,loadingConfirmedAt: freezed == loadingConfirmedAt ? _self.loadingConfirmedAt : loadingConfirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,assignmentAcknowledgedAt: freezed == assignmentAcknowledgedAt ? _self.assignmentAcknowledgedAt : assignmentAcknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,vehicleVerified: null == vehicleVerified ? _self.vehicleVerified : vehicleVerified // ignore: cast_nullable_to_non_nullable
as bool,stopEvents: null == stopEvents ? _self.stopEvents : stopEvents // ignore: cast_nullable_to_non_nullable
as List<StopEvent>,
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
$ClientSummaryCopyWith<$Res>? get clientSummary {
    if (_self.clientSummary == null) {
    return null;
  }

  return $ClientSummaryCopyWith<$Res>(_self.clientSummary!, (value) {
    return _then(_self.copyWith(clientSummary: value));
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
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderRatingCopyWith<$Res>? get rating {
    if (_self.rating == null) {
    return null;
  }

  return $OrderRatingCopyWith<$Res>(_self.rating!, (value) {
    return _then(_self.copyWith(rating: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TankSummaryCopyWith<$Res>? get tankSummary {
    if (_self.tankSummary == null) {
    return null;
  }

  return $TankSummaryCopyWith<$Res>(_self.tankSummary!, (value) {
    return _then(_self.copyWith(tankSummary: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<$Res>? get warehouseSummary {
    if (_self.warehouseSummary == null) {
    return null;
  }

  return $WarehouseSummaryCopyWith<$Res>(_self.warehouseSummary!, (value) {
    return _then(_self.copyWith(warehouseSummary: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  OrderStatus status,  FuelType fuelType,  int quantityLiters,  Money? estimatedPrice,  Money? finalPrice,  PaymentMethod? paymentMethod,  String? invoiceId,  DateTime? paymentDeadline,  String? driverId,  DriverSummary? driverSummary,  ClientSummary? clientSummary,  int? etaMinutes,  GeoPoint? driverLocation,  GeoPoint? destination,  String? deliveryAddressText,  String? stationName,  String? stationAddressText,  DateTime statusChangedAt,  PriceBreakdown? priceBreakdown,  OrderRating? rating,  String? truckId,  TankSummary? tankSummary,  WarehouseSummary? warehouseSummary,  DateTime? loadingConfirmedAt,  DateTime? assignmentAcknowledgedAt,  bool vehicleVerified,  List<StopEvent> stopEvents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.status,_that.fuelType,_that.quantityLiters,_that.estimatedPrice,_that.finalPrice,_that.paymentMethod,_that.invoiceId,_that.paymentDeadline,_that.driverId,_that.driverSummary,_that.clientSummary,_that.etaMinutes,_that.driverLocation,_that.destination,_that.deliveryAddressText,_that.stationName,_that.stationAddressText,_that.statusChangedAt,_that.priceBreakdown,_that.rating,_that.truckId,_that.tankSummary,_that.warehouseSummary,_that.loadingConfirmedAt,_that.assignmentAcknowledgedAt,_that.vehicleVerified,_that.stopEvents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  OrderStatus status,  FuelType fuelType,  int quantityLiters,  Money? estimatedPrice,  Money? finalPrice,  PaymentMethod? paymentMethod,  String? invoiceId,  DateTime? paymentDeadline,  String? driverId,  DriverSummary? driverSummary,  ClientSummary? clientSummary,  int? etaMinutes,  GeoPoint? driverLocation,  GeoPoint? destination,  String? deliveryAddressText,  String? stationName,  String? stationAddressText,  DateTime statusChangedAt,  PriceBreakdown? priceBreakdown,  OrderRating? rating,  String? truckId,  TankSummary? tankSummary,  WarehouseSummary? warehouseSummary,  DateTime? loadingConfirmedAt,  DateTime? assignmentAcknowledgedAt,  bool vehicleVerified,  List<StopEvent> stopEvents)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.status,_that.fuelType,_that.quantityLiters,_that.estimatedPrice,_that.finalPrice,_that.paymentMethod,_that.invoiceId,_that.paymentDeadline,_that.driverId,_that.driverSummary,_that.clientSummary,_that.etaMinutes,_that.driverLocation,_that.destination,_that.deliveryAddressText,_that.stationName,_that.stationAddressText,_that.statusChangedAt,_that.priceBreakdown,_that.rating,_that.truckId,_that.tankSummary,_that.warehouseSummary,_that.loadingConfirmedAt,_that.assignmentAcknowledgedAt,_that.vehicleVerified,_that.stopEvents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  OrderStatus status,  FuelType fuelType,  int quantityLiters,  Money? estimatedPrice,  Money? finalPrice,  PaymentMethod? paymentMethod,  String? invoiceId,  DateTime? paymentDeadline,  String? driverId,  DriverSummary? driverSummary,  ClientSummary? clientSummary,  int? etaMinutes,  GeoPoint? driverLocation,  GeoPoint? destination,  String? deliveryAddressText,  String? stationName,  String? stationAddressText,  DateTime statusChangedAt,  PriceBreakdown? priceBreakdown,  OrderRating? rating,  String? truckId,  TankSummary? tankSummary,  WarehouseSummary? warehouseSummary,  DateTime? loadingConfirmedAt,  DateTime? assignmentAcknowledgedAt,  bool vehicleVerified,  List<StopEvent> stopEvents)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.status,_that.fuelType,_that.quantityLiters,_that.estimatedPrice,_that.finalPrice,_that.paymentMethod,_that.invoiceId,_that.paymentDeadline,_that.driverId,_that.driverSummary,_that.clientSummary,_that.etaMinutes,_that.driverLocation,_that.destination,_that.deliveryAddressText,_that.stationName,_that.stationAddressText,_that.statusChangedAt,_that.priceBreakdown,_that.rating,_that.truckId,_that.tankSummary,_that.warehouseSummary,_that.loadingConfirmedAt,_that.assignmentAcknowledgedAt,_that.vehicleVerified,_that.stopEvents);case _:
  return null;

}
}

}

/// @nodoc


class _Order extends Order {
  const _Order({required this.id, required this.status, required this.fuelType, required this.quantityLiters, this.estimatedPrice, this.finalPrice, this.paymentMethod, this.invoiceId, this.paymentDeadline, this.driverId, this.driverSummary, this.clientSummary, this.etaMinutes, this.driverLocation, this.destination, this.deliveryAddressText, this.stationName, this.stationAddressText, required this.statusChangedAt, this.priceBreakdown, this.rating, this.truckId, this.tankSummary, this.warehouseSummary, this.loadingConfirmedAt, this.assignmentAcknowledgedAt, this.vehicleVerified = false, final  List<StopEvent> stopEvents = const <StopEvent>[]}): _stopEvents = stopEvents,super._();
  

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
@override final  ClientSummary? clientSummary;
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
// spec 007 FR-037d/FR-041: absent until the customer rates this
// delivery — never a zero or an empty star row in that case (FR-041a).
@override final  OrderRating? rating;
// spec 008: absent pre-cutover and before assignment (research R12).
@override final  String? truckId;
// Driver/operator-facing only — never present on the customer's own
// read of this order (backend FR-042/T130).
@override final  TankSummary? tankSummary;
@override final  WarehouseSummary? warehouseSummary;
// Set once loading is confirmed (normal flow or override) — absent
// before then.
@override final  DateTime? loadingConfirmedAt;
// spec 010 FR-010: set once this driver has explicitly acknowledged
// the assignment (`AcknowledgeAssignment`) — absent until then, which
// is exactly the signal `DeliveryCubit.load` checks before firing that
// call, so it fires at most once per assignment.
@override final  DateTime? assignmentAcknowledgedAt;
// FR-047d: false for an overridden departure, since an override
// deliberately writes no verification record — read this, never
// `driverSummary`'s mere presence, before ever presenting the vehicle
// as "verified" to a customer.
@override@JsonKey() final  bool vehicleVerified;
// spec 011 / feature 013 US1: the delivery's stop events, as the
// platform holds them. Returned to a DRIVER by `GET /orders/:id`;
// `toRoleScopedShape` strips the key entirely for a CLIENT — so the
// empty default is load-bearing, not tidiness: both personas share this
// one entity and one parsing path, and a non-nullable field with no
// default would make every client order fail to parse (FR-042).
 final  List<StopEvent> _stopEvents;
// spec 011 / feature 013 US1: the delivery's stop events, as the
// platform holds them. Returned to a DRIVER by `GET /orders/:id`;
// `toRoleScopedShape` strips the key entirely for a CLIENT — so the
// empty default is load-bearing, not tidiness: both personas share this
// one entity and one parsing path, and a non-nullable field with no
// default would make every client order fail to parse (FR-042).
@override@JsonKey() List<StopEvent> get stopEvents {
  if (_stopEvents is EqualUnmodifiableListView) return _stopEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stopEvents);
}


/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.quantityLiters, quantityLiters) || other.quantityLiters == quantityLiters)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.finalPrice, finalPrice) || other.finalPrice == finalPrice)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.paymentDeadline, paymentDeadline) || other.paymentDeadline == paymentDeadline)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.driverSummary, driverSummary) || other.driverSummary == driverSummary)&&(identical(other.clientSummary, clientSummary) || other.clientSummary == clientSummary)&&(identical(other.etaMinutes, etaMinutes) || other.etaMinutes == etaMinutes)&&(identical(other.driverLocation, driverLocation) || other.driverLocation == driverLocation)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.deliveryAddressText, deliveryAddressText) || other.deliveryAddressText == deliveryAddressText)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.stationAddressText, stationAddressText) || other.stationAddressText == stationAddressText)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt)&&(identical(other.priceBreakdown, priceBreakdown) || other.priceBreakdown == priceBreakdown)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.tankSummary, tankSummary) || other.tankSummary == tankSummary)&&(identical(other.warehouseSummary, warehouseSummary) || other.warehouseSummary == warehouseSummary)&&(identical(other.loadingConfirmedAt, loadingConfirmedAt) || other.loadingConfirmedAt == loadingConfirmedAt)&&(identical(other.assignmentAcknowledgedAt, assignmentAcknowledgedAt) || other.assignmentAcknowledgedAt == assignmentAcknowledgedAt)&&(identical(other.vehicleVerified, vehicleVerified) || other.vehicleVerified == vehicleVerified)&&const DeepCollectionEquality().equals(other._stopEvents, _stopEvents));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,status,fuelType,quantityLiters,estimatedPrice,finalPrice,paymentMethod,invoiceId,paymentDeadline,driverId,driverSummary,clientSummary,etaMinutes,driverLocation,destination,deliveryAddressText,stationName,stationAddressText,statusChangedAt,priceBreakdown,rating,truckId,tankSummary,warehouseSummary,loadingConfirmedAt,assignmentAcknowledgedAt,vehicleVerified,const DeepCollectionEquality().hash(_stopEvents)]);

@override
String toString() {
  return 'Order(id: $id, status: $status, fuelType: $fuelType, quantityLiters: $quantityLiters, estimatedPrice: $estimatedPrice, finalPrice: $finalPrice, paymentMethod: $paymentMethod, invoiceId: $invoiceId, paymentDeadline: $paymentDeadline, driverId: $driverId, driverSummary: $driverSummary, clientSummary: $clientSummary, etaMinutes: $etaMinutes, driverLocation: $driverLocation, destination: $destination, deliveryAddressText: $deliveryAddressText, stationName: $stationName, stationAddressText: $stationAddressText, statusChangedAt: $statusChangedAt, priceBreakdown: $priceBreakdown, rating: $rating, truckId: $truckId, tankSummary: $tankSummary, warehouseSummary: $warehouseSummary, loadingConfirmedAt: $loadingConfirmedAt, assignmentAcknowledgedAt: $assignmentAcknowledgedAt, vehicleVerified: $vehicleVerified, stopEvents: $stopEvents)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, OrderStatus status, FuelType fuelType, int quantityLiters, Money? estimatedPrice, Money? finalPrice, PaymentMethod? paymentMethod, String? invoiceId, DateTime? paymentDeadline, String? driverId, DriverSummary? driverSummary, ClientSummary? clientSummary, int? etaMinutes, GeoPoint? driverLocation, GeoPoint? destination, String? deliveryAddressText, String? stationName, String? stationAddressText, DateTime statusChangedAt, PriceBreakdown? priceBreakdown, OrderRating? rating, String? truckId, TankSummary? tankSummary, WarehouseSummary? warehouseSummary, DateTime? loadingConfirmedAt, DateTime? assignmentAcknowledgedAt, bool vehicleVerified, List<StopEvent> stopEvents
});


@override $MoneyCopyWith<$Res>? get estimatedPrice;@override $MoneyCopyWith<$Res>? get finalPrice;@override $DriverSummaryCopyWith<$Res>? get driverSummary;@override $ClientSummaryCopyWith<$Res>? get clientSummary;@override $GeoPointCopyWith<$Res>? get driverLocation;@override $GeoPointCopyWith<$Res>? get destination;@override $PriceBreakdownCopyWith<$Res>? get priceBreakdown;@override $OrderRatingCopyWith<$Res>? get rating;@override $TankSummaryCopyWith<$Res>? get tankSummary;@override $WarehouseSummaryCopyWith<$Res>? get warehouseSummary;

}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? fuelType = null,Object? quantityLiters = null,Object? estimatedPrice = freezed,Object? finalPrice = freezed,Object? paymentMethod = freezed,Object? invoiceId = freezed,Object? paymentDeadline = freezed,Object? driverId = freezed,Object? driverSummary = freezed,Object? clientSummary = freezed,Object? etaMinutes = freezed,Object? driverLocation = freezed,Object? destination = freezed,Object? deliveryAddressText = freezed,Object? stationName = freezed,Object? stationAddressText = freezed,Object? statusChangedAt = null,Object? priceBreakdown = freezed,Object? rating = freezed,Object? truckId = freezed,Object? tankSummary = freezed,Object? warehouseSummary = freezed,Object? loadingConfirmedAt = freezed,Object? assignmentAcknowledgedAt = freezed,Object? vehicleVerified = null,Object? stopEvents = null,}) {
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
as DriverSummary?,clientSummary: freezed == clientSummary ? _self.clientSummary : clientSummary // ignore: cast_nullable_to_non_nullable
as ClientSummary?,etaMinutes: freezed == etaMinutes ? _self.etaMinutes : etaMinutes // ignore: cast_nullable_to_non_nullable
as int?,driverLocation: freezed == driverLocation ? _self.driverLocation : driverLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as GeoPoint?,deliveryAddressText: freezed == deliveryAddressText ? _self.deliveryAddressText : deliveryAddressText // ignore: cast_nullable_to_non_nullable
as String?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,stationAddressText: freezed == stationAddressText ? _self.stationAddressText : stationAddressText // ignore: cast_nullable_to_non_nullable
as String?,statusChangedAt: null == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priceBreakdown: freezed == priceBreakdown ? _self.priceBreakdown : priceBreakdown // ignore: cast_nullable_to_non_nullable
as PriceBreakdown?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as OrderRating?,truckId: freezed == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String?,tankSummary: freezed == tankSummary ? _self.tankSummary : tankSummary // ignore: cast_nullable_to_non_nullable
as TankSummary?,warehouseSummary: freezed == warehouseSummary ? _self.warehouseSummary : warehouseSummary // ignore: cast_nullable_to_non_nullable
as WarehouseSummary?,loadingConfirmedAt: freezed == loadingConfirmedAt ? _self.loadingConfirmedAt : loadingConfirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,assignmentAcknowledgedAt: freezed == assignmentAcknowledgedAt ? _self.assignmentAcknowledgedAt : assignmentAcknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,vehicleVerified: null == vehicleVerified ? _self.vehicleVerified : vehicleVerified // ignore: cast_nullable_to_non_nullable
as bool,stopEvents: null == stopEvents ? _self._stopEvents : stopEvents // ignore: cast_nullable_to_non_nullable
as List<StopEvent>,
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
$ClientSummaryCopyWith<$Res>? get clientSummary {
    if (_self.clientSummary == null) {
    return null;
  }

  return $ClientSummaryCopyWith<$Res>(_self.clientSummary!, (value) {
    return _then(_self.copyWith(clientSummary: value));
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
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderRatingCopyWith<$Res>? get rating {
    if (_self.rating == null) {
    return null;
  }

  return $OrderRatingCopyWith<$Res>(_self.rating!, (value) {
    return _then(_self.copyWith(rating: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TankSummaryCopyWith<$Res>? get tankSummary {
    if (_self.tankSummary == null) {
    return null;
  }

  return $TankSummaryCopyWith<$Res>(_self.tankSummary!, (value) {
    return _then(_self.copyWith(tankSummary: value));
  });
}/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<$Res>? get warehouseSummary {
    if (_self.warehouseSummary == null) {
    return null;
  }

  return $WarehouseSummaryCopyWith<$Res>(_self.warehouseSummary!, (value) {
    return _then(_self.copyWith(warehouseSummary: value));
  });
}
}

// dart format on
