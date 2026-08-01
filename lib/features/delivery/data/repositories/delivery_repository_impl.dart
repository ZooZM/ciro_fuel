import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../datasources/delivery_remote_data_source.dart';

class DeliveryRepositoryImpl implements DeliveryRepository {
  DeliveryRepositoryImpl(this._remoteDataSource);

  final DeliveryRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Order?>> getActiveOrder() =>
      _guard(_remoteDataSource.getActiveOrder);

  @override
  Future<Either<Failure, void>> markArrived(String orderId) =>
      _guard(() => _remoteDataSource.markArrived(orderId));

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

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(e.error is Failure ? e.error as Failure : const Failure.server());
    }
  }
}
