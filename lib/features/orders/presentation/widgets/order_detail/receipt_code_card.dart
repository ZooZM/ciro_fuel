import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_detail_strings.dart';

/// The QR / numeric pickup-code card shown once an order is in transit,
/// for the driver to verify the handover.
class ReceiptCodeCard extends StatelessWidget {
  const ReceiptCodeCard({
    this.code = '8 6 3 5 6 4',
    this.timeRemaining = 'د 05:00',
    super.key,
  });

  /// Space-separated digits, one per box.
  final String code;
  final String timeRemaining;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Column(
        children: [
          const Text(
            OrderDetailStrings.handoverMethodTitle,
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            OrderDetailStrings.handoverMethodNote,
            style: TextStyle(color: AppColors.grey, fontSize: 10),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                  border: Border.all(color: AppColors.itemBorder),
                ),
                child: Column(
                  children: [
                    const Text(
                      OrderDetailStrings.qrLabel,
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Image.asset(
                      AppAssets.qrCodeImage,
                      width: AppSizes.orderQrImageSize,
                      height: AppSizes.orderQrImageSize,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text(
                      OrderDetailStrings.showThisToDriver,
                      style: TextStyle(color: AppColors.grey, fontSize: 8),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  OrderDetailStrings.or,
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadii.tile),
                    border: Border.all(color: AppColors.itemBorder),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        OrderDetailStrings.pickupCode,
                        style: TextStyle(
                          color: AppColors.navy,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: code
                            .split(' ')
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                ),
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    color: AppColors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        OrderDetailStrings.validFor,
                        style: TextStyle(color: AppColors.grey, fontSize: 10),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timeRemaining,
                            style: const TextStyle(
                              color: AppColors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          const Icon(
                            Icons.timer_outlined,
                            color: AppColors.green,
                            size: AppSizes.iconSm,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.light.greenTint,
              borderRadius: BorderRadius.circular(AppSizes.orderChipRadius),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  OrderDetailStrings.codeShareWarning,
                  style: TextStyle(color: AppColors.green, fontSize: 10),
                ),
                SizedBox(width: AppSizes.orderCodeBannerIconGap),
                Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.green,
                  size: AppSizes.iconSm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
