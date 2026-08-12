import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../constants/terms_clauses.dart';

/// The table of contents above the clauses — one row per clause, plainly
/// numbered rather than badged like the clause cards themselves.
class TermsContentsCard extends StatelessWidget {
  const TermsContentsCard({required this.clauses, this.onClauseTap, super.key});

  final List<TermsClause> clauses;

  /// Given the clause's zero-based index. Null while the rows are inert —
  /// the document is short enough to scroll by hand for now.
  final ValueChanged<int>? onClauseTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.field),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(
        children: [
          for (final (index, clause) in clauses.indexed) ...[
            if (index > 0)
              const Divider(
                height: AppSizes.dividerThickness,
                thickness: AppSizes.dividerThickness,
                color: AppColors.track,
              ),
            _ContentsRow(
              label: '${index + 1}.  ${clause.title}',
              onTap: onClauseTap == null ? null : () => onClauseTap!(index),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContentsRow extends StatelessWidget {
  const _ContentsRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.space18,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: AppFontSizes.subtitle,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // chevron_left is a matchTextDirection icon, so it would mirror
            // and point right on this RTL page.
            const Directionality(
              textDirection: TextDirection.ltr,
              child: Icon(
                Icons.chevron_left,
                size: AppSizes.icon22,
                color: AppColors.disabledInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
