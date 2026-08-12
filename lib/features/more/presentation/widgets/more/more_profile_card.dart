import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// The header of the المزيد screen: the client's photo, name, station count
/// and account code, tapping through to their profile.
class MoreProfileCard extends StatelessWidget {
  const MoreProfileCard({
    required this.name,
    required this.stationCountLabel,
    required this.code,
    required this.onTap,
    super.key,
  });

  final String name;
  final String stationCountLabel;
  final String code;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.greenTint,
          borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
          border: Border.all(
            color: AppColors.successGreen.withValues(
              alpha: AppSizes.moreProfileBorderOpacity,
            ),
          ),
        ),
        child: Row(
          children: [
            // First child, so on this right-to-left page the photo takes the
            // right edge and the chevron the left.
            Container(
              width: AppSizes.moreProfileImageSize,
              height: AppSizes.moreProfileImageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
                image: const DecorationImage(
                  image: AssetImage(AppAssets.moreProfileImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: AppFontSizes.displayLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slateCharcoal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    stationCountLabel,
                    style: const TextStyle(
                      fontSize: AppFontSizes.bodyLarge,
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _CodePill(code: code),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.forestGreen,
              size: AppSizes.iconLg,
            ),
          ],
        ),
      ),
    );
  }
}

/// The account code, set in a white pill inside the tinted card.
class _CodePill extends StatelessWidget {
  const _CodePill({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space14,
        vertical: AppSpacing.space6,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        border: Border.all(
          color: AppColors.successGreen.withValues(
            alpha: AppSizes.moreProfileBorderOpacity,
          ),
        ),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontSize: AppFontSizes.footnote,
          fontWeight: FontWeight.w600,
          color: AppColors.forestGreen,
        ),
      ),
    );
  }
}
