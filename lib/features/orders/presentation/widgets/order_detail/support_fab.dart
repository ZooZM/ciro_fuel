import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// The floating "الدعم" pill anchored over the order-detail screen.
class SupportFab extends StatelessWidget {
  const SupportFab({super.key});

  static const _shadowOpacity = 0.2;
  static const _shadowBlur = 10.0;
  static const _shadowOffset = Offset(0, 4);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.orderPrimaryActionHeight,
      decoration: BoxDecoration(
        color: context.colors.brandBlue,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: _shadowOpacity),
            blurRadius: _shadowBlur,
            offset: _shadowOffset,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.tile),
          onTap: () => context.push(AppRoutes.support),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Text(
                  OrderDetailKeys.support.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppFontSizes.bodyLarge,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const Icon(
                const SizedBox(width: AppSpacing.md),
                const Icon(
                  Icons.headset_mic_outlined,
                  color: Colors.white,
                  size: AppSizes.iconLg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
