import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/widgets/order_flow.dart';

/// "مراحل الطلب" — the order-flow stepper.
class TrackingTimelineCard extends StatelessWidget {
  const TrackingTimelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderCard(
    return OrderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TrackOrderKeys.orderStages.tr(),
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: AppFontSizes.footnote,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const OrderFlow(),
          const SizedBox(height: AppSpacing.lg),
          const OrderFlow(),
        ],
      ),
    );
  }
}
