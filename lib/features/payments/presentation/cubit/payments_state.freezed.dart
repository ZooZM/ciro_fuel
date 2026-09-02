// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payments_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaymentsState()';
}


}

/// @nodoc
class $PaymentsStateCopyWith<$Res>  {
$PaymentsStateCopyWith(PaymentsState _, $Res Function(PaymentsState) __);
}


/// Adds pattern-matching-related methods to [PaymentsState].
extension PaymentsStatePatterns on PaymentsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PaymentsLoading value)?  loading,TResult Function( PaymentsLoaded value)?  loaded,TResult Function( PaymentsLoadFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PaymentsLoading() when loading != null:
return loading(_that);case PaymentsLoaded() when loaded != null:
return loaded(_that);case PaymentsLoadFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PaymentsLoading value)  loading,required TResult Function( PaymentsLoaded value)  loaded,required TResult Function( PaymentsLoadFailure value)  failure,}){
final _that = this;
switch (_that) {
case PaymentsLoading():
return loading(_that);case PaymentsLoaded():
return loaded(_that);case PaymentsLoadFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PaymentsLoading value)?  loading,TResult? Function( PaymentsLoaded value)?  loaded,TResult? Function( PaymentsLoadFailure value)?  failure,}){
final _that = this;
switch (_that) {
case PaymentsLoading() when loading != null:
return loading(_that);case PaymentsLoaded() when loaded != null:
return loaded(_that);case PaymentsLoadFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<Payment> payments,  String? nextCursor,  bool isLoadingMore,  bool loadMoreFailed)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PaymentsLoading() when loading != null:
return loading();case PaymentsLoaded() when loaded != null:
return loaded(_that.payments,_that.nextCursor,_that.isLoadingMore,_that.loadMoreFailed);case PaymentsLoadFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<Payment> payments,  String? nextCursor,  bool isLoadingMore,  bool loadMoreFailed)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case PaymentsLoading():
return loading();case PaymentsLoaded():
return loaded(_that.payments,_that.nextCursor,_that.isLoadingMore,_that.loadMoreFailed);case PaymentsLoadFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<Payment> payments,  String? nextCursor,  bool isLoadingMore,  bool loadMoreFailed)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case PaymentsLoading() when loading != null:
return loading();case PaymentsLoaded() when loaded != null:
return loaded(_that.payments,_that.nextCursor,_that.isLoadingMore,_that.loadMoreFailed);case PaymentsLoadFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class PaymentsLoading implements PaymentsState {
  const PaymentsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaymentsState.loading()';
}


}




/// @nodoc


class PaymentsLoaded implements PaymentsState {
  const PaymentsLoaded(final  List<Payment> payments, {this.nextCursor, this.isLoadingMore = false, this.loadMoreFailed = false}): _payments = payments;
  

 final  List<Payment> _payments;
 List<Payment> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

 final  String? nextCursor;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  bool loadMoreFailed;

/// Create a copy of PaymentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentsLoadedCopyWith<PaymentsLoaded> get copyWith => _$PaymentsLoadedCopyWithImpl<PaymentsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentsLoaded&&const DeepCollectionEquality().equals(other._payments, _payments)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreFailed, loadMoreFailed) || other.loadMoreFailed == loadMoreFailed));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_payments),nextCursor,isLoadingMore,loadMoreFailed);

@override
String toString() {
  return 'PaymentsState.loaded(payments: $payments, nextCursor: $nextCursor, isLoadingMore: $isLoadingMore, loadMoreFailed: $loadMoreFailed)';
}


}

/// @nodoc
abstract mixin class $PaymentsLoadedCopyWith<$Res> implements $PaymentsStateCopyWith<$Res> {
  factory $PaymentsLoadedCopyWith(PaymentsLoaded value, $Res Function(PaymentsLoaded) _then) = _$PaymentsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Payment> payments, String? nextCursor, bool isLoadingMore, bool loadMoreFailed
});




}
/// @nodoc
class _$PaymentsLoadedCopyWithImpl<$Res>
    implements $PaymentsLoadedCopyWith<$Res> {
  _$PaymentsLoadedCopyWithImpl(this._self, this._then);

  final PaymentsLoaded _self;
  final $Res Function(PaymentsLoaded) _then;

/// Create a copy of PaymentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? payments = null,Object? nextCursor = freezed,Object? isLoadingMore = null,Object? loadMoreFailed = null,}) {
  return _then(PaymentsLoaded(
null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<Payment>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailed: null == loadMoreFailed ? _self.loadMoreFailed : loadMoreFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class PaymentsLoadFailure implements PaymentsState {
  const PaymentsLoadFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of PaymentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentsLoadFailureCopyWith<PaymentsLoadFailure> get copyWith => _$PaymentsLoadFailureCopyWithImpl<PaymentsLoadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentsLoadFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'PaymentsState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PaymentsLoadFailureCopyWith<$Res> implements $PaymentsStateCopyWith<$Res> {
  factory $PaymentsLoadFailureCopyWith(PaymentsLoadFailure value, $Res Function(PaymentsLoadFailure) _then) = _$PaymentsLoadFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$PaymentsLoadFailureCopyWithImpl<$Res>
    implements $PaymentsLoadFailureCopyWith<$Res> {
  _$PaymentsLoadFailureCopyWithImpl(this._self, this._then);

  final PaymentsLoadFailure _self;
  final $Res Function(PaymentsLoadFailure) _then;

/// Create a copy of PaymentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(PaymentsLoadFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of PaymentsState
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
