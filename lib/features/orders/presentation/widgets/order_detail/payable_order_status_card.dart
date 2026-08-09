import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_mock_data.dart';
import '../../view/invoice_payment_screen.dart';
import 'status_chip.dart';

/// The card the order sits in once it can be paid — identical either side
/// of the invoice being raised, bar the badge and the pay button's
/// wording.
class PayableOrderStatusCard extends StatelessWidget {
  const PayableOrderStatusCard({
    required this.invoicePending,
    required this.onDeferPayment,
    this.orderReference = OrderMockData.orderReference,
    this.onCancel,
    this.onRequestCreditLimit,
    super.key,
  });

  final bool invoicePending;
  final String orderReference;

  /// Pushes the order to the deferred (pay-next-time) receipt.
  final VoidCallback onDeferPayment;
  final VoidCallback? onCancel;
  final VoidCallback? onRequestCreditLimit;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      dashed: true,
      title: OrderDetailKeys.orderStatus.tr(),
      subtitle: orderReference,
      trailing: StatusChip(
        invoicePending
            ? OrderDetailKeys.invoicePending.tr()
            : OrderDetailKeys.confirmed.tr(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: AppSizes.secondaryButtonHeight,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const InvoicePaymentScreen(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.tile),
                      ),
                    ),
                    icon: const Icon(
                      Icons.credit_card,
                      size: AppSizes.iconMd,
                      color: Colors.white,
                    ),
                    label: Text(
                      invoicePending
                          ? OrderDetailKeys.completePayment.tr()
                          : OrderDetailKeys.pay.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: AppFontSizes.bodyLarge,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SizedBox(
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
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: AppSizes.secondaryButtonHeight,
            child: FilledButton.icon(
              onPressed: onDeferPayment,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
              ),
              icon: const Icon(
                Icons.bookmark_outline,
                size: AppSizes.iconMd,
                color: Colors.white,
              ),
              label: Text(
                OrderDetailKeys.payNextTime.tr(),
                style: const TextStyle(
                  fontSize: AppFontSizes.bodyLarge,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton.icon(
              onPressed: onRequestCreditLimit ?? () {},
              icon: const Icon(
                Icons.credit_card_outlined,
                color: AppColors.navy,
                size: AppSizes.iconMd,
              ),
              label: Text(
                OrderDetailKeys.requestCreditLimit.tr(),
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: AppFontSizes.body,
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
