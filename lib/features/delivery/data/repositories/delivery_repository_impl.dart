import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/location/position_reader.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/verification_method.dart';
import '../../domain/entities/driver_standing.dart';
import '../../../../shared/enums/stop_reason.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../datasources/delivery_remote_data_source.dart';

class DeliveryRepositoryImpl implements DeliveryRepository {
  DeliveryRepositoryImpl(this._remoteDataSource);

  final DeliveryRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Order?>> getActiveOrder() =>
      _guard(_remoteDataSource.getActiveOrder);

  @override
  Future<Either<Failure, Order>> verifyVehicle({
    required String orderId,
    required String credential,
    required VerificationMethod method,
    PositionFix? driverLocation,
  }) => _guard(
    () => _remoteDataSource.verifyVehicle(
      orderId: orderId,
      credential: credential,
      method: method,
      driverLocation: driverLocation,
    ),
  );

  @override
  Future<Either<Failure, Order>> confirmLoading(String orderId) =>
      _guard(() => _remoteDataSource.confirmLoading(orderId));

  @override
  Future<Either<Failure, void>> markArrived(String orderId) =>
      _guard(() => _remoteDataSource.markArrived(orderId));

  @override
  Future<Either<Failure, void>> acknowledgeAssignment(String orderId) =>
      _guard(() => _remoteDataSource.acknowledgeAssignment(orderId));

  @override
  Future<Either<Failure, void>> declareStop({
    required String orderId,
    required StopReason reason,
    String? reasonText,
    required int expectedDurationMinutes,
  }) => _guard(
    () => _remoteDataSource.declareStop(
      orderId: orderId,
      reason: reason,
      reasonText: reasonText,
      expectedDurationMinutes: expectedDurationMinutes,
    ),
  );

  @override
  Future<Either<Failure, void>> submitStopReason({
    required String orderId,
    required String stopId,
    required StopReason reason,
    String? reasonText,
  }) => _guard(
    () => _remoteDataSource.submitStopReason(
      orderId: orderId,
      stopId: stopId,
      reason: reason,
      reasonText: reasonText,
    ),
  );

  @override
  Future<Either<Failure, void>> verifyArrivalOtp({
    required String orderId,
    required String otp,
  }) => _guard(
    () => _remoteDataSource.verifyArrivalOtp(orderId: orderId, otp: otp),
  );

  @override
  Future<Either<Failure, void>> requestDeliveryOtp(String orderId) =>
      _guard(() => _remoteDataSource.requestDeliveryOtp(orderId));

  @override
  Future<Either<Failure, void>> verifyDeliveryOtp({
    required String orderId,
    required String otp,
  }) => _guard(
    () => _remoteDataSource.verifyDeliveryOtp(orderId: orderId, otp: otp),
  );

  @override
  Future<Either<Failure, DriverStanding>> getDriverSummary() =>
      _guard(_remoteDataSource.getDriverSummary);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(
        e.error is Failure ? e.error as Failure : const Failure.server(),
      );
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }
}
