import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';

/// The floating "الدعم" pill anchored over the order-detail screen.
class SupportFab extends StatelessWidget {
  const SupportFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.orderPrimaryActionHeight,
      decoration: BoxDecoration(
        color: context.colors.brandBlue,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        boxShadow: [
          BoxShadow(
            color: context.colors.brandBlue.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
            child: Row(
              children: [
                Text(
                  CommonKeys.support.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
