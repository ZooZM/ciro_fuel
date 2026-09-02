// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credit_standing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreditStanding {

 double? get creditLimit; double? get consumed; double? get available;
/// Create a copy of CreditStanding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreditStandingCopyWith<CreditStanding> get copyWith => _$CreditStandingCopyWithImpl<CreditStanding>(this as CreditStanding, _$identity);

  /// Serializes this CreditStanding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditStanding&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit)&&(identical(other.consumed, consumed) || other.consumed == consumed)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,creditLimit,consumed,available);

@override
String toString() {
  return 'CreditStanding(creditLimit: $creditLimit, consumed: $consumed, available: $available)';
}


}

/// @nodoc
abstract mixin class $CreditStandingCopyWith<$Res>  {
  factory $CreditStandingCopyWith(CreditStanding value, $Res Function(CreditStanding) _then) = _$CreditStandingCopyWithImpl;
@useResult
$Res call({
 double? creditLimit, double? consumed, double? available
});




}
/// @nodoc
class _$CreditStandingCopyWithImpl<$Res>
    implements $CreditStandingCopyWith<$Res> {
  _$CreditStandingCopyWithImpl(this._self, this._then);

  final CreditStanding _self;
  final $Res Function(CreditStanding) _then;

/// Create a copy of CreditStanding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? creditLimit = freezed,Object? consumed = freezed,Object? available = freezed,}) {
  return _then(_self.copyWith(
creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as double?,consumed: freezed == consumed ? _self.consumed : consumed // ignore: cast_nullable_to_non_nullable
as double?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreditStanding].
extension CreditStandingPatterns on CreditStanding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreditStanding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreditStanding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreditStanding value)  $default,){
final _that = this;
switch (_that) {
case _CreditStanding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreditStanding value)?  $default,){
final _that = this;
switch (_that) {
case _CreditStanding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? creditLimit,  double? consumed,  double? available)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreditStanding() when $default != null:
return $default(_that.creditLimit,_that.consumed,_that.available);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? creditLimit,  double? consumed,  double? available)  $default,) {final _that = this;
switch (_that) {
case _CreditStanding():
return $default(_that.creditLimit,_that.consumed,_that.available);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? creditLimit,  double? consumed,  double? available)?  $default,) {final _that = this;
switch (_that) {
case _CreditStanding() when $default != null:
return $default(_that.creditLimit,_that.consumed,_that.available);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreditStanding implements CreditStanding {
  const _CreditStanding({this.creditLimit, this.consumed, this.available});
  factory _CreditStanding.fromJson(Map<String, dynamic> json) => _$CreditStandingFromJson(json);

@override final  double? creditLimit;
@override final  double? consumed;
@override final  double? available;

/// Create a copy of CreditStanding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreditStandingCopyWith<_CreditStanding> get copyWith => __$CreditStandingCopyWithImpl<_CreditStanding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreditStandingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreditStanding&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit)&&(identical(other.consumed, consumed) || other.consumed == consumed)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,creditLimit,consumed,available);

@override
String toString() {
  return 'CreditStanding(creditLimit: $creditLimit, consumed: $consumed, available: $available)';
}


}

/// @nodoc
abstract mixin class _$CreditStandingCopyWith<$Res> implements $CreditStandingCopyWith<$Res> {
  factory _$CreditStandingCopyWith(_CreditStanding value, $Res Function(_CreditStanding) _then) = __$CreditStandingCopyWithImpl;
@override @useResult
$Res call({
 double? creditLimit, double? consumed, double? available
});




}
/// @nodoc
class __$CreditStandingCopyWithImpl<$Res>
    implements _$CreditStandingCopyWith<$Res> {
  __$CreditStandingCopyWithImpl(this._self, this._then);

  final _CreditStanding _self;
  final $Res Function(_CreditStanding) _then;

/// Create a copy of CreditStanding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? creditLimit = freezed,Object? consumed = freezed,Object? available = freezed,}) {
  return _then(_CreditStanding(
creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as double?,consumed: freezed == consumed ? _self.consumed : consumed // ignore: cast_nullable_to_non_nullable
as double?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
