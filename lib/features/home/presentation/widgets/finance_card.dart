import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/theme_context.dart';

/// One of the two balance/invoice tiles above the "new request" button.
class FinanceCard extends StatelessWidget {
  const FinanceCard({
    required this.label,
    required this.amount,
    required this.asset,
    super.key,
  });

  final String label;
  final String amount;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(color: context.colors.borderHairline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
                ),
                const SizedBox(height: AppSpacing.xs),
                // Text.rich, not RichText: RichText ignores
                // DefaultTextStyle, so the amount would fall back to the
                // platform font instead of the app's Tajawal.
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$amount ',
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: CommonKeys.riyal.tr(),
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            asset,
            width: AppSizes.dashboardFinanceIconSize,
            height: AppSizes.dashboardFinanceIconSize,
          ),
        ],
      ),
    );
  }
}
