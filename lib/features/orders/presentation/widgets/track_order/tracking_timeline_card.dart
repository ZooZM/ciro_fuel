import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/widgets/order_flow.dart';
import '../../constants/track_order_strings.dart';

/// "مراحل الطلب" — the order-flow stepper.
class TrackingTimelineCard extends StatelessWidget {
  const TrackingTimelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TrackOrderStrings.orderStages,
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          OrderFlow(),
        ],
      ),
    );
  }
}
