import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../domain/entities/otp_challenge.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._remoteDataSource);

  final OrdersRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Order>> createOrder({
    required FuelType fuelType,
    required int quantityLiters,
    GeoPoint? deliveryLocation,
  }) => _guard(
    () => _remoteDataSource.createOrder(
      fuelType: fuelType,
      quantityLiters: quantityLiters,
      deliveryLocation: deliveryLocation,
    ),
  );

  @override
  Future<Either<Failure, List<Order>>> getOrders({int page = 1}) =>
      _guard(() => _remoteDataSource.getOrders(page: page));

  @override
  Future<Either<Failure, Order>> getOrder(String orderId) =>
      _guard(() => _remoteDataSource.getOrder(orderId));

  @override
  Future<Either<Failure, OtpChallenge>> getCurrentOtp(String orderId) =>
      _guard(() => _remoteDataSource.getCurrentOtp(orderId));

  @override
  Future<Either<Failure, Order>> cancelOrder(String orderId) =>
      _guard(() => _remoteDataSource.cancelOrder(orderId));

  @override
  Future<Either<Failure, Order>> redispatch(String orderId) =>
      _guard(() => _remoteDataSource.redispatch(orderId));

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(
        e.error is Failure ? e.error as Failure : const Failure.server(),
      );
    }
  }
}
