import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/utils/number_formatting.dart';
import '../../../../core/widgets/order_flow.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/entities/value_objects.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../../shared/enums/payment_method.dart';

/// Turns a backend [Order] into the values the order screens render: a
/// localized label, the design's status colour, and how far along the
/// progress ring should sit.
///
/// The mapping is one-way and total — every backend status has an entry, so a
/// status the UI has no design for can never fall through to a blank chip.
/// Nothing here derives or predicts a transition: the server's `status` is
/// the only input (research R7).
abstract final class OrderPresentation {
  static const Color _blue = Color(0xFF1E5FFF);
  static const Color _green = Color(0xFF12A150);
  static const Color _orange = Color(0xFFF97316);
  static const Color _red = Color(0xFFEF3F3F);
  static const Color _slate = Color(0xFF8A93A6);

  static String statusLabel(OrderStatus status) =>
      _statusKey(status).tr();

  static String _statusKey(OrderStatus status) => switch (status) {
    OrderStatus.pendingApproval => OrderStatusKeys.pendingApproval,
    OrderStatus.approved => OrderStatusKeys.approved,
    OrderStatus.awaitingRouting => OrderStatusKeys.awaitingRouting,
    OrderStatus.routedToTransport => OrderStatusKeys.routedToTransport,
    OrderStatus.assignedToDriver => OrderStatusKeys.assignedToDriver,
    OrderStatus.pendingPayment => OrderStatusKeys.pendingPayment,
    OrderStatus.loading => OrderStatusKeys.loading,
    OrderStatus.inTransit => OrderStatusKeys.inTransit,
    OrderStatus.unloading => OrderStatusKeys.unloading,
    OrderStatus.delivered => OrderStatusKeys.delivered,
    OrderStatus.rejected => OrderStatusKeys.rejected,
    OrderStatus.cancelled => OrderStatusKeys.cancelled,
  };

  static Color statusColor(OrderStatus status) => switch (status) {
    OrderStatus.pendingApproval => _slate,
    OrderStatus.approved ||
    OrderStatus.awaitingRouting ||
    OrderStatus.routedToTransport ||
    OrderStatus.assignedToDriver => _green,
    OrderStatus.pendingPayment => _orange,
    // Groups with inTransit — a delivery that is loading is already moving,
    // just not yet toward the customer.
    OrderStatus.loading || OrderStatus.inTransit || OrderStatus.unloading => _blue,
    OrderStatus.delivered => _green,
    OrderStatus.rejected || OrderStatus.cancelled => _red,
  };

  /// Which stop on the five-step delivery timeline the order has reached.
  ///
  /// Exhaustive over [OrderStatus] on purpose: a new backend status has to
  /// be placed on the journey deliberately, rather than silently inheriting
  /// whatever the timeline defaulted to — which is how the dashboard came
  /// to show every order as already dispatched and on the way.
  ///
  /// `pendingApproval` sits on the *first* step rather than before it: the
  /// order is awaiting acceptance, so nothing behind it is complete and no
  /// step reads as done.
  static OrderFlowStep flowStep(OrderStatus status) => switch (status) {
    OrderStatus.pendingApproval => OrderFlowStep.accepted,
    OrderStatus.approved ||
    OrderStatus.awaitingRouting ||
    OrderStatus.routedToTransport => OrderFlowStep.loading,
    OrderStatus.assignedToDriver ||
    OrderStatus.pendingPayment => OrderFlowStep.dispatched,
    // spec 008: the truck is genuinely being loaded now — the same "loading"
    // stop the timeline already had a bubble for, previously used loosely
    // for the pre-dispatch approval/routing stretch.
    OrderStatus.loading => OrderFlowStep.loading,
    OrderStatus.inTransit => OrderFlowStep.onTheWay,
    OrderStatus.unloading || OrderStatus.delivered => OrderFlowStep.delivered,
    // A rejected or cancelled order never travelled, so nothing on the
    // journey is marked complete.
    OrderStatus.rejected || OrderStatus.cancelled => OrderFlowStep.accepted,
  };

  /// Whether the client can follow this order on the map and reach its
  /// driver. Only true once the order is genuinely moving — before that
  /// there is no driver assigned and no position to plot, so offering
  /// either action promises something the platform cannot answer.
  ///
  /// spec 008: deliberately **false** for `loading` too, even though a
  /// driver is assigned and may have a position — during loading the truck
  /// is at (or heading to) a fuel depot, not the customer, and the client's
  /// tracking map plots progress toward *their own station*. Showing it
  /// during loading would present the depot leg as progress toward the
  /// customer, which is actively misleading.
  static bool isTrackable(OrderStatus status) => status == OrderStatus.inTransit;

  /// Fraction of the ring to fill. The two terminal failure states show a
  /// full ring in red rather than an arbitrary partial one — the order
  /// stopped there, it did not stall mid-way.
  static double statusProgress(OrderStatus status) => switch (status) {
    OrderStatus.pendingApproval => 0.15,
    OrderStatus.approved => 0.25,
    OrderStatus.awaitingRouting => 0.3,
    OrderStatus.routedToTransport => 0.4,
    OrderStatus.assignedToDriver => 0.5,
    OrderStatus.pendingPayment => 0.6,
    OrderStatus.loading => 0.62,
    OrderStatus.inTransit => 0.75,
    OrderStatus.unloading => 0.9,
    OrderStatus.delivered => 1,
    OrderStatus.rejected || OrderStatus.cancelled => 1,
  };

  static String fuelLabel(FuelType fuelType) => switch (fuelType) {
    FuelType.diesel => FuelTypeKeys.diesel,
    FuelType.gasoline91 => FuelTypeKeys.gasoline91,
    FuelType.gasoline95 => FuelTypeKeys.gasoline95,
    FuelType.kerosene => FuelTypeKeys.kerosene,
  }
      .tr();

  /// The backend has no human-facing order reference — orders are identified
  /// by their Mongo `_id`. The last six characters are shown so a customer can
  /// quote something short to support; the full id still goes on the wire.
  static String shortReference(String orderId) =>
      '#${orderId.substring(orderId.length - 6).toUpperCase()}';

  /// spec 004 FR-009/FR-030: the client's station address, snapshotted onto
  /// the order at creation, is the primary label. Coordinates are only a
  /// fallback for the rare order with no address text on file (e.g. a
  /// station registered before the geocode lookup existed).
  static String destinationLabel(Order order) {
    // The snapshot first — FR-009/FR-030 keeps the address as it stood when
    // the order was placed, so a later rename cannot rewrite history.
    final addressText = order.deliveryAddressText;
    if (addressText != null && addressText.isNotEmpty) return addressText;

    // Then the station as it is now. An order placed while the station had
    // no address on file has an empty snapshot, and printing raw coordinates
    // at a client who has never seen their station in those terms is the
    // worst of the three options — the name is what they recognise.
    final stationAddress = order.stationAddressText;
    if (stationAddress != null && stationAddress.isNotEmpty) {
      return stationAddress;
    }
    final stationName = order.stationName;
    if (stationName != null && stationName.isNotEmpty) return stationName;

    final destination = order.destination;
    if (destination == null) return OrdersKeys.locationUnavailable.tr();
    return '${destination.lat.toStringAsFixed(4)}, '
        '${destination.lng.toStringAsFixed(4)}';
  }

  /// spec 004 FR-029: null (never a fabricated string) until a driver is
  /// assigned and has reported a position.
  static String? etaLabel(Order order) {
    final etaMinutes = order.etaMinutes;
    if (etaMinutes == null) return null;
    return '$etaMinutes ${OrderDetailKeys.minutes.tr()}';
  }

  /// Straight-line distance from [from] to [to], formatted in km — null
  /// (never a fabricated figure) until both points are known. Shared by the
  /// client's tracking map and the driver's navigation screen; both need
  /// exactly this "how far, right now" number and nothing turn-by-turn.
  static String? distanceLabel(GeoPoint? from, GeoPoint? to) {
    if (from == null || to == null) return null;
    final meters = Geolocator.distanceBetween(from.lat, from.lng, to.lat, to.lng);
    return '${NumberFormatting.currency(meters / 1000)} ${CommonKeys.km.tr()}';
  }

  /// Numeric (`02/05/2026`) rather than a spelled-out month: the dashboard's
  /// order card sizes its date row for the compact form, and a long localized
  /// month name overflows it.
  static String date(DateTime value) =>
      DateFormat.yMd(Intl.getCurrentLocale()).format(value.toLocal());

  static String time(DateTime value) =>
      DateFormat.jm(Intl.getCurrentLocale()).format(value.toLocal());
}

/// The filter pills above the list. Each maps to the set of backend statuses
/// it covers, so filtering never invents a status the server does not have.
enum OrderFilter {
  all(OrdersKeys.filterAll, <OrderStatus>{}),
  underReview(OrdersKeys.filterUnderReview, {OrderStatus.pendingApproval}),
  confirmed(OrdersKeys.filterConfirmed, {
    OrderStatus.approved,
    OrderStatus.awaitingRouting,
    OrderStatus.routedToTransport,
    OrderStatus.assignedToDriver,
  }),
  awaitingPayment(OrdersKeys.filterAwaitingPayment, {
    OrderStatus.pendingPayment,
  }),
  inDelivery(OrdersKeys.filterInDelivery, {
    OrderStatus.loading,
    OrderStatus.inTransit,
    OrderStatus.unloading,
  }),
  delivered(OrdersKeys.filterDelivered, {OrderStatus.delivered}),
  failed(OrdersKeys.filterFailed, {
    OrderStatus.rejected,
    OrderStatus.cancelled,
  });

  const OrderFilter(this.labelKey, this.statuses);

  final String labelKey;
  final Set<OrderStatus> statuses;

  String get label => labelKey.tr();

  /// Applied client-side: several pills span more than one status, which the
  /// single-value `?status=` query cannot express in one request.
  bool matches(Order order) =>
      statuses.isEmpty || statuses.contains(order.status);
}

/// Which status card and actions the order detail screen shows (spec 005
/// T039, research R9) — replaces the old preview-only `MockOrderState`.
/// Deliberately coarser than [OrderStatus] itself: several backend statuses
/// share the same card treatment once payment method is folded in.
enum OrderCardKind {
  /// PENDING_APPROVAL — the fuel company hasn't reviewed it yet; no price
  /// or payment concept has been surfaced.
  pendingApproval,

  /// The client owes a payment right now — DIRECT orders only, and only
  /// while genuinely resting at PENDING_PAYMENT (see [cardKindFor]).
  awaitingPayment,

  /// Routing has priced the haul and the platform is waiting for the station
  /// owner to accept that total — DEFERRED/CREDIT orders at PENDING_PAYMENT.
  /// There is no gateway payment to make, so the gate is an explicit
  /// acceptance (`POST /orders/:id/accept`) rather than a settlement.
  awaitingAcceptance,

  /// Approved and moving toward dispatch; no payment currently due from the
  /// client, regardless of payment method.
  confirmed,

  inTransit,
  delivered,
  cancelled,
}

/// Classifies an order's status card, single exhaustive switch over
/// [OrderStatus] (a missed status is a compile error, not a blank card at
/// runtime).
///
/// `PENDING_PAYMENT` is the only status mapped to [OrderCardKind.awaitingPayment],
/// and only when [method] is DIRECT. A DEFERRED/CREDIT order rests there
/// too — approval routes it onward, but routing then prices the haul and
/// sends it BACK to PENDING_PAYMENT for the station owner's acceptance —
/// and must never show a pay action, since it has no gateway payment to
/// make; it maps to [OrderCardKind.awaitingAcceptance] instead
/// (research R9).
///
/// `APPROVED` is deliberately **not** treated as "awaiting payment" for
/// DIRECT orders, even though a DIRECT order is briefly APPROVED before
/// payment too: the backend's state machine (`order-state.service.ts`)
/// reuses `APPROVED` for two different moments in a DIRECT order's
/// lifecycle — the initial pre-payment approval, and the post-payment pivot
/// back into routing once the webhook confirms — so `(status, method)`
/// alone cannot distinguish them there. `PENDING_PAYMENT` carries no such
/// ambiguity: it is the status a DIRECT order genuinely stops and waits at.
/// The headline `SettledOrderStatusCard` shows for [OrderCardKind.confirmed]
/// and [OrderCardKind.delivered] — meaningful only for those two kinds.
/// `DELIVERED` always reads "delivered"; short of that, the headline names
/// how the order was paid for, since [OrderCardKind.confirmed] alone
/// conflates "already paid" (DIRECT) with "never billed to the client at
/// all" (DEFERRED/CREDIT) — a distinction the client needs stated plainly,
/// not folded into one generic "confirmed" label.
String settledHeadlineKeyFor(OrderStatus status, PaymentMethod method) {
  if (status == OrderStatus.delivered) return OrderDetailKeys.headlineDelivered;
  return switch (method) {
    PaymentMethod.direct => OrderDetailKeys.headlinePaid,
    PaymentMethod.deferred => OrderDetailKeys.headlineDeferred,
    PaymentMethod.credit => OrderDetailKeys.headlineCredit,
  };
}

OrderCardKind cardKindFor(OrderStatus status, PaymentMethod method) => switch (status) {
  OrderStatus.pendingApproval => OrderCardKind.pendingApproval,
  // A DEFERRED/CREDIT order DOES rest here, and reading it as "confirmed"
  // was the defect: routing — not approval — is what prices the transport
  // leg, and it parks EVERY payment method at PENDING_PAYMENT awaiting the
  // station owner (orders.controller.ts's manual-route guard says so in as
  // many words). Shown as confirmed, the client was told the order was
  // settled at precisely the moment the platform was blocked on them, and
  // the order could never advance because the screen offered no way to
  // accept.
  OrderStatus.pendingPayment => method == PaymentMethod.direct
      ? OrderCardKind.awaitingPayment
      : OrderCardKind.awaitingAcceptance,
  OrderStatus.approved ||
  OrderStatus.awaitingRouting ||
  OrderStatus.routedToTransport ||
  OrderStatus.assignedToDriver => OrderCardKind.confirmed,
  OrderStatus.loading ||
  OrderStatus.inTransit ||
  OrderStatus.unloading => OrderCardKind.inTransit,
  OrderStatus.delivered => OrderCardKind.delivered,
  OrderStatus.rejected || OrderStatus.cancelled => OrderCardKind.cancelled,
};
