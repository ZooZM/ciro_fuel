import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/number_formatting.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../shared/entities/value_objects.dart';
import 'receipt_breakdown.dart';

/// The paid/deferred receipt: seal, reference/day/hour, the collapsible
/// line-item breakdown, and the download/Sadaad footer.
class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    required this.deferred,
    required this.detailsExpanded,
    required this.onToggleDetails,
    this.priceBreakdown,
    this.lineItemLabel,
    this.referenceNumber = '#889241035',
    this.day,
    this.hour,
    this.total = '600,120.00 ',
    super.key,
  });

  /// Green once the invoice is settled, orange while it is still owed.
  final bool deferred;

  /// The breakdown starts open, except once the order is delivered — by
  /// then the total is all the design keeps on screen.
  final bool detailsExpanded;
  final VoidCallback onToggleDetails;

  final String referenceNumber;
  final String? day;
  final String? hour;
  final String total;

  /// The order's itemised cost (spec 005 FR-011e). `null` — a pre-feature
  /// order, or one created without a quote — renders a total-only receipt
  /// rather than a fabricated or zeroed-out breakdown.
  final PriceBreakdown? priceBreakdown;

  /// The consignment line's label ("بنزين 95 • 20,000 لتر"), required
  /// alongside [priceBreakdown] to build the itemised line; ignored when
  /// [priceBreakdown] is null.
  final String? lineItemLabel;

  static const _sadaadLogoHeight = 26.0;

  List<ReceiptInvoice> get _invoices {
    final breakdown = priceBreakdown;
    final label = lineItemLabel;
    if (breakdown == null || label == null) return const [];
    final currency = CommonKeys.currencySymbol.tr();
    return [
      (
        lineItem: label,
        lineTotal:
            '${NumberFormatting.currency(breakdown.fuelLineTotal)} $currency',
        // Absent until the order is routed and a transport company prices the
        // haul. Left blank rather than rendered as 0, which would read as
        // "delivery is free" instead of "nobody has priced it yet".
        deliveryFee: breakdown.deliveryFee == null
            ? ''
            : '${NumberFormatting.currency(breakdown.deliveryFee!)} $currency',
        serviceFee:
            '${NumberFormatting.currency(breakdown.serviceFee)} $currency',
        // Whether a *separate*, already-standing invoice must be settled
        // alongside this one — not modelled yet (no data source exists for
        // it), so never asserted from this order's own payment method.
        deferred: false,
      ),
    ];
  }

  Color _accent(BuildContext context) =>
      deferred ? context.colors.brandOrange : context.colors.brandGreen;

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final resolvedDay = day ?? (isAr ? '9 أغسطس 2024' : '9 August 2024');
    final resolvedHour = hour ?? (isAr ? '06.30 صباحاً' : '06.30 AM');

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(OrderCard.radius),
        border: Border.all(color: context.colors.borderHairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // The accent reads across the top edge only. It is a strip rather
          // than a Border side because a rounded box needs one uniform
          // colour.
          Container(
            height: AppSizes.orderReceiptAccentHeight,
            color: _accent(context),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.share_outlined,
                        color: context.colors.brandBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (deferred) const _DeferredSeal() else const _SuccessSeal(),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  deferred
                      ? OrderDetailKeys.headlineDeferred.tr()
                      : OrderDetailKeys.paidSuccessfully.tr(),
                  style: TextStyle(
                    color: _accent(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _BreakdownRow(
                  OrderDetailKeys.referenceNumber.tr(),
                  referenceNumber,
                  isRightGray: true,
                ),
                const SizedBox(height: AppSpacing.sm),
                _BreakdownRow(CommonKeys.day.tr(), resolvedDay, isRightGray: true),
                const SizedBox(height: AppSpacing.sm),
                _BreakdownRow(CommonKeys.hour.tr(), resolvedHour, isRightGray: true),
                const SizedBox(height: AppSpacing.lg),
                ReceiptBreakdown(
                  invoices: _invoices,
                  total: total,
                  expanded: detailsExpanded,
                  onToggleExpanded: onToggleDetails,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.file_download_outlined,
                    color: context.colors.brandBlue,
                  ),
                  label: Text(
                    OrderDetailKeys.downloadReceipt.tr(),
                    style: TextStyle(
                      color: context.colors.brandBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SvgPicture.asset(
                  AppAssets.sadaadLogo,
                  height: _sadaadLogoHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow(
    this.title,
    this.value, {
    this.isMain = false,
    this.isRightGray = false,
  });

  final String title;
  final String value;
  final bool isMain;
  final bool isRightGray;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: context.colors.textSecondary,
            fontSize: isMain ? 11 : 10,
            fontWeight: isMain ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isRightGray ? context.colors.textSecondary : context.colors.textPrimary,
            fontSize: isMain ? 13 : 12,
            fontWeight: isMain ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// The deferred counterpart of [_SuccessSeal] — same dashed ring, drawn in
/// the alert colour around a clock. Swap in an artwork asset if one lands.
class _DeferredSeal extends StatelessWidget {
  const _DeferredSeal();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: _DashedRingPainter(context.colors.brandOrange),
        child: Center(
          child: Icon(Icons.schedule, color: context.colors.brandOrange, size: 30),
        ),
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  const _DashedRingPainter(this.color);

  /// Handed in from the widget above — a painter has no [BuildContext].
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final solid = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2 - 1, solid);

    final ring = Path()
      ..addOval(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: size.width / 2 - 6,
        ),
      );

    for (final metric in ring.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), solid);
        distance += 9;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRingPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// The animated dashed-ring tick that heads the paid receipt.
class _SuccessSeal extends StatelessWidget {
  const _SuccessSeal();

  /// Side of the seal at rest — the ring the design draws at 64pt.
  static const _size = 64.0;

  /// The resting ring occupies 208 of the GIF's 640px canvas, so the frame
  /// is drawn oversized and the surrounding transparency cropped away;
  /// otherwise the tick would render at a third of its intended size.
  static const _restingArtwork = 208.0;
  static const _canvas = _size * 640 / _restingArtwork;

  /// Mid-animation the ring swells to 253px of that canvas, so the box has
  /// to leave room for it — sized to the resting ring the outer sweep gets
  /// cut.
  static const _peakArtwork = 253.0;
  static const _box = _size * _peakArtwork / _restingArtwork;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: _box,
        height: _box,
        child: OverflowBox(
          maxWidth: _canvas,
          maxHeight: _canvas,
          child: Image.asset(
            AppAssets.successSealAnimation,
            width: _canvas,
            height: _canvas,
          ),
        ),
      ),
    );
  }
}

