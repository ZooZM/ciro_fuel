import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// The form's heading: "طلب وقود جديد" and its subtitle.
class OrderTitle extends StatelessWidget {
  const OrderTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
    return Column(
      children: [
        Text(
          CreateOrderKeys.title.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: AppFontSizes.display,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        const SizedBox(height: AppSpacing.xs),
        Text(
          CreateOrderKeys.subtitle.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.grey,
            fontSize: AppFontSizes.footnote,
          ),
        ),
      ],
    );
  }
}
