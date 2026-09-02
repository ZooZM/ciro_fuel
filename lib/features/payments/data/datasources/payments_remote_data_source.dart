import 'package:dio/dio.dart';

import '../../../../core/network/paginated_response.dart';
import '../../domain/entities/payment.dart';

abstract interface class PaymentsRemoteDataSource {
  Future<PaginatedResult<Payment>> getPayments({String? cursor});
}

class PaymentsRemoteDataSourceImpl implements PaymentsRemoteDataSource {
  PaymentsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<PaginatedResult<Payment>> getPayments({String? cursor}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/payments',
      queryParameters: {if (cursor != null) 'cursor': cursor},
    );
    return parsePaginatedResponse(response.data!, Payment.fromJson);
  }
}
