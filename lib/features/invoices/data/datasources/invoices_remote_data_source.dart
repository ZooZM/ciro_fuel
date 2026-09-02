import 'package:dio/dio.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../../shared/entities/invoice.dart';
import '../../../../shared/enums/invoice_state.dart';
import '../../../../shared/enums/payment_method.dart';
import '../../domain/entities/credit_standing.dart';

abstract interface class InvoicesRemoteDataSource {
  Future<PaginatedResult<Invoice>> getInvoices({
    PaymentMethod? method,
    InvoiceState? state,
    String? cursor,
  });

  Future<Invoice> getInvoice(String invoiceId);

  /// `GET /users/me/credit` (spec 005 T081) — kept alongside the invoices
  /// endpoints since it's the invoices feature's own dashboard/credit-screen
  /// data, not a separate profile concern.
  Future<CreditStanding> getCreditStanding();
}

class InvoicesRemoteDataSourceImpl implements InvoicesRemoteDataSource {
  InvoicesRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<PaginatedResult<Invoice>> getInvoices({
    PaymentMethod? method,
    InvoiceState? state,
    String? cursor,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/invoices',
      queryParameters: {
        if (method != null) 'method': method.toWire(),
        if (state != null) 'state': state.toWire(),
        if (cursor != null) 'cursor': cursor,
      },
    );
    return parsePaginatedResponse(response.data!, Invoice.fromJson);
  }

  @override
  Future<Invoice> getInvoice(String invoiceId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/invoices/$invoiceId',
    );
    return Invoice.fromJson(response.data!);
  }

  @override
  Future<CreditStanding> getCreditStanding() async {
    final response = await _dio.get<Map<String, dynamic>>('/users/me/credit');
    return CreditStanding.fromJson(response.data!);
  }
}
