import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/converters.dart';
import '../enums/fuel_type.dart';
import '../enums/order_status.dart';
import '../enums/payment_method.dart';
import 'value_objects.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// spec 004 FR-008/FR-028: the driver summary snapshotted onto the order at
/// assignment — the client's ONLY window into who is delivering their
/// order (they can never read the driver's own user record directly).
@freezed
abstract class DriverSummary with _$DriverSummary {
  const factory DriverSummary({
    required String fullName,
    required String phone,
    required String plateNumber,
  }) = _DriverSummary;

  factory DriverSummary.fromJson(Map<String, Object?> json) =>
      _$DriverSummaryFromJson(json);
}

/// Mirrors a backend order (feature 001 `/orders` resource, extended by
/// spec 004 US5/US6) read-only. `status` is authoritative only from the
/// backend — the client never derives or asserts a transition locally
/// (research R7).
@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    @OrderStatusConverter() required OrderStatus status,
    @FuelTypeConverter() required FuelType fuelType,
    required int quantityLiters,
    Money? estimatedPrice,
    Money? finalPrice,
    @PaymentMethodConverter() PaymentMethod? paymentMethod,
    String? invoiceId,
    // Set once the invoice is issued at approval and unset on settlement —
    // absent for DEFERRED/CREDIT orders, which never gate on payment.
    DateTime? paymentDeadline,
    String? driverId,
    DriverSummary? driverSummary,
    // spec 004 FR-029: derived live from the driver's last known position —
    // absent (never fabricated) until a driver is assigned and has reported one.
    int? etaMinutes,
    GeoPoint? destination,
    // spec 004 FR-009/FR-030: the client's station address, snapshotted at
    // order creation — the only human-readable destination the backend
    // stores (coordinates remain the fallback when it is empty).
    String? deliveryAddressText,
    required DateTime statusChangedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, Object?> json) => _$OrderFromJson(json);
}
