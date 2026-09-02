import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/fuel_type.dart';
import '../enums/order_status.dart';
import '../enums/payment_method.dart';
import '../enums/tank_material.dart';
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

/// spec 007 FR-003a: the mirror image of [DriverSummary] — the customer's
/// contact details, snapshotted onto the order in the same transaction as
/// `driverSummary`, so the assigned driver can identify and reach them.
/// Absent on any order assigned before this feature existed; that must be
/// read as "no contact available" (FR-027b), never as an error.
@freezed
abstract class ClientSummary with _$ClientSummary {
  const factory ClientSummary({required String fullName, required String phone}) =
      _ClientSummary;
}

/// spec 007 FR-037d/FR-041: the delivery's rating, once the customer has
/// submitted one — read by both personas off the order itself, never a
/// separate fetch. [review] is rendered as plain text only, never
/// interpreted as markup (FR-037b).
@freezed
abstract class OrderRating with _$OrderRating {
  const factory OrderRating({required int score, String? review}) = _OrderRating;
}

/// spec 008 (data-model.md): the assigned tank's identity, snapshotted at
/// assignment — the driver MUST see this from the moment of assignment
/// (FR-033a/FR-033b), so a wrong physical trailer is visible to a human
/// even though the platform itself never verifies the tank.
@freezed
abstract class TankSummary with _$TankSummary {
  const factory TankSummary({required String code, required TankMaterial material}) =
      _TankSummary;
}

/// spec 008 (data-model.md): the warehouse the driver loads from, frozen
/// once assigned (FR-035e) — a later withdrawal or edit of the warehouse
/// record must not rewrite what this delivery was told to load from.
@freezed
abstract class WarehouseSummary with _$WarehouseSummary {
  const factory WarehouseSummary({
    required String name,
    required String addressText,
    required GeoPoint location,
  }) = _WarehouseSummary;
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
    ClientSummary? clientSummary,
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
    // spec 007 FR-037d/FR-041: absent until the customer rates this
    // delivery — never a zero or an empty star row in that case (FR-041a).
    OrderRating? rating,
    // spec 008: absent pre-cutover and before assignment (research R12).
    String? truckId,
    // Driver/operator-facing only — never present on the customer's own
    // read of this order (backend FR-042/T130).
    TankSummary? tankSummary,
    WarehouseSummary? warehouseSummary,
    // Set once loading is confirmed (normal flow or override) — absent
    // before then.
    DateTime? loadingConfirmedAt,
    // spec 010 FR-010: set once this driver has explicitly acknowledged
    // the assignment (`AcknowledgeAssignment`) — absent until then, which
    // is exactly the signal `DeliveryCubit.load` checks before firing that
    // call, so it fires at most once per assignment.
    DateTime? assignmentAcknowledgedAt,
    // FR-047d: false for an overridden departure, since an override
    // deliberately writes no verification record — read this, never
    // `driverSummary`'s mere presence, before ever presenting the vehicle
    // as "verified" to a customer.
    @Default(false) bool vehicleVerified,
  }) = _Order;
}
