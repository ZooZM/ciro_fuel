// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stop_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StopEvent {

/// The stop's own `_id` — retained server-side precisely so a specific
/// stop can be addressed (the reason/resolve endpoints take it).
 String get id; StopOrigin get origin; DateTime get detectedAt; StopReason? get reason; String? get reasonText; DateTime? get reasonGivenAt; DateTime? get suppressedUntil; DateTime? get escalatedAt; DateTime? get resolvedAt;
/// Create a copy of StopEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopEventCopyWith<StopEvent> get copyWith => _$StopEventCopyWithImpl<StopEvent>(this as StopEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.detectedAt, detectedAt) || other.detectedAt == detectedAt)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.reasonText, reasonText) || other.reasonText == reasonText)&&(identical(other.reasonGivenAt, reasonGivenAt) || other.reasonGivenAt == reasonGivenAt)&&(identical(other.suppressedUntil, suppressedUntil) || other.suppressedUntil == suppressedUntil)&&(identical(other.escalatedAt, escalatedAt) || other.escalatedAt == escalatedAt)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,origin,detectedAt,reason,reasonText,reasonGivenAt,suppressedUntil,escalatedAt,resolvedAt);

@override
String toString() {
  return 'StopEvent(id: $id, origin: $origin, detectedAt: $detectedAt, reason: $reason, reasonText: $reasonText, reasonGivenAt: $reasonGivenAt, suppressedUntil: $suppressedUntil, escalatedAt: $escalatedAt, resolvedAt: $resolvedAt)';
}


}

/// @nodoc
abstract mixin class $StopEventCopyWith<$Res>  {
  factory $StopEventCopyWith(StopEvent value, $Res Function(StopEvent) _then) = _$StopEventCopyWithImpl;
@useResult
$Res call({
 String id, StopOrigin origin, DateTime detectedAt, StopReason? reason, String? reasonText, DateTime? reasonGivenAt, DateTime? suppressedUntil, DateTime? escalatedAt, DateTime? resolvedAt
});




}
/// @nodoc
class _$StopEventCopyWithImpl<$Res>
    implements $StopEventCopyWith<$Res> {
  _$StopEventCopyWithImpl(this._self, this._then);

  final StopEvent _self;
  final $Res Function(StopEvent) _then;

/// Create a copy of StopEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? origin = null,Object? detectedAt = null,Object? reason = freezed,Object? reasonText = freezed,Object? reasonGivenAt = freezed,Object? suppressedUntil = freezed,Object? escalatedAt = freezed,Object? resolvedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as StopOrigin,detectedAt: null == detectedAt ? _self.detectedAt : detectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as StopReason?,reasonText: freezed == reasonText ? _self.reasonText : reasonText // ignore: cast_nullable_to_non_nullable
as String?,reasonGivenAt: freezed == reasonGivenAt ? _self.reasonGivenAt : reasonGivenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,suppressedUntil: freezed == suppressedUntil ? _self.suppressedUntil : suppressedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,escalatedAt: freezed == escalatedAt ? _self.escalatedAt : escalatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StopEvent].
extension StopEventPatterns on StopEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StopEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StopEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StopEvent value)  $default,){
final _that = this;
switch (_that) {
case _StopEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StopEvent value)?  $default,){
final _that = this;
switch (_that) {
case _StopEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  StopOrigin origin,  DateTime detectedAt,  StopReason? reason,  String? reasonText,  DateTime? reasonGivenAt,  DateTime? suppressedUntil,  DateTime? escalatedAt,  DateTime? resolvedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StopEvent() when $default != null:
return $default(_that.id,_that.origin,_that.detectedAt,_that.reason,_that.reasonText,_that.reasonGivenAt,_that.suppressedUntil,_that.escalatedAt,_that.resolvedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  StopOrigin origin,  DateTime detectedAt,  StopReason? reason,  String? reasonText,  DateTime? reasonGivenAt,  DateTime? suppressedUntil,  DateTime? escalatedAt,  DateTime? resolvedAt)  $default,) {final _that = this;
switch (_that) {
case _StopEvent():
return $default(_that.id,_that.origin,_that.detectedAt,_that.reason,_that.reasonText,_that.reasonGivenAt,_that.suppressedUntil,_that.escalatedAt,_that.resolvedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  StopOrigin origin,  DateTime detectedAt,  StopReason? reason,  String? reasonText,  DateTime? reasonGivenAt,  DateTime? suppressedUntil,  DateTime? escalatedAt,  DateTime? resolvedAt)?  $default,) {final _that = this;
switch (_that) {
case _StopEvent() when $default != null:
return $default(_that.id,_that.origin,_that.detectedAt,_that.reason,_that.reasonText,_that.reasonGivenAt,_that.suppressedUntil,_that.escalatedAt,_that.resolvedAt);case _:
  return null;

}
}

}

/// @nodoc


class _StopEvent extends StopEvent {
  const _StopEvent({required this.id, required this.origin, required this.detectedAt, this.reason, this.reasonText, this.reasonGivenAt, this.suppressedUntil, this.escalatedAt, this.resolvedAt}): super._();
  

/// The stop's own `_id` — retained server-side precisely so a specific
/// stop can be addressed (the reason/resolve endpoints take it).
@override final  String id;
@override final  StopOrigin origin;
@override final  DateTime detectedAt;
@override final  StopReason? reason;
@override final  String? reasonText;
@override final  DateTime? reasonGivenAt;
@override final  DateTime? suppressedUntil;
@override final  DateTime? escalatedAt;
@override final  DateTime? resolvedAt;

/// Create a copy of StopEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StopEventCopyWith<_StopEvent> get copyWith => __$StopEventCopyWithImpl<_StopEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.detectedAt, detectedAt) || other.detectedAt == detectedAt)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.reasonText, reasonText) || other.reasonText == reasonText)&&(identical(other.reasonGivenAt, reasonGivenAt) || other.reasonGivenAt == reasonGivenAt)&&(identical(other.suppressedUntil, suppressedUntil) || other.suppressedUntil == suppressedUntil)&&(identical(other.escalatedAt, escalatedAt) || other.escalatedAt == escalatedAt)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,origin,detectedAt,reason,reasonText,reasonGivenAt,suppressedUntil,escalatedAt,resolvedAt);

@override
String toString() {
  return 'StopEvent(id: $id, origin: $origin, detectedAt: $detectedAt, reason: $reason, reasonText: $reasonText, reasonGivenAt: $reasonGivenAt, suppressedUntil: $suppressedUntil, escalatedAt: $escalatedAt, resolvedAt: $resolvedAt)';
}


}

/// @nodoc
abstract mixin class _$StopEventCopyWith<$Res> implements $StopEventCopyWith<$Res> {
  factory _$StopEventCopyWith(_StopEvent value, $Res Function(_StopEvent) _then) = __$StopEventCopyWithImpl;
@override @useResult
$Res call({
 String id, StopOrigin origin, DateTime detectedAt, StopReason? reason, String? reasonText, DateTime? reasonGivenAt, DateTime? suppressedUntil, DateTime? escalatedAt, DateTime? resolvedAt
});




}
/// @nodoc
class __$StopEventCopyWithImpl<$Res>
    implements _$StopEventCopyWith<$Res> {
  __$StopEventCopyWithImpl(this._self, this._then);

  final _StopEvent _self;
  final $Res Function(_StopEvent) _then;

/// Create a copy of StopEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? origin = null,Object? detectedAt = null,Object? reason = freezed,Object? reasonText = freezed,Object? reasonGivenAt = freezed,Object? suppressedUntil = freezed,Object? escalatedAt = freezed,Object? resolvedAt = freezed,}) {
  return _then(_StopEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as StopOrigin,detectedAt: null == detectedAt ? _self.detectedAt : detectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as StopReason?,reasonText: freezed == reasonText ? _self.reasonText : reasonText // ignore: cast_nullable_to_non_nullable
as String?,reasonGivenAt: freezed == reasonGivenAt ? _self.reasonGivenAt : reasonGivenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,suppressedUntil: freezed == suppressedUntil ? _self.suppressedUntil : suppressedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,escalatedAt: freezed == escalatedAt ? _self.escalatedAt : escalatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
