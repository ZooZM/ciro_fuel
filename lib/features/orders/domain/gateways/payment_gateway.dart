import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/value_objects.dart';

/// Initiates payment via the native Sadad/Mada SDK. A `Right` return means
/// only that the native payment UI flow completed from the user's side —
/// it is NOT payment confirmation. The backend's webhook-driven order
/// state (`order:status → inTransit` / `GET /orders/:id`) is the sole
/// source of truth (research R3/R7); callers must never treat this
/// return value as proof of payment.
abstract interface class PaymentGateway {
  Future<Either<Failure, void>> pay({
    required String orderId,
    required Money amount,
  });
}
