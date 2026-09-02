import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/theme/theme_context.dart';

/// The QR / numeric pickup-code card shown once an order is in transit,
/// for the driver to verify the handover.
class ReceiptCodeCard extends StatelessWidget {
  const ReceiptCodeCard({
    required this.code,
    required this.timeRemaining,
    super.key,
  });

  /// The raw handover code, unspaced — the card spaces it for the digit
  /// boxes and encodes it verbatim in the QR.
  ///
  /// Required, with no default: this card used to fall back to a literal
  /// `8 6 3 5 6 4` and a fixed `05:00`, which rendered as a real, live
  /// pickup code on every in-transit order. A client showing it to a driver
  /// would have been turned away.
  final String code;
  final String timeRemaining;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Column(
        children: [
          Text(
            OrderDetailKeys.handoverMethodTitle.tr(),
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            OrderDetailKeys.handoverMethodNote.tr(),
            style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                  border: Border.all(color: context.colors.borderHairline),
                ),
                child: Column(
                  children: [
                    Text(
                      OrderDetailKeys.qrLabel.tr(),
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    QrImageView(
                      data: code,
                      version: QrVersions.auto,
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                      size: AppSizes.orderQrImageSize,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      OrderDetailKeys.showThisToDriver.tr(),
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  CommonKeys.or.tr(),
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.tile),
                    border: Border.all(color: context.colors.borderHairline),
                  ),
                  child: Column(
                    children: [
                      Text(
                        OrderDetailKeys.pickupCode.tr(),
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: code
                            .split('')
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                ),
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    color: context.colors.brandGreen,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        OrderDetailKeys.validFor.tr(),
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timeRemaining,
                            style: TextStyle(
                              color: context.colors.brandGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Icon(
                            Icons.timer_outlined,
                            color: context.colors.brandGreen,
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
              color: context.colors.greenTint,
              borderRadius: BorderRadius.circular(AppSizes.orderChipRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Flexible so the banner wraps instead of overflowing: the
                // English warning is materially longer than the Arabic the
                // row was measured against.
                Flexible(
                  child: Text(
                    OrderDetailKeys.codeShareWarning.tr(),
                    style: TextStyle(
                      color: context.colors.brandGreen,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.orderCodeBannerIconGap),
                Icon(
                  Icons.verified_user_outlined,
                  color: context.colors.brandGreen,
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
