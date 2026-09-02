import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/theme/theme_context.dart';

/// The QR / numeric pickup-code card, tracking-screen flavour. Close to
/// [order_detail]'s equivalent card but not merged with it: this one
/// centres the handover note, wraps the two boxes in [IntrinsicHeight] so
/// they match height, and centres the "أو" divider — small layout
/// differences present in the original design.
class PickupCodeCard extends StatelessWidget {
  const PickupCodeCard({
    this.code = '863564',
    this.timeRemaining = 'د 05:00',
    super.key,
  });

  /// The raw handover code, unspaced.
  ///
  /// The card spaces it itself for the digit boxes. It used to arrive
  /// pre-spaced from the caller, which was harmless while the QR was a
  /// static image — but the QR now encodes this string, and `"8 6 3 5 6 4"`
  /// is not a code the backend will accept.
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
            TrackOrderKeys.handoverNote.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
          ),
          const SizedBox(height: AppSpacing.lg),
          IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.tile),
                    border: Border.all(color: context.colors.borderHairline),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      // Generated from the live code, not the design's
                      // placeholder PNG — that image encoded nothing, so a
                      // driver scanning it got a string unrelated to this
                      // order and the handover could only ever be completed
                      // by typing the digits.
                      QrImageView(
                        data: code,
                        version: QrVersions.auto,
                        size: AppSizes.orderQrImageSize,
                        backgroundColor: Colors.white,
                        // The digits are printed beside this anyway, so a
                        // scan failure is never the client's only route.
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Center(
                    child: Text(
                      CommonKeys.or.tr(),
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadii.tile),
                      border: Border.all(color: context.colors.borderHairline),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
