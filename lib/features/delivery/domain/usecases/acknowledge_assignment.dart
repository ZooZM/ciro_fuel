import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/delivery_repository.dart';

/// spec 010 FR-010: fired once, the first time the driver's active-delivery
/// screen genuinely displays a newly-assigned order (`DeliveryCubit.load`)
/// — never inferred from the device merely being online (FR-017).
class AcknowledgeAssignment {
  const AcknowledgeAssignment(this._repository);

  final DeliveryRepository _repository;

  Future<Either<Failure, void>> call(String orderId) =>
      _repository.acknowledgeAssignment(orderId);
}
