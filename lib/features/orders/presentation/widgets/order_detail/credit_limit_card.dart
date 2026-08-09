import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/number_formatting.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_mock_data.dart';

/// The "الحد الإئتماني" card: limit summary, usage bar and the
/// pay-from-credit action.
class CreditLimitCard extends StatelessWidget {
  const CreditLimitCard({
    this.availableAmount = OrderMockData.creditAvailable,
    this.totalLimit = OrderMockData.creditLimit,
    this.usedAmount = OrderMockData.creditLimit,
    this.usedPercent = OrderMockData.creditUsedPercent,
    this.validUntil = OrderMockData.creditValidUntil,
    this.onPayFromCredit,
    super.key,
  });

  final double availableAmount;
  final double totalLimit;
  final double usedAmount;

  /// Pre-formatted, so the copy can read "(37.5%)" without the card owning
  /// a percentage format.
  final String usedPercent;

  final String validUntil;
  final VoidCallback? onPayFromCredit;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      OrderDetailKeys.creditLimit.tr(),
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: AppFontSizes.title,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      OrderDetailKeys.creditValidUntil.tr(
                        namedArgs: {'date': validUntil},
                      ),
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontSize: AppFontSizes.micro,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.light.greenTint,
                      borderRadius: BorderRadius.circular(
                        AppSizes.orderCreditBadgeRadius,
                      ),
                    ),
                    child: Text(
                      OrderDetailKeys.active.tr(),
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: AppFontSizes.caption,
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
                      color: AppColors.creditIconBackground,
                      borderRadius: BorderRadius.circular(
                        AppSizes.orderCreditIconRadius,
                      ),
                    ),
                    child: const Icon(
                      Icons.credit_card_outlined,
                      color: AppColors.warningOrange,
                      size: AppSizes.iconLg,
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
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: AppFontSizes.footnote,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${NumberFormatting.currency(availableAmount)} ',
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: AppFontSizes.display,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: OrdersKeys.currency.tr(),
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: AppFontSizes.footnote,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
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
            child: const Row(
              children: [
                Expanded(
                  flex: OrderMockData.creditUsedFlex,
                  child: ColoredBox(
                    color: AppColors.warningOrange,
                    child: SizedBox(
                      height: AppSizes.orderCreditProgressHeight,
                      width: double.infinity,
                    ),
                  ),
                ),
                Expanded(
                  flex: OrderMockData.creditFreeFlex,
                  child: ColoredBox(
                    color: AppColors.itemBorder,
                    child: SizedBox(
                      height: AppSizes.orderCreditProgressHeight,
                      width: double.infinity,
                    ),
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
                  OrderDetailKeys.creditTotalLimit.tr(
                    namedArgs: {
                      'amount': NumberFormatting.currency(totalLimit),
                    },
                  ),
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: AppFontSizes.caption,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  OrderDetailKeys.creditUsed.tr(
                    namedArgs: {
                      'amount': NumberFormatting.currency(usedAmount),
                      'percent': usedPercent,
                    },
                  ),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: AppFontSizes.micro,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.orderCreditBannerGap),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.light.greenTint,
              borderRadius: BorderRadius.circular(AppSizes.orderChipRadius),
            ),
            child: Text(
              OrderDetailKeys.creditLimitInBudget.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.green,
                fontSize: AppFontSizes.body,
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
                backgroundColor: AppColors.warningOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
              ),
              onPressed: onPayFromCredit ?? () {},
              child: Text(
                OrderDetailKeys.payFromCreditLimit.tr(),
                style: const TextStyle(
                  fontSize: AppFontSizes.bodyLarge,
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
