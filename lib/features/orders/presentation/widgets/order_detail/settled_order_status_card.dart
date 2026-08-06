import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_detail_strings.dart';
import 'mock_order_state.dart';

/// The plain status card carried by every state that already has a
/// receipt (deferred, paid, delivered). Only delivery adds a follow-up
/// action.
class SettledOrderStatusCard extends StatelessWidget {
  const SettledOrderStatusCard({
    required this.state,
    this.orderReference = 'ORD-2024-256 · 9 صفر 1448',
    super.key,
  });

  final MockOrderState state;
  final String orderReference;

  static const _headlines = {
    MockOrderState.deferred: OrderDetailStrings.headlineDeferred,
    MockOrderState.paid: OrderDetailStrings.headlinePaid,
    MockOrderState.delivered: OrderDetailStrings.headlineDelivered,
  };

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      title: OrderDetailStrings.orderStatus,
      subtitle: orderReference,
      trailing: Text(
        _headlines[state]!,
        style: TextStyle(
          color: state == MockOrderState.deferred
              ? AppColors.warningOrange
              : AppColors.blue,
          fontSize: 14,
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
                onPressed: () {},
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
                label: const Text(
                  OrderDetailStrings.orderAnother,
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 14,
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
