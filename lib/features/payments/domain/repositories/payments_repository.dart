import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/paginated_response.dart';
import '../entities/payment.dart';

abstract interface class PaymentsRepository {
  /// The caller's own confirmed payments, paginated newest-first
  /// (spec 005 FR-023).
  Future<Either<Failure, PaginatedResult<Payment>>> getPayments({
    String? cursor,
  });
}
