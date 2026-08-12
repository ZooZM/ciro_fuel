import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/enums/payment_method.dart';

/// "5. طريقة الدفع" (spec 004 FR-021/T090): which of the three methods this
/// order is billed under. DIRECT is the only one that actually collects
/// payment through the app (Sadad); DEFERRED/CREDIT are pre-arranged
/// business terms between the Fuel Company, the Transportation Company and
/// this client — selectable here, but the backend is the sole authority on
/// whether they are honoured (e.g. a CREDIT order still gets refused at
/// approval if it exceeds the client's available credit, FR-025).
class PaymentSection extends StatelessWidget {
  const PaymentSection({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      title: CreateOrderKeys.sectionPayment.tr(),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _PaymentTile(
                title: CreateOrderKeys.paymentDirectTitle.tr(),
                subtitle: CreateOrderKeys.paymentDirectSubtitle.tr(),
                selected: selected == PaymentMethod.direct,
                onTap: () => onChanged(PaymentMethod.direct),
                glyph: SvgPicture.asset(
                  AppAssets.sadaadLogo,
                  height: AppSizes.icon16,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _PaymentTile(
                title: CreateOrderKeys.paymentDeferredTitle.tr(),
                subtitle: CreateOrderKeys.paymentDeferredSubtitle.tr(),
                selected: selected == PaymentMethod.deferred,
                onTap: () => onChanged(PaymentMethod.deferred),
                icon: Icons.schedule,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _PaymentTile(
                title: CreateOrderKeys.paymentCreditTitle.tr(),
                subtitle: CreateOrderKeys.paymentCreditSubtitle.tr(),
                selected: selected == PaymentMethod.credit,
                onTap: () => onChanged(PaymentMethod.credit),
                icon: Icons.account_balance_wallet_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.icon,
    this.glyph,
  }) : assert(
         icon != null || glyph != null,
         'a payment tile needs either an icon or a custom glyph',
       );

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Widget? glyph;

  @override
  Widget build(BuildContext context) {
    final titleColor = selected ? AppColors.green : AppColors.navy;
    final subtitleColor = selected ? AppColors.green : AppColors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppSizes.orderDeliveryTileMinHeight,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.light.greenTint : Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: selected ? AppColors.green : AppColors.itemBorder,
            width: selected
                ? AppSizes.orderTileSelectedBorderWidth
                : AppSizes.orderTileBorderWidth,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                glyph ??
                    Icon(icon, size: AppSizes.iconLg, color: titleColor),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: AppFontSizes.footnote,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: AppFontSizes.micro,
                  ),
                ),
              ],
            ),
            if (selected)
              const Positioned(
                top: AppSpacing.xs,
                right: AppSpacing.xs,
                child: Icon(
                  Icons.check_circle,
                  size: AppSizes.iconSm,
                  color: AppColors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
