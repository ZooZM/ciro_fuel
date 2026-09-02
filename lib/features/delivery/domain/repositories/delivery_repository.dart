import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../core/location/position_reader.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/verification_method.dart';
import '../../../../shared/enums/stop_reason.dart';
import '../entities/driver_standing.dart';

abstract interface class DeliveryRepository {
  Future<Either<Failure, Order?>> getActiveOrder();

  /// spec 008 US3: a delivery cannot begin, and cannot leave the loading
  /// stage, without this. Returns the order as the backend just left it —
  /// the caller reloads state from this, never assumes the outcome.
  Future<Either<Failure, Order>> verifyVehicle({
    required String orderId,
    required String credential,
    required VerificationMethod method,
    PositionFix? driverLocation,
  });

  /// spec 008 US4: a plain state transition — no quantity anywhere on this
  /// call (FR-028).
  Future<Either<Failure, Order>> confirmLoading(String orderId);

  Future<Either<Failure, void>> markArrived(String orderId);

  /// spec 010 FR-010: the explicit driver-side acknowledgment signal — the
  /// backend only ever infers acknowledgment from this call, never from
  /// presence/connectivity (FR-017). Idempotent on the backend, so a
  /// second call for an order already acknowledged is a harmless no-op.
  Future<Either<Failure, void>> acknowledgeAssignment(String orderId);

  Future<Either<Failure, void>> verifyArrivalOtp({
    required String orderId,
    required String otp,
  });

  Future<Either<Failure, void>> requestDeliveryOtp(String orderId);

  Future<Either<Failure, void>> verifyDeliveryOtp({
    required String orderId,
    required String otp,
  });

  /// spec 011 FR-008a-d: the driver announces a stop before it is detected.
  /// [expectedDurationMinutes] is their own estimate, and is what bounds how
  /// long detection stays quiet — no single declaration silences a delivery.
  Future<Either<Failure, void>> declareStop({
    required String orderId,
    required StopReason reason,
    String? reasonText,
    required int expectedDurationMinutes,
  });

  /// spec 011 FR-007/FR-010: the driver answers a detected stop. A late
  /// answer is an ordinary success on the backend, never an error, so this
  /// needs no special handling for the escalated case.
  Future<Either<Failure, void>> submitStopReason({
    required String orderId,
    required String stopId,
    required StopReason reason,
    String? reasonText,
  });

  Future<Either<Failure, DriverStanding>> getDriverSummary();
}
