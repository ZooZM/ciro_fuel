import 'package:dio/dio.dart';

import '../../../../shared/entities/invoice.dart';

abstract interface class InvoicesRemoteDataSource {
  Future<List<Invoice>> getInvoices();
}

class InvoicesRemoteDataSourceImpl implements InvoicesRemoteDataSource {
  InvoicesRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Invoice>> getInvoices() async {
    final response = await _dio.get<List<dynamic>>('/invoices');
    return response.data!
        .cast<Map<String, dynamic>>()
        .map(Invoice.fromJson)
        .toList();
  }
}
