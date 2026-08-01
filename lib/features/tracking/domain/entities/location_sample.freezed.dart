// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_sample.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationSample {

 double get lat; double get lng; DateTime get recordedAt; DateTime? get receivedAt;
/// Create a copy of LocationSample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationSampleCopyWith<LocationSample> get copyWith => _$LocationSampleCopyWithImpl<LocationSample>(this as LocationSample, _$identity);

  /// Serializes this LocationSample to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationSample&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,recordedAt,receivedAt);

@override
String toString() {
  return 'LocationSample(lat: $lat, lng: $lng, recordedAt: $recordedAt, receivedAt: $receivedAt)';
}


}

/// @nodoc
abstract mixin class $LocationSampleCopyWith<$Res>  {
  factory $LocationSampleCopyWith(LocationSample value, $Res Function(LocationSample) _then) = _$LocationSampleCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, DateTime recordedAt, DateTime? receivedAt
});




}
/// @nodoc
class _$LocationSampleCopyWithImpl<$Res>
    implements $LocationSampleCopyWith<$Res> {
  _$LocationSampleCopyWithImpl(this._self, this._then);

  final LocationSample _self;
  final $Res Function(LocationSample) _then;

/// Create a copy of LocationSample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? recordedAt = null,Object? receivedAt = freezed,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationSample].
extension LocationSamplePatterns on LocationSample {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationSample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationSample() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationSample value)  $default,){
final _that = this;
switch (_that) {
case _LocationSample():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationSample value)?  $default,){
final _that = this;
switch (_that) {
case _LocationSample() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  DateTime recordedAt,  DateTime? receivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationSample() when $default != null:
return $default(_that.lat,_that.lng,_that.recordedAt,_that.receivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  DateTime recordedAt,  DateTime? receivedAt)  $default,) {final _that = this;
switch (_that) {
case _LocationSample():
return $default(_that.lat,_that.lng,_that.recordedAt,_that.receivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  DateTime recordedAt,  DateTime? receivedAt)?  $default,) {final _that = this;
switch (_that) {
case _LocationSample() when $default != null:
return $default(_that.lat,_that.lng,_that.recordedAt,_that.receivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocationSample extends LocationSample {
  const _LocationSample({required this.lat, required this.lng, required this.recordedAt, this.receivedAt}): super._();
  factory _LocationSample.fromJson(Map<String, dynamic> json) => _$LocationSampleFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  DateTime recordedAt;
@override final  DateTime? receivedAt;

/// Create a copy of LocationSample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationSampleCopyWith<_LocationSample> get copyWith => __$LocationSampleCopyWithImpl<_LocationSample>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationSampleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationSample&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,recordedAt,receivedAt);

@override
String toString() {
  return 'LocationSample(lat: $lat, lng: $lng, recordedAt: $recordedAt, receivedAt: $receivedAt)';
}


}

/// @nodoc
abstract mixin class _$LocationSampleCopyWith<$Res> implements $LocationSampleCopyWith<$Res> {
  factory _$LocationSampleCopyWith(_LocationSample value, $Res Function(_LocationSample) _then) = __$LocationSampleCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, DateTime recordedAt, DateTime? receivedAt
});




}
/// @nodoc
class __$LocationSampleCopyWithImpl<$Res>
    implements _$LocationSampleCopyWith<$Res> {
  __$LocationSampleCopyWithImpl(this._self, this._then);

  final _LocationSample _self;
  final $Res Function(_LocationSample) _then;

/// Create a copy of LocationSample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? recordedAt = null,Object? receivedAt = freezed,}) {
  return _then(_LocationSample(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
