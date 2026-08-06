import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../constants/client_home_strings.dart';

/// The current-order card's two actions: track on map, and contact the
/// driver.
///
/// Given a shared height and label widget so the two line up — they
/// previously differed in text scale and icon gap and so did not match.
class OrderActionButtons extends StatelessWidget {
  const OrderActionButtons({
    required this.onTrackOrder,
    required this.onContactDriver,
    super.key,
  });

  final VoidCallback onTrackOrder;
  final VoidCallback onContactDriver;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.dashboardActionButtonHeight,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onTrackOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.dashboardActionButtonPaddingH,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppSizes.dashboardActionButtonRadius,
                  ),
                ),
                elevation: 0,
              ),
              child: const _ActionButtonLabel(
                asset: AppAssets.dashboardMapIcon,
                label: ClientHomeStrings.trackOnMap,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: OutlinedButton(
              onPressed: onContactDriver,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.dashboardActionButtonPaddingH,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppSizes.dashboardActionButtonRadius,
                  ),
                ),
                side: const BorderSide(color: AppColors.itemBorder),
              ),
              child: const _ActionButtonLabel(
                asset: AppAssets.phoneIcon,
                label: ClientHomeStrings.contactDriver,
                color: AppColors.navy,
                iconColor: AppColors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared contents for the two action buttons, so they keep the same icon
/// size, gap and text scale. The label is [Flexible] because
/// 'تتبع الطلب على الخريطة' is long enough to overflow at half the card
/// width.
class _ActionButtonLabel extends StatelessWidget {
  const _ActionButtonLabel({
    required this.asset,
    required this.label,
    required this.color,
    this.iconColor,
  });

  final String asset;
  final String label;
  final Color color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          asset,
          width: AppSizes.dashboardActionButtonIconSize,
          height: AppSizes.dashboardActionButtonIconSize,
          colorFilter: ColorFilter.mode(iconColor ?? color, BlendMode.srcIn),
        ),
        const SizedBox(width: AppSizes.dashboardActionButtonIconGap),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
