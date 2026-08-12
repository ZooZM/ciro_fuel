import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/theme_context.dart';

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
                backgroundColor: context.colors.brandBlue,
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
              child: _ActionButtonLabel(
                asset: AppAssets.dashboardMapIcon,
                label: CommonKeys.trackOnMap.tr(),
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
                side: BorderSide(color: context.colors.borderHairline),
              ),
              child: _ActionButtonLabel(
                asset: AppAssets.phoneIcon,
                label: CommonKeys.contactDriver.tr(),
                color: context.colors.textPrimary,
                iconColor: context.colors.textSecondary,
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
