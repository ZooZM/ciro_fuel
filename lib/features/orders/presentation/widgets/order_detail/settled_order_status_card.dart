import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import 'mock_order_state.dart';
import '../../../../../core/theme/theme_context.dart';

/// The plain status card carried by every state that already has a
/// receipt (deferred, paid, delivered). Only delivery adds a follow-up
/// action.
class SettledOrderStatusCard extends StatelessWidget {
  const SettledOrderStatusCard({
    required this.state,
    this.orderReference,
    super.key,
  });

  final MockOrderState state;
  final String? orderReference;

  // Keys, not copy — translated where the headline is drawn so it follows a
  // locale switch.
  static const _headlineKeys = {
    MockOrderState.deferred: OrderDetailKeys.headlineDeferred,
    MockOrderState.paid: OrderDetailKeys.headlinePaid,
    MockOrderState.delivered: OrderDetailKeys.headlineDelivered,
  };

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final resolvedReference = orderReference ?? 
        (isAr ? 'ORD-2024-256 · 9 صفر 1446' : 'ORD-2024-256 · 9 Safar 1446');

    return OrderCard(
      title: OrderDetailKeys.orderStatus.tr(),
      subtitle: resolvedReference,
      trailing: Text(
        _headlineKeys[state]!.tr(),
        style: TextStyle(
          color: state == MockOrderState.deferred
              ? context.colors.brandOrange
              : context.colors.brandBlue,
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
                  side: BorderSide(color: context.colors.borderHairline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.tile),
                  ),
                ),
                icon: Icon(
                  Icons.refresh,
                  color: context.colors.brandGreen,
                  size: AppSizes.iconMd,
                ),
                label: Text(
                  OrderDetailKeys.orderAnother.tr(),
                  style: TextStyle(
                    color: context.colors.brandGreen,
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
