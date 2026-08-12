import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../../../shared/enums/order_status.dart';

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
    OrderStatus.assignedToDriver => OrderStatusKeys.assignedToDriver,
    OrderStatus.pendingPayment => OrderStatusKeys.pendingPayment,
    OrderStatus.inTransit => OrderStatusKeys.inTransit,
    OrderStatus.unloading => OrderStatusKeys.unloading,
    OrderStatus.delivered => OrderStatusKeys.delivered,
    OrderStatus.rejected => OrderStatusKeys.rejected,
    OrderStatus.cancelled => OrderStatusKeys.cancelled,
  };

  static Color statusColor(OrderStatus status) => switch (status) {
    OrderStatus.pendingApproval => _slate,
    OrderStatus.approved || OrderStatus.assignedToDriver => _green,
    OrderStatus.pendingPayment => _orange,
    OrderStatus.inTransit || OrderStatus.unloading => _blue,
    OrderStatus.delivered => _green,
    OrderStatus.rejected || OrderStatus.cancelled => _red,
  };

  /// Fraction of the ring to fill. The two terminal failure states show a
  /// full ring in red rather than an arbitrary partial one — the order
  /// stopped there, it did not stall mid-way.
  static double statusProgress(OrderStatus status) => switch (status) {
    OrderStatus.pendingApproval => 0.15,
    OrderStatus.approved => 0.35,
    OrderStatus.assignedToDriver => 0.5,
    OrderStatus.pendingPayment => 0.6,
    OrderStatus.inTransit => 0.75,
    OrderStatus.unloading => 0.9,
    OrderStatus.delivered => 1,
    OrderStatus.rejected || OrderStatus.cancelled => 1,
  };

  static String fuelLabel(FuelType fuelType) => switch (fuelType) {
    FuelType.diesel => FuelTypeKeys.diesel,
    FuelType.gasoline91 => FuelTypeKeys.gasoline91,
    FuelType.gasoline95 => FuelTypeKeys.gasoline95,
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
    final addressText = order.deliveryAddressText;
    if (addressText != null && addressText.isNotEmpty) return addressText;

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
    OrderStatus.assignedToDriver,
  }),
  awaitingPayment(OrdersKeys.filterAwaitingPayment, {
    OrderStatus.pendingPayment,
  }),
  inDelivery(OrdersKeys.filterInDelivery, {
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
