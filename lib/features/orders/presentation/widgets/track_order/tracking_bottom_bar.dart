import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../constants/track_order_strings.dart';

/// The sticky "تم الاستلام" / "تواصل مع الدعم" action row.
class TrackingBottomBar extends StatelessWidget {
  const TrackingBottomBar({this.onReceived, this.onContactSupport, super.key});

  final VoidCallback? onReceived;
  final VoidCallback? onContactSupport;

  static const _supportIconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        AppSpacing.lg,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 65,
            child: SizedBox(
              height: AppSizes.orderPrimaryActionHeight,
              child: FilledButton.icon(
                onPressed: onReceived ?? () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.orderTransitButtonPaddingH,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.tile),
                  ),
                ),
                icon: const Icon(
                  Icons.check_circle_outline,
                  size: AppSizes.iconMd,
                  color: Colors.white,
                ),
                label: const Text(
                  TrackOrderStrings.received,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 35,
            child: SizedBox(
              height: AppSizes.orderPrimaryActionHeight,
              child: OutlinedButton.icon(
                onPressed: onContactSupport ?? () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.itemBorder),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.orderTransitButtonPaddingH,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.tile),
                  ),
                ),
                icon: SvgPicture.asset(
                  AppAssets.supportIcon,
                  width: _supportIconSize,
                  height: _supportIconSize,
                  colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                ),
                label: const Text(
                  TrackOrderStrings.contactSupport,
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
