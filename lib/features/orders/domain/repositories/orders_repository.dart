import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/payment_method.dart';
import '../entities/otp_challenge.dart';
import '../entities/price_breakdown.dart';

abstract interface class OrdersRepository {
  /// [stationId] and [quoteToken] are both required for the real,
  /// itemised-pricing path (spec 005 US2) — optional here only because the
  /// backend itself keeps them optional for callers outside the client app
  /// (research R11/T055's backward-compatibility note). The client app
  /// always supplies both.
  Future<Either<Failure, Order>> createOrder({
    required FuelType fuelType,
    required int quantityLiters,
    GeoPoint? deliveryLocation,
    PaymentMethod? paymentMethod,
    String? stationId,
    String? quoteToken,
  });

  /// A quote is never trusted for its total on its own — [quoteToken] must
  /// be redeemed via [createOrder] before the price is real (research R10).
  Future<Either<Failure, Quote>> quote({
    required FuelType fuelType,
    required int quantityLiters,
    required String stationId,
  });

  /// Backend-scoped to the caller, cursor-paginated (feature 005, FR-048).
  /// `status`, when given, is applied across the caller's whole set.
  Future<Either<Failure, PaginatedResult<Order>>> getOrders({
    OrderStatus? status,
    String? cursor,
  });

  Future<Either<Failure, Order>> getOrder(String orderId);

  /// Empty list when there is no driven route to show — the map then
  /// falls back to a direct line rather than an error state.
  Future<Either<Failure, List<GeoPoint>>> getDrivingRoute(String orderId);

  Future<Either<Failure, OtpChallenge>> getCurrentOtp(String orderId);

  Future<Either<Failure, Order>> cancelOrder(String orderId);

  Future<Either<Failure, Order>> redispatch(String orderId);

  /// FR-037/FR-039/FR-040: `review` optional (FR-037a). The 409s this can
  /// return (`ALREADY_RATED`, `ORDER_NOT_DELIVERED`) reach the caller as a
  /// `ValidationFailure`'s `code` — see `error_codes.dart`.
  Future<Either<Failure, OrderRating>> submitRating(
    String orderId, {
    required int score,
    String? review,
  });
}
