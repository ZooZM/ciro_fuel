import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/theme_context.dart';

/// The prominent "طلب وقود جديد" call-to-action.
class NewRequestButton extends StatelessWidget {
  const NewRequestButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.brandBlue,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        boxShadow: [
          BoxShadow(
            color: context.colors.brandBlue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.tile),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSizes.dashboardNewRequestButtonPaddingH,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  AppAssets.dashboardAddIcon,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  width: AppSizes.dashboardNewRequestIconSize,
                  height: AppSizes.dashboardNewRequestIconSize,
                ),
                Text(
                  HomeKeys.newFuelRequest.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SvgPicture.asset(
                  AppAssets.dashboardGasStationIcon,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  width: AppSizes.dashboardNewRequestGasIconSize,
                  height: AppSizes.dashboardNewRequestGasIconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
