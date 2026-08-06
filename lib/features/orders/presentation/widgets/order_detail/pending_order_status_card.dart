import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_detail_strings.dart';

/// The order-status card while the order is still awaiting review — just
/// a headline and a cancel action.
class PendingOrderStatusCard extends StatelessWidget {
  const PendingOrderStatusCard({
    this.orderReference = 'ORD-2024-256 · 9 صفر 1448',
    this.onCancel,
    super.key,
  });

  final String orderReference;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      title: OrderDetailStrings.orderStatus,
      subtitle: orderReference,
      trailing: const Text(
        OrderDetailStrings.pendingReview,
        style: TextStyle(
          color: AppColors.blue,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: AppSizes.secondaryButtonHeight,
            child: OutlinedButton(
              onPressed: onCancel ?? () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.itemBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
              ),
              child: const Text(
                OrderDetailStrings.cancel,
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
