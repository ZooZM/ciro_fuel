import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'credit_check_box.dart';

/// One thing the client has to acknowledge before the request can go through:
/// its title, the paragraph itself, and the tick.
///
/// The whole block is the tap target, not just the box — the paragraph is
/// several lines tall and aiming at a 28pt square beside it is fiddly.
class CreditAcknowledgement extends StatelessWidget {
  const CreditAcknowledgement({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppRadii.tile),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CreditLimitKeys.acknowledgementTitle.tr(),
                  style: const TextStyle(
                    fontSize: AppFontSizes.subtitle,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                const SizedBox(height: AppSpacing.space6),
                Text(
                  CreditLimitKeys.acknowledgementBody.tr(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: AppFontSizes.footnote,
                    height: AppSizes.creditAcknowledgementLineHeight,
                    color: AppColors.mutedLabel,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Nudged down so the box lines up with the title rather than the
          // whole two-paragraph block.
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxs),
            child: CreditCheckBox(value: value),
          ),
        ],
      ),
    );
  }
}
