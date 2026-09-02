import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/support_request.dart';

abstract interface class SupportRepository {
  Future<Either<Failure, SupportRequest>> createRequest({
    required String topic,
    required String message,
    String? orderId,
  });

  Future<Either<Failure, List<SupportRequest>>> getRequests();
}
