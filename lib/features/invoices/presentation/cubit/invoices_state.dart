import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/invoice.dart';

part 'invoices_state.freezed.dart';

@freezed
sealed class InvoicesState with _$InvoicesState {
  const factory InvoicesState.loading() = InvoicesLoading;

  /// [nextCursor] `null` means the end of the list (FR-048). [isLoadingMore]
  /// drives the trailing spinner; [loadMoreFailed] leaves every
  /// already-loaded invoice on screen with a retry (FR-048e), same
  /// contract as `OrdersState.loaded`.
  const factory InvoicesState.loaded(
    List<Invoice> invoices, {
    String? nextCursor,
    @Default(false) bool isLoadingMore,
    @Default(false) bool loadMoreFailed,
  }) = InvoicesLoaded;

  const factory InvoicesState.failure(Failure failure) = InvoicesLoadFailure;
}
