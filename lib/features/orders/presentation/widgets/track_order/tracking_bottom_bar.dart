import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';

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
      color: context.colors.surface,
      child: Row(
        children: [
          Expanded(
            flex: 65,
            child: SizedBox(
              height: AppSizes.orderPrimaryActionHeight,
              child: FilledButton.icon(
                onPressed: onReceived ?? () {},
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.brandBlue,
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
                  style: const TextStyle(
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
                  side: BorderSide(color: context.colors.borderHairline),
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
                  colorFilter: ColorFilter.mode(
                    context.colors.brandBlue,
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(
                  CommonKeys.contactSupport.tr(),
                  maxLines: 1,
                  style: TextStyle(
                    color: context.colors.brandBlue,
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
