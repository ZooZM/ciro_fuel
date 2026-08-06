import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../constants/client_home_strings.dart';

/// The circular delivery-progress indicator at the centre of the current
/// order card, with the ETA lettered inside it.
class OrderProgressRing extends StatelessWidget {
  const OrderProgressRing({
    required this.progress,
    required this.etaMinutes,
    super.key,
  });

  /// 0.0-1.0 fraction of the delivery journey completed.
  final double progress;
  final String etaMinutes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.dashboardOrderProgressDiameter,
      height: AppSizes.dashboardOrderProgressDiameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: AppSizes.dashboardOrderProgressDiameter,
            height: AppSizes.dashboardOrderProgressDiameter,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: AppColors.itemBorder,
              color: AppColors.green,
              strokeWidth: AppSizes.dashboardOrderProgressStrokeWidth,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppAssets.dashboardTruckIcon,
                width: AppSizes.dashboardOrderTruckIconSize,
                height: AppSizes.dashboardOrderTruckIconSize,
                colorFilter: const ColorFilter.mode(
                  AppColors.navy,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                ClientHomeStrings.arrivalIn,
                style: TextStyle(color: AppColors.grey, fontSize: 8),
              ),
              Text(
                etaMinutes,
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
              const Text(
                ClientHomeStrings.minutes,
                style: TextStyle(color: AppColors.green, fontSize: 8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
