// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SupportRequest {

 String get id; String get topic; String get message; String get state; DateTime get createdAt; String? get orderId; DateTime? get acknowledgedAt;
/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportRequestCopyWith<SupportRequest> get copyWith => _$SupportRequestCopyWithImpl<SupportRequest>(this as SupportRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.message, message) || other.message == message)&&(identical(other.state, state) || other.state == state)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,topic,message,state,createdAt,orderId,acknowledgedAt);

@override
String toString() {
  return 'SupportRequest(id: $id, topic: $topic, message: $message, state: $state, createdAt: $createdAt, orderId: $orderId, acknowledgedAt: $acknowledgedAt)';
}


}

/// @nodoc
abstract mixin class $SupportRequestCopyWith<$Res>  {
  factory $SupportRequestCopyWith(SupportRequest value, $Res Function(SupportRequest) _then) = _$SupportRequestCopyWithImpl;
@useResult
$Res call({
 String id, String topic, String message, String state, DateTime createdAt, String? orderId, DateTime? acknowledgedAt
});




}
/// @nodoc
class _$SupportRequestCopyWithImpl<$Res>
    implements $SupportRequestCopyWith<$Res> {
  _$SupportRequestCopyWithImpl(this._self, this._then);

  final SupportRequest _self;
  final $Res Function(SupportRequest) _then;

/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? topic = null,Object? message = null,Object? state = null,Object? createdAt = null,Object? orderId = freezed,Object? acknowledgedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportRequest].
extension SupportRequestPatterns on SupportRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportRequest value)  $default,){
final _that = this;
switch (_that) {
case _SupportRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String topic,  String message,  String state,  DateTime createdAt,  String? orderId,  DateTime? acknowledgedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
return $default(_that.id,_that.topic,_that.message,_that.state,_that.createdAt,_that.orderId,_that.acknowledgedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String topic,  String message,  String state,  DateTime createdAt,  String? orderId,  DateTime? acknowledgedAt)  $default,) {final _that = this;
switch (_that) {
case _SupportRequest():
return $default(_that.id,_that.topic,_that.message,_that.state,_that.createdAt,_that.orderId,_that.acknowledgedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String topic,  String message,  String state,  DateTime createdAt,  String? orderId,  DateTime? acknowledgedAt)?  $default,) {final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
return $default(_that.id,_that.topic,_that.message,_that.state,_that.createdAt,_that.orderId,_that.acknowledgedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SupportRequest extends SupportRequest {
  const _SupportRequest({required this.id, required this.topic, required this.message, required this.state, required this.createdAt, this.orderId, this.acknowledgedAt}): super._();
  

@override final  String id;
@override final  String topic;
@override final  String message;
@override final  String state;
@override final  DateTime createdAt;
@override final  String? orderId;
@override final  DateTime? acknowledgedAt;

/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportRequestCopyWith<_SupportRequest> get copyWith => __$SupportRequestCopyWithImpl<_SupportRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.message, message) || other.message == message)&&(identical(other.state, state) || other.state == state)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,topic,message,state,createdAt,orderId,acknowledgedAt);

@override
String toString() {
  return 'SupportRequest(id: $id, topic: $topic, message: $message, state: $state, createdAt: $createdAt, orderId: $orderId, acknowledgedAt: $acknowledgedAt)';
}


}

/// @nodoc
abstract mixin class _$SupportRequestCopyWith<$Res> implements $SupportRequestCopyWith<$Res> {
  factory _$SupportRequestCopyWith(_SupportRequest value, $Res Function(_SupportRequest) _then) = __$SupportRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String topic, String message, String state, DateTime createdAt, String? orderId, DateTime? acknowledgedAt
});




}
/// @nodoc
class __$SupportRequestCopyWithImpl<$Res>
    implements _$SupportRequestCopyWith<$Res> {
  __$SupportRequestCopyWithImpl(this._self, this._then);

  final _SupportRequest _self;
  final $Res Function(_SupportRequest) _then;

/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? topic = null,Object? message = null,Object? state = null,Object? createdAt = null,Object? orderId = freezed,Object? acknowledgedAt = freezed,}) {
  return _then(_SupportRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
