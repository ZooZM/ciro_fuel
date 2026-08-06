import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../constants/create_order_strings.dart';

/// The form's heading: "طلب وقود جديد" and its subtitle.
class OrderTitle extends StatelessWidget {
  const OrderTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          CreateOrderStrings.title,
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          CreateOrderStrings.subtitle,
          style: TextStyle(color: AppColors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
