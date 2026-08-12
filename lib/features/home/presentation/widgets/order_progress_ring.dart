import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/theme_context.dart';

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
              backgroundColor: context.colors.borderHairline,
              color: context.colors.brandGreen,
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
                colorFilter: ColorFilter.mode(
                  context.colors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                CommonKeys.arrivalIn.tr(),
                style: TextStyle(color: context.colors.textSecondary, fontSize: 8),
              ),
              Text(
                etaMinutes,
                style: TextStyle(
                  color: context.colors.brandGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
              Text(
                CommonKeys.minutes.tr(),
                style: TextStyle(color: context.colors.brandGreen, fontSize: 8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
