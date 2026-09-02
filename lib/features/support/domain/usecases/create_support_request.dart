import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/support_request.dart';
import '../repositories/support_repository.dart';

class CreateSupportRequest {
  const CreateSupportRequest(this._repository);

  final SupportRepository _repository;

  Future<Either<Failure, SupportRequest>> call({
    required String topic,
    required String message,
    String? orderId,
  }) => _repository.createRequest(topic: topic, message: message, orderId: orderId);
}
