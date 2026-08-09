import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_mock_data.dart';

/// The order-status card while the order is still awaiting review — just
/// a headline and a cancel action.
class PendingOrderStatusCard extends StatelessWidget {
  const PendingOrderStatusCard({
    this.orderReference = OrderMockData.orderReference,
    this.onCancel,
    super.key,
  });

  final String orderReference;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      title: OrderDetailKeys.orderStatus.tr(),
      subtitle: orderReference,
      trailing: Text(
        OrderDetailKeys.pendingReview.tr(),
        style: const TextStyle(
          color: AppColors.blue,
          fontSize: AppFontSizes.subtitle,
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
              child: Text(
                OrderDetailKeys.cancel.tr(),
                style: const TextStyle(
                  color: AppColors.blue,
                  fontSize: AppFontSizes.bodyLarge,
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
