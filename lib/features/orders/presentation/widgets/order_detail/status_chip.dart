import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// The muted pill the design uses for an order's headline state — قيد
/// التوصيل, تم التأكيد, الفاتورة معلقة.
class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {this.color = AppColors.navy, super.key});

  final String label;

  /// Ink for the label. Most states read navy; قيد التوصيل is called out.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSizes.orderChipPaddingV,
      ),
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(AppSizes.orderChipRadius),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: AppFontSizes.body,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
