import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/converters.dart';
import '../enums/invoice_state.dart';
import '../enums/payment_method.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

/// Mirrors a backend invoice (spec 004 `/invoices` resource, US5).
/// `amount` is a decimal SAR figure, same convention as `Order.estimatedPrice`.
@freezed
abstract class Invoice with _$Invoice {
  const factory Invoice({
    @JsonKey(name: '_id') required String id,
    required String orderId,
    required double amount,
    @PaymentMethodConverter() required PaymentMethod method,
    @InvoiceStateConverter() required InvoiceState state,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, Object?> json) =>
      _$InvoiceFromJson(json);
}
