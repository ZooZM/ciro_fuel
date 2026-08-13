import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/theme/theme_context.dart';

/// The order-status card while the order is still awaiting review — just
/// a headline and a cancel action.
class PendingOrderStatusCard extends StatelessWidget {
  const PendingOrderStatusCard({
    this.orderReference,
    this.onCancel,
    super.key,
  });

  final String? orderReference;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final resolvedReference = orderReference ?? 
        (isAr ? 'ORD-2024-256 · 9 أغسطس 2024' : 'ORD-2024-256 · 9 August 2024');

    return OrderCard(
      title: OrderDetailKeys.orderStatus.tr(),
      subtitle: resolvedReference,
      trailing: Text(
        OrderDetailKeys.pendingReview.tr(),
        style: TextStyle(
          color: context.colors.brandBlue,
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
                side: BorderSide(color: context.colors.borderHairline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
              ),
              child: Text(
                CommonKeys.cancel.tr(),
                style: TextStyle(
                  color: context.colors.brandBlue,
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
