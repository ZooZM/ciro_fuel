import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_detail_strings.dart';

/// The "الحد الإئتماني" card: limit summary, usage bar and the
/// pay-from-credit action.
class CreditLimitCard extends StatelessWidget {
  const CreditLimitCard({
    this.availableAmount = '120,000.00 ',
    this.totalLimitText = 'من 200,000.00 ر.س',
    this.usedText = 'مستخدم 200,000.00 ر.س (37.5%)',
    this.onPayFromCredit,
    super.key,
  });

  final String availableAmount;
  final String totalLimitText;
  final String usedText;
  final VoidCallback? onPayFromCredit;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    OrderDetailStrings.creditLimit,
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(
                    OrderDetailStrings.validUntil,
                    style: TextStyle(color: AppColors.blue, fontSize: 10),
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
                      color: AppColors.light.greenTint,
                      borderRadius: BorderRadius.circular(
                        AppSizes.orderCreditBadgeRadius,
                      ),
                    ),
                    child: const Text(
                      OrderDetailStrings.active,
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSizes.orderCreditIconPadding),
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
              const Text(
                OrderDetailStrings.availableNow,
                style: TextStyle(
                  color: AppColors.navy,
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
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const TextSpan(
                        text: 'ر.س',
                        style: TextStyle(color: AppColors.grey, fontSize: 12),
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
                    color: AppColors.warningOrange,
                  ),
                ),
                Expanded(
                  flex: 37,
                  child: Container(
                    height: AppSizes.orderCreditProgressHeight,
                    color: AppColors.itemBorder,
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
                  style: const TextStyle(
                    color: AppColors.navy,
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
                  style: const TextStyle(color: AppColors.grey, fontSize: 10),
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
            child: const Text(
              OrderDetailStrings.creditLimitInBudget,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.green,
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
                backgroundColor: AppColors.warningOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
              ),
              onPressed: onPayFromCredit ?? () {},
              child: const Text(
                OrderDetailStrings.payFromCreditLimit,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
