import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/enums/payment_method.dart';
import '../../../../../core/theme/theme_context.dart';

/// "5. طريقة الدفع" — DIRECT (via Sadaad), DEFERRED and CREDIT (spec 004
/// FR-021). Exactly one is on the order at a time; picking another
/// replaces it, same convention as the grade/quantity sections above.
class PaymentSection extends StatelessWidget {
  const PaymentSection({
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onSelect;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      title: CreateOrderKeys.sectionPayment.tr(),
      child: Column(
        children: [
          _MethodTile(
            title: CreateOrderKeys.paymentDirectTitle.tr(),
            subtitle: CreateOrderKeys.paymentDirectSubtitle.tr(),
            selected: selected == PaymentMethod.direct,
            onTap: () => onSelect(PaymentMethod.direct),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MethodTile(
            title: CreateOrderKeys.paymentDeferredTitle.tr(),
            subtitle: CreateOrderKeys.paymentDeferredSubtitle.tr(),
            selected: selected == PaymentMethod.deferred,
            onTap: () => onSelect(PaymentMethod.deferred),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MethodTile(
            title: CreateOrderKeys.paymentCreditTitle.tr(),
            subtitle: CreateOrderKeys.paymentCreditSubtitle.tr(),
            selected: selected == PaymentMethod.credit,
            onTap: () => onSelect(PaymentMethod.credit),
          ),
          if (selected == PaymentMethod.direct) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppRadii.tile),
                border: Border.all(color: context.colors.borderHairline),
              ),
              child: SvgPicture.asset(AppAssets.sadaadLogo, height: 34),
            ),
          ],
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? colors.blueTint : colors.surface,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: selected ? colors.brandBlue : colors.borderHairline,
            width: selected
                ? AppSizes.orderTileSelectedBorderWidth
                : AppSizes.orderTileBorderWidth,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected ? colors.brandBlue : colors.textSecondary,
              size: AppSizes.iconMd,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: colors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
