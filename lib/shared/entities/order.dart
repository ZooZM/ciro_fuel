import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/fuel_type.dart';
import '../enums/order_status.dart';
import '../enums/payment_method.dart';
import 'value_objects.dart';

part 'order.freezed.dart';

/// spec 004 FR-008/FR-028: the driver summary snapshotted onto the order at
/// assignment — the client's ONLY window into who is delivering their
/// order (they can never read the driver's own user record directly).
///
/// No generated `fromJson`/`toJson`: nothing calls them.
/// `OrderMapper.fromJson` (`features/orders/data/models/order_mapper.dart`)
/// is the sole parser for this entity and every one it nests, built by
/// hand for the same reason `AuthUser`/`UserStation` now are — a nested
/// `GeoPoint` (on `Order.driverLocation`/`destination`) has no shape
/// `json_serializable` can derive a matching `toJson` for.
@freezed
abstract class DriverSummary with _$DriverSummary {
  const factory DriverSummary({
    required String fullName,
    required String phone,
    required String plateNumber,
  }) = _DriverSummary;
}

/// Mirrors a backend order (feature 001 `/orders` resource, extended by
/// spec 004 US5/US6) read-only. `status` is authoritative only from the
/// backend — the client never derives or asserts a transition locally
/// (research R7).
@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required OrderStatus status,
    required FuelType fuelType,
    required int quantityLiters,
    Money? estimatedPrice,
    Money? finalPrice,
    PaymentMethod? paymentMethod,
    String? invoiceId,
    // Set once the invoice is issued at approval and unset on settlement —
    // absent for DEFERRED/CREDIT orders, which never gate on payment.
    DateTime? paymentDeadline,
    String? driverId,
    DriverSummary? driverSummary,
    // spec 004 FR-029: derived live from the driver's last known position —
    // absent (never fabricated) until a driver is assigned and has reported one.
    int? etaMinutes,
    // The driver's last known position, as the platform holds it — the same
    // point `etaMinutes` was derived from. Lets the tracking map draw the
    // truck on open instead of staying blank until the driver's next
    // throttled socket ping; live movement still arrives over `/tracking`.
    GeoPoint? driverLocation,
    GeoPoint? destination,
    // spec 004 FR-009/FR-030: the client's station address, snapshotted at
    // order creation — the only human-readable destination the backend
    // stores (coordinates remain the fallback when it is empty).
    String? deliveryAddressText,
    // The station as it stands *now*, used only to fill in for an empty
    // snapshot above — an order placed before the station had an address
    // would otherwise show the client raw coordinates forever. Kept as plain
    // strings rather than the stations feature's `Station`, so this shared
    // entity does not depend on a feature package.
    String? stationName,
    String? stationAddressText,
    required DateTime statusChangedAt,
    // spec 005 D3/FR-011e: absent for orders placed before this feature or
    // created without a quote token — a total-only receipt then, never a
    // fabricated or zeroed-out breakdown.
    PriceBreakdown? priceBreakdown,
  }) = _Order;
}
