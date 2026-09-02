import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_presentation.dart';
import '../../../../../shared/enums/order_status.dart';
import '../../../../../shared/enums/payment_method.dart';
import '../../../../../core/theme/theme_context.dart';

/// The plain status card carried by every state that already has a
/// receipt (deferred, credit, paid, delivered). Only delivery adds a
/// follow-up action.
class SettledOrderStatusCard extends StatelessWidget {
  const SettledOrderStatusCard({
    required this.status,
    required this.paymentMethod,
    required this.orderReference,
    this.onRedispatch,
    super.key,
  });

  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final String orderReference;

  /// Set only for a DIRECT order reverted to APPROVED after a payment
  /// timeout (`order-state.service.ts`/FR-015a) — the one case a DIRECT
  /// order genuinely rests at APPROVED, and the only one `POST
  /// /orders/:id/redispatch` accepts. `null` elsewhere; the button is
  /// omitted rather than shown disabled.
  final VoidCallback? onRedispatch;

  @override
  Widget build(BuildContext context) {
    final headlineKey = settledHeadlineKeyFor(status, paymentMethod);
    final isDeferred = paymentMethod == PaymentMethod.deferred;

    return OrderCard(
      title: OrderDetailKeys.orderStatus.tr(),
      subtitle: orderReference,
      trailing: Text(
        headlineKey.tr(),
        style: TextStyle(
          color: isDeferred ? context.colors.brandOrange : context.colors.brandBlue,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (status == OrderStatus.delivered) ...[
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
          if (onRedispatch != null) ...[
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: AppSizes.secondaryButtonHeight,
              child: FilledButton.icon(
                onPressed: onRedispatch,
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.brandBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.tile),
                  ),
                ),
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: AppSizes.iconMd,
                ),
                label: Text(
                  OrderDetailKeys.retryPayment.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
