import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/theme/theme_context.dart';

/// The "الحد الإئتماني" card: limit summary, usage bar and the
/// pay-from-credit action.
class CreditLimitCard extends StatelessWidget {
  const CreditLimitCard({
    this.availableAmount = '120,000.00 ',
    this.totalLimitText,
    this.usedText,
    this.onPayFromCredit,
    super.key,
  });

  final String availableAmount;
  // Nullable rather than defaulted: the placeholder copy is translated, and
  // a default parameter value has to be a compile-time constant.
  final String? totalLimitText;
  final String? usedText;
  final VoidCallback? onPayFromCredit;

  @override
  Widget build(BuildContext context) {
    final currency = CommonKeys.currencySymbol.tr();
    final totalLimitText =
        this.totalLimitText ??
        OrderDetailKeys.creditOf.tr(
          namedArgs: {'amount': '200,000.00 $currency'},
        );
    final usedText =
        this.usedText ??
        OrderDetailKeys.creditUsed.tr(
          namedArgs: {'amount': '200,000.00 $currency', 'percent': '37.5%'},
        );

    return OrderCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    OrderDetailKeys.creditLimit.tr(),
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    OrderDetailKeys.validUntil.tr(),
                    style: TextStyle(color: context.colors.brandBlue, fontSize: 10),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.greenTint,
                      borderRadius: BorderRadius.circular(
                        AppSizes.orderCreditBadgeRadius,
                      ),
                    ),
                    child: Text(
                      OrderDetailKeys.active.tr(),
                      style: TextStyle(
                        color: context.colors.brandGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(
                      AppSizes.orderCreditIconPadding,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.orangeTint,
                      borderRadius: BorderRadius.circular(
                        AppSizes.orderCreditIconRadius,
                      ),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.morePaymentIcon,
                      width: AppSizes.iconLg,
                      height: AppSizes.iconLg,
                      colorFilter: ColorFilter.mode(
                        context.colors.brandOrange,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                OrderDetailKeys.availableNow.tr(),
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: availableAmount,
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: CommonKeys.currencySymbol.tr(),
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              AppSizes.orderCreditProgressRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 63,
                  child: Container(
                    height: AppSizes.orderCreditProgressHeight,
                    color: context.colors.brandOrange,
                  ),
                ),
                Expanded(
                  flex: 37,
                  child: Container(
                    height: AppSizes.orderCreditProgressHeight,
                    color: context.colors.borderHairline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  totalLimitText,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  usedText,
                  textAlign: TextAlign.end,
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.orderCreditBannerGap),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.greenTint,
              borderRadius: BorderRadius.circular(AppSizes.orderChipRadius),
            ),
            child: Text(
              OrderDetailKeys.creditLimitInBudget.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.brandGreen,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: AppSizes.orderPrimaryActionHeight,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.brandOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
              ),
              onPressed: onPayFromCredit ?? () {},
              child: Text(
                OrderDetailKeys.payFromCreditLimit.tr(),
                style: const TextStyle(
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
