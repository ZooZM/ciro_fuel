// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finance_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FinanceState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FinanceState()';
}


}

/// @nodoc
class $FinanceStateCopyWith<$Res>  {
$FinanceStateCopyWith(FinanceState _, $Res Function(FinanceState) __);
}


/// Adds pattern-matching-related methods to [FinanceState].
extension FinanceStatePatterns on FinanceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FinanceLoading value)?  loading,TResult Function( FinanceLoaded value)?  loaded,TResult Function( FinanceLoadFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FinanceLoading() when loading != null:
return loading(_that);case FinanceLoaded() when loaded != null:
return loaded(_that);case FinanceLoadFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FinanceLoading value)  loading,required TResult Function( FinanceLoaded value)  loaded,required TResult Function( FinanceLoadFailure value)  failure,}){
final _that = this;
switch (_that) {
case FinanceLoading():
return loading(_that);case FinanceLoaded():
return loaded(_that);case FinanceLoadFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FinanceLoading value)?  loading,TResult? Function( FinanceLoaded value)?  loaded,TResult? Function( FinanceLoadFailure value)?  failure,}){
final _that = this;
switch (_that) {
case FinanceLoading() when loading != null:
return loading(_that);case FinanceLoaded() when loaded != null:
return loaded(_that);case FinanceLoadFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( double pendingInvoiceAmount,  double availableBalanceAmount)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FinanceLoading() when loading != null:
return loading();case FinanceLoaded() when loaded != null:
return loaded(_that.pendingInvoiceAmount,_that.availableBalanceAmount);case FinanceLoadFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( double pendingInvoiceAmount,  double availableBalanceAmount)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case FinanceLoading():
return loading();case FinanceLoaded():
return loaded(_that.pendingInvoiceAmount,_that.availableBalanceAmount);case FinanceLoadFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( double pendingInvoiceAmount,  double availableBalanceAmount)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case FinanceLoading() when loading != null:
return loading();case FinanceLoaded() when loaded != null:
return loaded(_that.pendingInvoiceAmount,_that.availableBalanceAmount);case FinanceLoadFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class FinanceLoading implements FinanceState {
  const FinanceLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FinanceState.loading()';
}


}




/// @nodoc


class FinanceLoaded implements FinanceState {
  const FinanceLoaded({required this.pendingInvoiceAmount, required this.availableBalanceAmount});
  

 final  double pendingInvoiceAmount;
 final  double availableBalanceAmount;

/// Create a copy of FinanceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceLoadedCopyWith<FinanceLoaded> get copyWith => _$FinanceLoadedCopyWithImpl<FinanceLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceLoaded&&(identical(other.pendingInvoiceAmount, pendingInvoiceAmount) || other.pendingInvoiceAmount == pendingInvoiceAmount)&&(identical(other.availableBalanceAmount, availableBalanceAmount) || other.availableBalanceAmount == availableBalanceAmount));
}


@override
int get hashCode => Object.hash(runtimeType,pendingInvoiceAmount,availableBalanceAmount);

@override
String toString() {
  return 'FinanceState.loaded(pendingInvoiceAmount: $pendingInvoiceAmount, availableBalanceAmount: $availableBalanceAmount)';
}


}

/// @nodoc
abstract mixin class $FinanceLoadedCopyWith<$Res> implements $FinanceStateCopyWith<$Res> {
  factory $FinanceLoadedCopyWith(FinanceLoaded value, $Res Function(FinanceLoaded) _then) = _$FinanceLoadedCopyWithImpl;
@useResult
$Res call({
 double pendingInvoiceAmount, double availableBalanceAmount
});




}
/// @nodoc
class _$FinanceLoadedCopyWithImpl<$Res>
    implements $FinanceLoadedCopyWith<$Res> {
  _$FinanceLoadedCopyWithImpl(this._self, this._then);

  final FinanceLoaded _self;
  final $Res Function(FinanceLoaded) _then;

/// Create a copy of FinanceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pendingInvoiceAmount = null,Object? availableBalanceAmount = null,}) {
  return _then(FinanceLoaded(
pendingInvoiceAmount: null == pendingInvoiceAmount ? _self.pendingInvoiceAmount : pendingInvoiceAmount // ignore: cast_nullable_to_non_nullable
as double,availableBalanceAmount: null == availableBalanceAmount ? _self.availableBalanceAmount : availableBalanceAmount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class FinanceLoadFailure implements FinanceState {
  const FinanceLoadFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of FinanceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceLoadFailureCopyWith<FinanceLoadFailure> get copyWith => _$FinanceLoadFailureCopyWithImpl<FinanceLoadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceLoadFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'FinanceState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FinanceLoadFailureCopyWith<$Res> implements $FinanceStateCopyWith<$Res> {
  factory $FinanceLoadFailureCopyWith(FinanceLoadFailure value, $Res Function(FinanceLoadFailure) _then) = _$FinanceLoadFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$FinanceLoadFailureCopyWithImpl<$Res>
    implements $FinanceLoadFailureCopyWith<$Res> {
  _$FinanceLoadFailureCopyWithImpl(this._self, this._then);

  final FinanceLoadFailure _self;
  final $Res Function(FinanceLoadFailure) _then;

/// Create a copy of FinanceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(FinanceLoadFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of FinanceState
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
