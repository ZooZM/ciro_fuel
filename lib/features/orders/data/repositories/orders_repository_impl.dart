import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/payment_method.dart';
import '../../domain/entities/otp_challenge.dart';
import '../../domain/entities/price_breakdown.dart';
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
    PaymentMethod? paymentMethod,
    String? stationId,
    String? quoteToken,
  }) => _guard(
    () => _remoteDataSource.createOrder(
      fuelType: fuelType,
      quantityLiters: quantityLiters,
      deliveryLocation: deliveryLocation,
      paymentMethod: paymentMethod,
      stationId: stationId,
      quoteToken: quoteToken,
    ),
  );

  @override
  Future<Either<Failure, Quote>> quote({
    required FuelType fuelType,
    required int quantityLiters,
    required String stationId,
  }) => _guard(
    () => _remoteDataSource.quote(
      fuelType: fuelType,
      quantityLiters: quantityLiters,
      stationId: stationId,
    ),
  );

  @override
  Future<Either<Failure, PaginatedResult<Order>>> getOrders({
    OrderStatus? status,
    String? cursor,
  }) => _guard(() => _remoteDataSource.getOrders(status: status, cursor: cursor));

  @override
  Future<Either<Failure, Order>> getOrder(String orderId) =>
      _guard(() => _remoteDataSource.getOrder(orderId));

  @override
  Future<Either<Failure, List<GeoPoint>>> getDrivingRoute(String orderId) =>
      _guard(() => _remoteDataSource.getDrivingRoute(orderId));

  @override
  Future<Either<Failure, OtpChallenge>> getCurrentOtp(String orderId) =>
      _guard(() => _remoteDataSource.getCurrentOtp(orderId));

  @override
  Future<Either<Failure, Order>> cancelOrder(String orderId) =>
      _guard(() => _remoteDataSource.cancelOrder(orderId));

  @override
  Future<Either<Failure, Order>> redispatch(String orderId) =>
      _guard(() => _remoteDataSource.redispatch(orderId));

  @override
  Future<Either<Failure, OrderRating>> submitRating(
    String orderId, {
    required int score,
    String? review,
  }) => _guard(
    () => _remoteDataSource.submitRating(orderId, score: score, review: review),
  );

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(
        e.error is Failure ? e.error as Failure : const Failure.server(),
      );
    } catch (_) {
      // A mapping/parse throw (an unknown enum wire value, a malformed
      // envelope) must not escape the data layer: the caller awaits this
      // future, so an escaping error means the cubit never emits and the
      // screen hangs on its loading state forever (FR-041/FR-003).
      // `server()` covers "an unrecognized shape" per Failure's contract.
      return const Left(Failure.server());
    }
  }
}
