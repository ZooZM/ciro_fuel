// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_standing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriverStanding {

 double? get ratingAverage; int get ratingCount; int get deliveriesToday; bool get readyForWork;
/// Create a copy of DriverStanding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverStandingCopyWith<DriverStanding> get copyWith => _$DriverStandingCopyWithImpl<DriverStanding>(this as DriverStanding, _$identity);

  /// Serializes this DriverStanding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverStanding&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.deliveriesToday, deliveriesToday) || other.deliveriesToday == deliveriesToday)&&(identical(other.readyForWork, readyForWork) || other.readyForWork == readyForWork));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ratingAverage,ratingCount,deliveriesToday,readyForWork);

@override
String toString() {
  return 'DriverStanding(ratingAverage: $ratingAverage, ratingCount: $ratingCount, deliveriesToday: $deliveriesToday, readyForWork: $readyForWork)';
}


}

/// @nodoc
abstract mixin class $DriverStandingCopyWith<$Res>  {
  factory $DriverStandingCopyWith(DriverStanding value, $Res Function(DriverStanding) _then) = _$DriverStandingCopyWithImpl;
@useResult
$Res call({
 double? ratingAverage, int ratingCount, int deliveriesToday, bool readyForWork
});




}
/// @nodoc
class _$DriverStandingCopyWithImpl<$Res>
    implements $DriverStandingCopyWith<$Res> {
  _$DriverStandingCopyWithImpl(this._self, this._then);

  final DriverStanding _self;
  final $Res Function(DriverStanding) _then;

/// Create a copy of DriverStanding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ratingAverage = freezed,Object? ratingCount = null,Object? deliveriesToday = null,Object? readyForWork = null,}) {
  return _then(_self.copyWith(
ratingAverage: freezed == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,deliveriesToday: null == deliveriesToday ? _self.deliveriesToday : deliveriesToday // ignore: cast_nullable_to_non_nullable
as int,readyForWork: null == readyForWork ? _self.readyForWork : readyForWork // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverStanding].
extension DriverStandingPatterns on DriverStanding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverStanding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverStanding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverStanding value)  $default,){
final _that = this;
switch (_that) {
case _DriverStanding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverStanding value)?  $default,){
final _that = this;
switch (_that) {
case _DriverStanding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? ratingAverage,  int ratingCount,  int deliveriesToday,  bool readyForWork)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverStanding() when $default != null:
return $default(_that.ratingAverage,_that.ratingCount,_that.deliveriesToday,_that.readyForWork);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? ratingAverage,  int ratingCount,  int deliveriesToday,  bool readyForWork)  $default,) {final _that = this;
switch (_that) {
case _DriverStanding():
return $default(_that.ratingAverage,_that.ratingCount,_that.deliveriesToday,_that.readyForWork);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? ratingAverage,  int ratingCount,  int deliveriesToday,  bool readyForWork)?  $default,) {final _that = this;
switch (_that) {
case _DriverStanding() when $default != null:
return $default(_that.ratingAverage,_that.ratingCount,_that.deliveriesToday,_that.readyForWork);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriverStanding implements DriverStanding {
  const _DriverStanding({this.ratingAverage, required this.ratingCount, required this.deliveriesToday, required this.readyForWork});
  factory _DriverStanding.fromJson(Map<String, dynamic> json) => _$DriverStandingFromJson(json);

@override final  double? ratingAverage;
@override final  int ratingCount;
@override final  int deliveriesToday;
@override final  bool readyForWork;

/// Create a copy of DriverStanding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverStandingCopyWith<_DriverStanding> get copyWith => __$DriverStandingCopyWithImpl<_DriverStanding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriverStandingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverStanding&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.deliveriesToday, deliveriesToday) || other.deliveriesToday == deliveriesToday)&&(identical(other.readyForWork, readyForWork) || other.readyForWork == readyForWork));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ratingAverage,ratingCount,deliveriesToday,readyForWork);

@override
String toString() {
  return 'DriverStanding(ratingAverage: $ratingAverage, ratingCount: $ratingCount, deliveriesToday: $deliveriesToday, readyForWork: $readyForWork)';
}


}

/// @nodoc
abstract mixin class _$DriverStandingCopyWith<$Res> implements $DriverStandingCopyWith<$Res> {
  factory _$DriverStandingCopyWith(_DriverStanding value, $Res Function(_DriverStanding) _then) = __$DriverStandingCopyWithImpl;
@override @useResult
$Res call({
 double? ratingAverage, int ratingCount, int deliveriesToday, bool readyForWork
});




}
/// @nodoc
class __$DriverStandingCopyWithImpl<$Res>
    implements _$DriverStandingCopyWith<$Res> {
  __$DriverStandingCopyWithImpl(this._self, this._then);

  final _DriverStanding _self;
  final $Res Function(_DriverStanding) _then;

/// Create a copy of DriverStanding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ratingAverage = freezed,Object? ratingCount = null,Object? deliveriesToday = null,Object? readyForWork = null,}) {
  return _then(_DriverStanding(
ratingAverage: freezed == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,deliveriesToday: null == deliveriesToday ? _self.deliveriesToday : deliveriesToday // ignore: cast_nullable_to_non_nullable
as int,readyForWork: null == readyForWork ? _self.readyForWork : readyForWork // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
