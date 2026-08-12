import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'credit_icon_tile.dart';
import 'credit_status_pill.dart';

/// What the client has today: nothing, until the petrol company grants a
/// limit. The card is the screen's header in either case, so the empty state
/// lives inside it rather than replacing it.
class CreditLimitCard extends StatelessWidget {
  const CreditLimitCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CreditIconTile(
                background: AppColors.orangeTint,
                color: AppColors.ignitionOrange,
                size: AppSizes.creditIconTileSize,
                iconSize: AppSizes.iconLg,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                CreditLimitKeys.title.tr(),
                style: const TextStyle(
                  fontSize: AppFontSizes.titleLarge,
                  fontWeight: FontWeight.w800,
                  color: AppColors.heading,
                ),
              ),
              const Spacer(),
              CreditStatusPill(
                label: CreditLimitKeys.unavailable.tr(),
                color: AppColors.red,
                background: AppColors.redTint,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space28),
          // Empty state — there is no limit to show yet.
          const CreditIconTile(
            background: AppColors.redTint,
            color: AppColors.red,
            size: AppSizes.creditEmptyIconTileSize,
            iconSize: AppSizes.icon24,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            CreditLimitKeys.emptyState.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFontSizes.body,
              color: AppColors.mutedLabel,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
