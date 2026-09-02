import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/enums/stop_reason.dart';
import '../repositories/delivery_repository.dart';

/// spec 011 FR-008a: the driver announces a stop before anyone asks — a
/// prayer break, a planned refuelling stop, a queue they can already see.
///
/// The duration is not decoration: it is the entire reason a declaration
/// cannot be used to disappear. Detection resumes the moment the driver's
/// own estimate lapses (FR-008d).
class DeclareStop {
  const DeclareStop(this._repository);

  final DeliveryRepository _repository;

  Future<Either<Failure, void>> call({
    required String orderId,
    required StopReason reason,
    String? reasonText,
    required int expectedDurationMinutes,
  }) => _repository.declareStop(
    orderId: orderId,
    reason: reason,
    reasonText: reasonText,
    expectedDurationMinutes: expectedDurationMinutes,
  );
}
