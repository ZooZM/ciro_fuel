import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../view/invoice_payment_screen.dart';
import 'status_chip.dart';
import '../../../../../core/theme/theme_context.dart';

/// The card the order sits in once it can be paid — identical either side
/// of the invoice being raised, bar the badge and the pay button's
/// wording.
class PayableOrderStatusCard extends StatelessWidget {
  const PayableOrderStatusCard({
    required this.invoicePending,
    required this.onDeferPayment,
    this.orderReference,
    this.onCancel,
    this.onRequestCreditLimit,
    super.key,
  });

  final bool invoicePending;
  final String? orderReference;

  /// Pushes the order to the deferred (pay-next-time) receipt.
  final VoidCallback onDeferPayment;
  final VoidCallback? onCancel;
  final VoidCallback? onRequestCreditLimit;

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final resolvedReference = orderReference ?? 
        (isAr ? 'ORD-2024-256 · 9 أغسطس 2024' : 'ORD-2024-256 · 9 August 2024');

    return OrderCard(
      dashed: true,
      title: OrderDetailKeys.orderStatus.tr(),
      subtitle: resolvedReference,
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
                      backgroundColor: context.colors.brandBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.tile),
                      ),
                    ),
                    icon: Transform.translate(
                      offset: const Offset(0, -2),
                      child: SvgPicture.asset(
                        AppAssets.payCardIcon,
                        width: AppSizes.iconMd,
                        height: AppSizes.iconMd,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: Text(
                      invoicePending
                          ? OrderDetailKeys.completePayment.tr()
                          : OrderDetailKeys.pay.tr(),
                      style: const TextStyle(
                        fontSize: 14,
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
                backgroundColor: context.colors.brandGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
              ),
              icon: Transform.translate(
                offset: const Offset(0, -2),
                child: const Icon(
                  Icons.bookmark_outline,
                  size: AppSizes.iconMd,
                  color: Colors.white,
                ),
              ),
              label: Text(
                OrderDetailKeys.payNextTime.tr(),
                style: const TextStyle(
                  fontSize: 14,
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
              icon: Transform.translate(
                offset: const Offset(0, -2),
                child: SvgPicture.asset(
                  AppAssets.requestCreditLimitIcon,
                  width: AppSizes.iconMd,
                  height: AppSizes.iconMd,
                  colorFilter: ColorFilter.mode(
                    context.colors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              label: Text(
                OrderDetailKeys.requestCreditLimit.tr(),
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 13,
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
