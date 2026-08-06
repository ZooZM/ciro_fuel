import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/order_flow.dart';
import '../constants/client_home_strings.dart';
import 'order_action_buttons.dart';
import 'order_info_row.dart';
import 'order_progress_ring.dart';

/// Everything known about the client's in-flight order, as shown on the
/// dashboard's current-order card.
class CurrentOrderSummary {
  const CurrentOrderSummary({
    required this.fuelType,
    required this.quantity,
    required this.statusLabel,
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
    required this.onTrackOrder,
    required this.onContactDriver,
    super.key,
  });

  final CurrentOrderSummary order;
  final VoidCallback onTrackOrder;
  final VoidCallback onContactDriver;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
        border: Border.all(color: AppColors.itemBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(fuelType: order.fuelType, quantity: order.quantity, statusLabel: order.statusLabel),
            const SizedBox(height: AppSpacing.lg),
            _MiddleSection(order: order),
            const SizedBox(height: AppSpacing.xl),
            const OrderFlow(),
            const SizedBox(height: AppSpacing.xl),
            OrderActionButtons(
              onTrackOrder: onTrackOrder,
              onContactDriver: onContactDriver,
            ),
          ],
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
  });

  final String fuelType;
  final String quantity;
  final String statusLabel;

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
              style: const TextStyle(color: AppColors.grey, fontSize: 10),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              quantity,
              style: const TextStyle(
                color: AppColors.navy,
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
            color: AppColors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.dashboardOrderStatusDotSize,
                height: AppSizes.dashboardOrderStatusDotSize,
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSizes.dashboardOrderStatusDotSize),
              Text(
                statusLabel,
                style: const TextStyle(
                  color: AppColors.green,
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
                label: ClientHomeStrings.driverLabel,
                value: order.driverName,
              ),
              const SizedBox(height: AppSpacing.sm),
              OrderInfoRow(
                asset: AppAssets.dashboardLorryIcon,
                label: ClientHomeStrings.truckLabel,
                value: order.truckPlate,
              ),
            ],
          ),
        ),

        OrderProgressRing(progress: order.progress, etaMinutes: order.etaMinutes),

        // Order ID + date/time (LEFT in RTL = end)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                order.orderId,
                style: const TextStyle(
                  color: AppColors.navy,
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
                    style: const TextStyle(color: AppColors.grey, fontSize: 10),
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
                    style: const TextStyle(color: AppColors.grey, fontSize: 10),
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
              const Text(
                ClientHomeStrings.orderTimeLabel,
                style: TextStyle(color: AppColors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
