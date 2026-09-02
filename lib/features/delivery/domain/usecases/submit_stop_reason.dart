import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/enums/stop_reason.dart';
import '../repositories/delivery_repository.dart';

/// spec 011 FR-007: the driver's answer to a stop the platform detected.
///
/// Deliberately carries no notion of "too late" (FR-010). If the response
/// window already elapsed and the transporter was already told, the backend
/// still records this as an ordinary resolution — so there is nothing for
/// this layer to check, and adding a client-side deadline would invent a
/// refusal the platform does not make.
class SubmitStopReason {
  const SubmitStopReason(this._repository);

  final DeliveryRepository _repository;

  Future<Either<Failure, void>> call({
    required String orderId,
    required String stopId,
    required StopReason reason,
    String? reasonText,
  }) => _repository.submitStopReason(
    orderId: orderId,
    stopId: stopId,
    reason: reason,
    reasonText: reasonText,
  );
}
