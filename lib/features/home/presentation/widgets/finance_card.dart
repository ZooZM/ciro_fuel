import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../constants/client_home_strings.dart';

/// One of the two balance/invoice tiles above the "new request" button.
class FinanceCard extends StatelessWidget {
  const FinanceCard({
    required this.label,
    required this.amount,
    required this.asset,
    super.key,
  });

  final String label;
  final String amount;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(color: AppColors.itemBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                // Text.rich, not RichText: RichText ignores
                // DefaultTextStyle, so the amount would fall back to the
                // platform font instead of the app's Tajawal.
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$amount ',
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text: ClientHomeStrings.currency,
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            asset,
            width: AppSizes.dashboardFinanceIconSize,
            height: AppSizes.dashboardFinanceIconSize,
          ),
        ],
      ),
    );
  }
}
