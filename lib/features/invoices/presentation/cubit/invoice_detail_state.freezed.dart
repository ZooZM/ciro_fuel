// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InvoiceDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InvoiceDetailState()';
}


}

/// @nodoc
class $InvoiceDetailStateCopyWith<$Res>  {
$InvoiceDetailStateCopyWith(InvoiceDetailState _, $Res Function(InvoiceDetailState) __);
}


/// Adds pattern-matching-related methods to [InvoiceDetailState].
extension InvoiceDetailStatePatterns on InvoiceDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InvoiceDetailLoading value)?  loading,TResult Function( InvoiceDetailLoaded value)?  loaded,TResult Function( InvoiceDetailFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InvoiceDetailLoading() when loading != null:
return loading(_that);case InvoiceDetailLoaded() when loaded != null:
return loaded(_that);case InvoiceDetailFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InvoiceDetailLoading value)  loading,required TResult Function( InvoiceDetailLoaded value)  loaded,required TResult Function( InvoiceDetailFailureState value)  failure,}){
final _that = this;
switch (_that) {
case InvoiceDetailLoading():
return loading(_that);case InvoiceDetailLoaded():
return loaded(_that);case InvoiceDetailFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InvoiceDetailLoading value)?  loading,TResult? Function( InvoiceDetailLoaded value)?  loaded,TResult? Function( InvoiceDetailFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case InvoiceDetailLoading() when loading != null:
return loading(_that);case InvoiceDetailLoaded() when loaded != null:
return loaded(_that);case InvoiceDetailFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( Invoice invoice)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InvoiceDetailLoading() when loading != null:
return loading();case InvoiceDetailLoaded() when loaded != null:
return loaded(_that.invoice);case InvoiceDetailFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( Invoice invoice)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case InvoiceDetailLoading():
return loading();case InvoiceDetailLoaded():
return loaded(_that.invoice);case InvoiceDetailFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( Invoice invoice)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case InvoiceDetailLoading() when loading != null:
return loading();case InvoiceDetailLoaded() when loaded != null:
return loaded(_that.invoice);case InvoiceDetailFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class InvoiceDetailLoading implements InvoiceDetailState {
  const InvoiceDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InvoiceDetailState.loading()';
}


}




/// @nodoc


class InvoiceDetailLoaded implements InvoiceDetailState {
  const InvoiceDetailLoaded(this.invoice);
  

 final  Invoice invoice;

/// Create a copy of InvoiceDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceDetailLoadedCopyWith<InvoiceDetailLoaded> get copyWith => _$InvoiceDetailLoadedCopyWithImpl<InvoiceDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceDetailLoaded&&(identical(other.invoice, invoice) || other.invoice == invoice));
}


@override
int get hashCode => Object.hash(runtimeType,invoice);

@override
String toString() {
  return 'InvoiceDetailState.loaded(invoice: $invoice)';
}


}

/// @nodoc
abstract mixin class $InvoiceDetailLoadedCopyWith<$Res> implements $InvoiceDetailStateCopyWith<$Res> {
  factory $InvoiceDetailLoadedCopyWith(InvoiceDetailLoaded value, $Res Function(InvoiceDetailLoaded) _then) = _$InvoiceDetailLoadedCopyWithImpl;
@useResult
$Res call({
 Invoice invoice
});


$InvoiceCopyWith<$Res> get invoice;

}
/// @nodoc
class _$InvoiceDetailLoadedCopyWithImpl<$Res>
    implements $InvoiceDetailLoadedCopyWith<$Res> {
  _$InvoiceDetailLoadedCopyWithImpl(this._self, this._then);

  final InvoiceDetailLoaded _self;
  final $Res Function(InvoiceDetailLoaded) _then;

/// Create a copy of InvoiceDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? invoice = null,}) {
  return _then(InvoiceDetailLoaded(
null == invoice ? _self.invoice : invoice // ignore: cast_nullable_to_non_nullable
as Invoice,
  ));
}

/// Create a copy of InvoiceDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvoiceCopyWith<$Res> get invoice {
  
  return $InvoiceCopyWith<$Res>(_self.invoice, (value) {
    return _then(_self.copyWith(invoice: value));
  });
}
}

/// @nodoc


class InvoiceDetailFailureState implements InvoiceDetailState {
  const InvoiceDetailFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of InvoiceDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceDetailFailureStateCopyWith<InvoiceDetailFailureState> get copyWith => _$InvoiceDetailFailureStateCopyWithImpl<InvoiceDetailFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceDetailFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'InvoiceDetailState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $InvoiceDetailFailureStateCopyWith<$Res> implements $InvoiceDetailStateCopyWith<$Res> {
  factory $InvoiceDetailFailureStateCopyWith(InvoiceDetailFailureState value, $Res Function(InvoiceDetailFailureState) _then) = _$InvoiceDetailFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$InvoiceDetailFailureStateCopyWithImpl<$Res>
    implements $InvoiceDetailFailureStateCopyWith<$Res> {
  _$InvoiceDetailFailureStateCopyWithImpl(this._self, this._then);

  final InvoiceDetailFailureState _self;
  final $Res Function(InvoiceDetailFailureState) _then;

/// Create a copy of InvoiceDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(InvoiceDetailFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of InvoiceDetailState
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
