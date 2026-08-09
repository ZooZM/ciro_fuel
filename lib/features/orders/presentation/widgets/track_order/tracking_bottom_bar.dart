import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// The sticky "تم الاستلام" / "تواصل مع الدعم" action row.
class TrackingBottomBar extends StatelessWidget {
  const TrackingBottomBar({this.onReceived, this.onContactSupport, super.key});

  final VoidCallback? onReceived;
  final VoidCallback? onContactSupport;

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
                label: Text(
                  TrackOrderKeys.received.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppFontSizes.bodyLarge,
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
                  width: AppSizes.icon16,
                  height: AppSizes.icon16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blue,
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(
                  TrackOrderKeys.contactSupport.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: AppFontSizes.micro,
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
