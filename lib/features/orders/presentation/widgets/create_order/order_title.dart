import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';

/// The form's heading: "طلب وقود جديد" and its subtitle.
class OrderTitle extends StatelessWidget {
  const OrderTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          CreateOrderKeys.title.tr(),
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          CreateOrderKeys.subtitle.tr(),
          style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}
