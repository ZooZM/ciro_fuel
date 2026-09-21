import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/widgets/order_card.dart';

/// The order-status card while routing has priced the haul and the platform
/// is waiting for the station owner to accept that total — a DEFERRED or
/// CREDIT order resting at `PENDING_PAYMENT` (see `cardKindFor`).
///
/// Deliberately NOT [PayableOrderStatusCard]: there is no gateway payment to
/// make here, and `acceptFinalPrice` refuses a DIRECT order outright rather
/// than offering a second, cheaper way past the same gate. Offering "pay"
/// on this card would name an action the platform would reject.
///
/// Refusing the total needs nothing of its own — `PENDING_PAYMENT` is in the
/// backend's `CLIENT_CANCELLABLE` set and cancelling releases every booked
/// resource, which is exactly what a refusal means here.
class AcceptTotalOrderStatusCard extends StatelessWidget {
  const AcceptTotalOrderStatusCard({
    this.orderReference,
    this.onAccept,
    this.onCancel,
    super.key,
  });

  final String? orderReference;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      dashed: true,
      title: OrderDetailKeys.orderStatus.tr(),
      subtitle: orderReference,
      trailing: Text(
        OrderDetailKeys.awaitingAcceptance.tr(),
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
            child: FilledButton(
              onPressed: onAccept,
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.brandBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
              ),
              child: Text(
                OrderDetailKeys.acceptTotal.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: AppSizes.secondaryButtonHeight,
            child: OutlinedButton(
              onPressed: onCancel,
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
