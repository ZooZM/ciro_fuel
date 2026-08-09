import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_mock_data.dart';
import 'mock_order_state.dart';

/// The plain status card carried by every state that already has a
/// receipt (deferred, paid, delivered). Only delivery adds a follow-up
/// action.
class SettledOrderStatusCard extends StatelessWidget {
  const SettledOrderStatusCard({
    required this.state,
    this.orderReference = OrderMockData.orderReference,
    this.onOrderAnother,
    super.key,
  });

  final MockOrderState state;
  final String orderReference;
  final VoidCallback? onOrderAnother;

  static const _headlineKeys = {
    MockOrderState.deferred: OrderDetailKeys.headlineDeferred,
    MockOrderState.paid: OrderDetailKeys.headlinePaid,
    MockOrderState.delivered: OrderDetailKeys.headlineDelivered,
  };

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      title: OrderDetailKeys.orderStatus.tr(),
      subtitle: orderReference,
      trailing: Text(
        _headlineKeys[state]!.tr(),
        style: TextStyle(
          color: state == MockOrderState.deferred
              ? AppColors.warningOrange
              : AppColors.blue,
          fontSize: AppFontSizes.bodyLarge,
          fontWeight: FontWeight.w800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state == MockOrderState.delivered) ...[
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: AppSizes.secondaryButtonHeight,
              child: OutlinedButton.icon(
                onPressed: onOrderAnother ?? () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.itemBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.tile),
                  ),
                ),
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.green,
                  size: AppSizes.iconMd,
                ),
                label: Text(
                  OrderDetailKeys.orderAnother.tr(),
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: AppFontSizes.bodyLarge,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
