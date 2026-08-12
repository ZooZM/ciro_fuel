import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// The tinted pill on a credit card's title row — غير متاح on the current
/// limit, قيد المراجعة on a submitted request.
class CreditStatusPill extends StatelessWidget {
  const CreditStatusPill({
    required this.label,
    required this.color,
    required this.background,
    super.key,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space14,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.badge),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppFontSizes.footnote,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
