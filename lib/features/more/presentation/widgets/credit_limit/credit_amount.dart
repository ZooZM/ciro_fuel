// `hide TextDirection`: easy_localization re-exports intl, whose
// TextDirection would shadow the one this widget forces the figure into.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/number_formatting.dart';

/// A credit figure and its currency, laid out either side by side (the
/// submitted request) or stacked (the stepper).
///
/// The grouped figure is forced left-to-right: '200,000.00' reads the same
/// way in Arabic, and letting it inherit the page's RTL moves the separators.
class CreditAmount extends StatelessWidget {
  const CreditAmount({
    required this.amount,
    required this.color,
    this.stacked = false,
    super.key,
  });

  final double amount;
  final Color color;

  /// Stacks the currency under the figure and greys it, as the stepper draws
  /// it. Otherwise both sit on one line in [color].
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final figure = Text(
      NumberFormatting.currency(amount),
      textDirection: TextDirection.ltr,
      style: TextStyle(
        fontSize: AppFontSizes.displayLarge,
        fontWeight: FontWeight.w800,
        color: color,
      ),
    );
    final currency = Text(
      OrdersKeys.currency.tr(),
      style: TextStyle(
        fontSize: stacked ? AppFontSizes.footnote : AppFontSizes.title,
        fontWeight: stacked ? FontWeight.normal : FontWeight.w600,
        color: stacked ? AppColors.mutedLabel : color,
      ),
    );

    if (stacked) {
      return Column(
        children: [figure, const SizedBox(height: AppSpacing.xxs), currency],
      );
    }
    return Row(
      children: [figure, const SizedBox(width: AppSpacing.sm), currency],
    );
  }
}
