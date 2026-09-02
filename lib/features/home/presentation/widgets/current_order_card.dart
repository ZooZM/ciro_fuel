import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/order_flow.dart';
import '../../../../core/localization/translation_keys.dart';
import 'order_action_buttons.dart';
import 'order_info_row.dart';
import 'order_progress_ring.dart';
import '../../../../core/theme/theme_context.dart';

/// Everything known about the client's in-flight order, as shown on the
/// dashboard's current-order card.
class CurrentOrderSummary {
  const CurrentOrderSummary({
    required this.fuelType,
    required this.quantity,
    required this.statusLabel,
    required this.statusColor,
    required this.flowStep,
    required this.isTrackable,
    required this.driverName,
    required this.truckPlate,
    required this.progress,
    required this.etaMinutes,
    required this.orderId,
    required this.orderDate,
    required this.orderTime,
  });

  final String fuelType;
  final String quantity;
  final String statusLabel;

  /// The design's colour for this exact status — the badge is not always
  /// green, and an order still under review must not look accepted.
  final Color statusColor;

  /// How far along the delivery timeline this order actually is.
  final OrderFlowStep flowStep;

  /// Whether the track/contact actions apply yet.
  final bool isTrackable;

  final String driverName;
  final String truckPlate;

  /// 0.0-1.0 fraction of the delivery journey completed.
  final double progress;
  final String etaMinutes;
  final String orderId;
  final String orderDate;
  final String orderTime;
}

/// The dashboard's "طلبك الحالي" card: fuel/status header, driver and
/// truck details either side of the delivery progress ring, the order
/// flow stepper, and the two action buttons.
class CurrentOrderCard extends StatelessWidget {
  const CurrentOrderCard({
    required this.order,
    required this.onOpenOrder,
    required this.onTrackOrder,
    required this.onContactDriver,
    super.key,
  });

  final CurrentOrderSummary order;

  /// Opens the order's own screen. The whole card is the target, not just
  /// the buttons: those are withheld until the order is on the way, so
  /// without this there is no way into the order from the dashboard for
  /// most of its life.
  final VoidCallback onOpenOrder;

  final VoidCallback onTrackOrder;
  final VoidCallback onContactDriver;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
        border: Border.all(color: context.colors.borderHairline),
      ),
      // The inner buttons keep their own taps — a nested gesture wins over
      // this one, so "Track order" still tracks rather than merely opening.
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
          onTap: onOpenOrder,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              fuelType: order.fuelType,
              quantity: order.quantity,
              statusLabel: order.statusLabel,
              statusColor: order.statusColor,
            ),
            const SizedBox(height: AppSpacing.lg),
            _MiddleSection(order: order),
            const SizedBox(height: AppSpacing.xl),
            OrderFlow(current: order.flowStep),
            // Tracking the truck and calling its driver only mean anything
            // once the order is on the way; before that there is no driver
            // and no position, so the actions are withheld rather than
            // offered and then failing.
            if (order.isTrackable) ...[
                  const SizedBox(height: AppSpacing.xl),
                  OrderActionButtons(
                    onTrackOrder: onTrackOrder,
                    onContactDriver: onContactDriver,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fuel type on the right, status badge on the left. In RTL the first
/// child renders right-most.
class _Header extends StatelessWidget {
  const _Header({
    required this.fuelType,
    required this.quantity,
    required this.statusLabel,
    required this.statusColor,
  });

  final String fuelType;
  final String quantity;
  final String statusLabel;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fuelType,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              quantity,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSizes.dashboardOrderStatusBadgePaddingV,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.dashboardOrderStatusDotSize,
                height: AppSizes.dashboardOrderStatusDotSize,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSizes.dashboardOrderStatusDotSize),
              Text(
                statusLabel,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiddleSection extends StatelessWidget {
  const _MiddleSection({required this.order});

  final CurrentOrderSummary order;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Driver + truck info (RIGHT in RTL = start)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderInfoRow(
                asset: AppAssets.dashboardDriverIcon,
                label: CommonKeys.driver.tr(),
                value: order.driverName,
              ),
              const SizedBox(height: AppSpacing.sm),
              OrderInfoRow(
                asset: AppAssets.dashboardLorryIcon,
                label: CommonKeys.truck.tr(),
                value: order.truckPlate,
              ),
            ],
          ),
        ),

        OrderProgressRing(
          progress: order.progress,
          etaMinutes: order.etaMinutes,
        ),

        // Order ID + date/time (LEFT in RTL = end)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                order.orderId,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    order.orderDate,
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  SvgPicture.asset(
                    AppAssets.dashboardDateIcon,
                    width: AppSizes.dashboardOrderDateHourIconSize,
                    height: AppSizes.dashboardOrderDateHourIconSize,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.dashboardOrderMetaRowGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    order.orderTime,
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  SvgPicture.asset(
                    AppAssets.dashboardHourIcon,
                    width: AppSizes.dashboardOrderDateHourIconSize,
                    height: AppSizes.dashboardOrderDateHourIconSize,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                HomeKeys.orderTimeLabel.tr(),
                style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
