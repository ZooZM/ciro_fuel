import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/enums/stop_reason.dart';
import '../repositories/delivery_repository.dart';

/// feature 013 US5a (FR-039): the driver cannot reach the destination and is
/// asking for help. Unlike [DeclareStop] this carries no duration — it is not
/// a planned pause — and the transporter is told immediately.
///
/// A `409 STOP_ALREADY_OPEN` surfaces as `Failure.validation(code:
/// ErrorCodes.stopAlreadyOpen)`, which the caller renders as a stated message
/// rather than a failure screen.
class ReportBlocked {
  const ReportBlocked(this._repository);

  final DeliveryRepository _repository;

  Future<Either<Failure, void>> call({
    required String orderId,
    required StopReason reason,
    String? reasonText,
  }) => _repository.reportBlocked(
    orderId: orderId,
    reason: reason,
    reasonText: reasonText,
  );
}
