import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_mock_data.dart';
import '../order_detail/receipt_code_card.dart';

/// The QR / numeric pickup-code card, tracking-screen flavour. Close to
/// [ReceiptCodeCard] but not merged with it: this one centres the handover
/// note and lets the card surface show through both boxes — small layout
/// differences present in the original design. The code box itself and the
/// warning banner are shared.
class PickupCodeCard extends StatelessWidget {
  const PickupCodeCard({
    this.code = OrderMockData.pickupCode,
    this.timeRemaining = OrderMockData.pickupCodeTimeRemaining,
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
          Text(
            OrderDetailKeys.handoverMethodTitle.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: AppFontSizes.bodyLarge,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            TrackOrderKeys.handoverNote.tr(),
          Text(
            TrackOrderKeys.handoverNote.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: AppFontSizes.micro,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          IntrinsicHeight(
            child: Row(
              children: [
                const _QrBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Center(
                    child: Text(
                      OrderDetailKeys.or.tr(),
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: AppFontSizes.footnote,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PickupCodeBox(
                    code: code,
                    timeRemaining: timeRemaining,
                    filled: false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const CodeShareWarningBanner(),
        ],
      ),
    );
  }
}

class _QrBox extends StatelessWidget {
  const _QrBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(color: AppColors.itemBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            OrderDetailKeys.qrLabel.tr(),
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: AppFontSizes.micro,
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
          Text(
            OrderDetailKeys.showThisToDriver.tr(),
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: AppFontSizes.nano,
            ),
          ),
        ],
      ),
    );
  }
}
