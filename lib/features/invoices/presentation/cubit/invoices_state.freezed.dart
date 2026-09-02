// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoices_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InvoicesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InvoicesState()';
}


}

/// @nodoc
class $InvoicesStateCopyWith<$Res>  {
$InvoicesStateCopyWith(InvoicesState _, $Res Function(InvoicesState) __);
}


/// Adds pattern-matching-related methods to [InvoicesState].
extension InvoicesStatePatterns on InvoicesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InvoicesLoading value)?  loading,TResult Function( InvoicesLoaded value)?  loaded,TResult Function( InvoicesLoadFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InvoicesLoading() when loading != null:
return loading(_that);case InvoicesLoaded() when loaded != null:
return loaded(_that);case InvoicesLoadFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InvoicesLoading value)  loading,required TResult Function( InvoicesLoaded value)  loaded,required TResult Function( InvoicesLoadFailure value)  failure,}){
final _that = this;
switch (_that) {
case InvoicesLoading():
return loading(_that);case InvoicesLoaded():
return loaded(_that);case InvoicesLoadFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InvoicesLoading value)?  loading,TResult? Function( InvoicesLoaded value)?  loaded,TResult? Function( InvoicesLoadFailure value)?  failure,}){
final _that = this;
switch (_that) {
case InvoicesLoading() when loading != null:
return loading(_that);case InvoicesLoaded() when loaded != null:
return loaded(_that);case InvoicesLoadFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<Invoice> invoices,  String? nextCursor,  bool isLoadingMore,  bool loadMoreFailed)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InvoicesLoading() when loading != null:
return loading();case InvoicesLoaded() when loaded != null:
return loaded(_that.invoices,_that.nextCursor,_that.isLoadingMore,_that.loadMoreFailed);case InvoicesLoadFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<Invoice> invoices,  String? nextCursor,  bool isLoadingMore,  bool loadMoreFailed)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case InvoicesLoading():
return loading();case InvoicesLoaded():
return loaded(_that.invoices,_that.nextCursor,_that.isLoadingMore,_that.loadMoreFailed);case InvoicesLoadFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<Invoice> invoices,  String? nextCursor,  bool isLoadingMore,  bool loadMoreFailed)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case InvoicesLoading() when loading != null:
return loading();case InvoicesLoaded() when loaded != null:
return loaded(_that.invoices,_that.nextCursor,_that.isLoadingMore,_that.loadMoreFailed);case InvoicesLoadFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class InvoicesLoading implements InvoicesState {
  const InvoicesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InvoicesState.loading()';
}


}




/// @nodoc


class InvoicesLoaded implements InvoicesState {
  const InvoicesLoaded(final  List<Invoice> invoices, {this.nextCursor, this.isLoadingMore = false, this.loadMoreFailed = false}): _invoices = invoices;
  

 final  List<Invoice> _invoices;
 List<Invoice> get invoices {
  if (_invoices is EqualUnmodifiableListView) return _invoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invoices);
}

 final  String? nextCursor;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  bool loadMoreFailed;

/// Create a copy of InvoicesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicesLoadedCopyWith<InvoicesLoaded> get copyWith => _$InvoicesLoadedCopyWithImpl<InvoicesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicesLoaded&&const DeepCollectionEquality().equals(other._invoices, _invoices)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreFailed, loadMoreFailed) || other.loadMoreFailed == loadMoreFailed));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_invoices),nextCursor,isLoadingMore,loadMoreFailed);

@override
String toString() {
  return 'InvoicesState.loaded(invoices: $invoices, nextCursor: $nextCursor, isLoadingMore: $isLoadingMore, loadMoreFailed: $loadMoreFailed)';
}


}

/// @nodoc
abstract mixin class $InvoicesLoadedCopyWith<$Res> implements $InvoicesStateCopyWith<$Res> {
  factory $InvoicesLoadedCopyWith(InvoicesLoaded value, $Res Function(InvoicesLoaded) _then) = _$InvoicesLoadedCopyWithImpl;
@useResult
$Res call({
 List<Invoice> invoices, String? nextCursor, bool isLoadingMore, bool loadMoreFailed
});




}
/// @nodoc
class _$InvoicesLoadedCopyWithImpl<$Res>
    implements $InvoicesLoadedCopyWith<$Res> {
  _$InvoicesLoadedCopyWithImpl(this._self, this._then);

  final InvoicesLoaded _self;
  final $Res Function(InvoicesLoaded) _then;

/// Create a copy of InvoicesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? invoices = null,Object? nextCursor = freezed,Object? isLoadingMore = null,Object? loadMoreFailed = null,}) {
  return _then(InvoicesLoaded(
null == invoices ? _self._invoices : invoices // ignore: cast_nullable_to_non_nullable
as List<Invoice>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailed: null == loadMoreFailed ? _self.loadMoreFailed : loadMoreFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class InvoicesLoadFailure implements InvoicesState {
  const InvoicesLoadFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of InvoicesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicesLoadFailureCopyWith<InvoicesLoadFailure> get copyWith => _$InvoicesLoadFailureCopyWithImpl<InvoicesLoadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicesLoadFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'InvoicesState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $InvoicesLoadFailureCopyWith<$Res> implements $InvoicesStateCopyWith<$Res> {
  factory $InvoicesLoadFailureCopyWith(InvoicesLoadFailure value, $Res Function(InvoicesLoadFailure) _then) = _$InvoicesLoadFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$InvoicesLoadFailureCopyWithImpl<$Res>
    implements $InvoicesLoadFailureCopyWith<$Res> {
  _$InvoicesLoadFailureCopyWithImpl(this._self, this._then);

  final InvoicesLoadFailure _self;
  final $Res Function(InvoicesLoadFailure) _then;

/// Create a copy of InvoicesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(InvoicesLoadFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of InvoicesState
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
