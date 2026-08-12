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

/// The QR / numeric pickup-code card shown once an order is in transit,
/// for the driver to verify the handover.
class ReceiptCodeCard extends StatelessWidget {
  const ReceiptCodeCard({
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
            OrderDetailKeys.handoverMethodNote.tr(),
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

/// The QR half of the handover pair. Shared with the tracking screen's
/// pickup card, which draws the same box.
class _QrBox extends StatelessWidget {
  const _QrBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
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

/// The numeric half of the handover pair: the code, boxed digit by digit,
/// over the countdown it stays valid for.
class PickupCodeBox extends StatelessWidget {
  const PickupCodeBox({
    required this.code,
    required this.timeRemaining,
    this.filled = true,
    super.key,
  });

  /// Space-separated digits, one per box.
  final String code;
  final String timeRemaining;

  /// The order-detail card sits the box on white; the tracking card lets
  /// the surface show through.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: filled ? Colors.white : null,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(color: AppColors.itemBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            OrderDetailKeys.pickupCode.tr(),
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: AppFontSizes.footnote,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final digit in code.split(' '))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    child: Text(
                      digit,
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: AppFontSizes.titleLarge,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            OrderDetailKeys.validFor.tr(),
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: AppFontSizes.micro,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timeRemaining,
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: AppFontSizes.footnote,
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
    );
  }
}

/// "لا تقم بمشاركة الكود..." — the green footer under both pickup cards.
class CodeShareWarningBanner extends StatelessWidget {
  const CodeShareWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.light.greenTint,
        borderRadius: BorderRadius.circular(AppSizes.orderChipRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              OrderDetailKeys.codeShareWarning.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.green,
                fontSize: AppFontSizes.micro,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.orderCodeBannerIconGap),
          const Icon(
            Icons.verified_user_outlined,
            color: AppColors.green,
            size: AppSizes.iconSm,
          ),
        ],
      ),
    );
  }
}
