import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/widgets/order_flow.dart';
import '../../../../../core/theme/theme_context.dart';

/// "مراحل الطلب" — the order-flow stepper.
class TrackingTimelineCard extends StatelessWidget {
  const TrackingTimelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TrackOrderKeys.orderStages.tr(),
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const OrderFlow(),
        ],
      ),
    );
  }
}
