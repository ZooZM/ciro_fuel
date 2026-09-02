import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/invoice.dart';

part 'invoice_detail_state.freezed.dart';

@freezed
sealed class InvoiceDetailState with _$InvoiceDetailState {
  const factory InvoiceDetailState.loading() = InvoiceDetailLoading;
  const factory InvoiceDetailState.loaded(Invoice invoice) =
      InvoiceDetailLoaded;
  const factory InvoiceDetailState.failure(Failure failure) =
      InvoiceDetailFailureState;
}
