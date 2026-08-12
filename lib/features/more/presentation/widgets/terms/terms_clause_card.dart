import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../constants/terms_clauses.dart';

/// A single clause: its number badge and title, then the text itself.
class TermsClauseCard extends StatelessWidget {
  const TermsClauseCard({required this.clause, super.key});

  final TermsClause clause;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.clauseFill,
        borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
        border: Border.all(color: AppColors.clauseBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Badge first so it sits to the right of the title in RTL.
              _NumberBadge(number: clause.number),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  clause.title,
                  style: const TextStyle(
                    fontSize: AppFontSizes.heading,
                    fontWeight: FontWeight.w800,
                    color: AppColors.heading,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space14),
          Text(
            clause.body,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: AppFontSizes.body,
              height: AppSizes.termsClauseLineHeight,
              color: AppColors.mutedLabel,
            ),
          ),
        ],
      ),
    );
  }
}

/// The clause's number, set in a near-white blue box inside the green card.
class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.clauseBadgeFill,
        borderRadius: BorderRadius.circular(AppRadii.badge),
        border: Border.all(
          color: AppColors.blue.withValues(alpha: AppSizes.clauseBadgeOpacity),
        ),
      ),
      child: Text(
        number,
        style: const TextStyle(
          fontSize: AppFontSizes.title,
          fontWeight: FontWeight.w800,
          color: AppColors.blue,
        ),
      ),
    );
  }
}
