import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/number_formatting.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../invoices/domain/entities/credit_standing.dart';

/// The "الحد الإئتماني" card: limit summary, usage bar and the
/// pay-from-credit action.
///
/// Every figure comes from [standing] — the platform's own credit
/// calculation, the same one the dashboard and the credit screen read, so
/// the three cannot disagree (FR-026). This card previously carried
/// fabricated defaults (120,000 available of a 200,000 limit, 37.5% used)
/// which rendered identically for every client regardless of their real
/// facility.
class CreditLimitCard extends StatelessWidget {
  const CreditLimitCard({
    required this.standing,
    this.onPayFromCredit,
    super.key,
  });

  final CreditStanding standing;
  final VoidCallback? onPayFromCredit;

  @override
  Widget build(BuildContext context) {
    final currency = CommonKeys.currencySymbol.tr();
    final creditLimit = standing.creditLimit ?? 0;
    final consumed = standing.consumed ?? 0;
    final available = standing.available ?? 0;
    // Guarded against a zero limit: a client with no facility would
    // otherwise divide by zero and render NaN% in the usage bar.
    final usedFraction = creditLimit > 0
        ? (consumed / creditLimit).clamp(0.0, 1.0)
        : 0.0;

    final availableAmount = '${NumberFormatting.currency(available)} ';
    final totalLimitText = OrderDetailKeys.creditOf.tr(
      namedArgs: {'amount': '${NumberFormatting.currency(creditLimit)} $currency'},
    );
    final usedText = OrderDetailKeys.creditUsed.tr(
      namedArgs: {
        'amount': '${NumberFormatting.currency(consumed)} $currency',
        'percent': '${(usedFraction * 100).toStringAsFixed(1)}%',
      },
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
                // Integer flex weights out of 1000 — fine-grained enough
                // that a fraction of a percent still moves the bar, and a
                // fully-consumed facility leaves no remainder sliver.
                Expanded(
                  flex: (usedFraction * 1000).round(),
                  child: Container(
                    height: AppSizes.orderCreditProgressHeight,
                    color: context.colors.brandOrange,
                  ),
                ),
                Expanded(
                  flex: 1000 - (usedFraction * 1000).round(),
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
