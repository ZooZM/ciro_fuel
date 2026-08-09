import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_formatting.dart';
import '../../constants/order_mock_data.dart';
import 'receipt_breakdown.dart';

/// The paid/deferred receipt: seal, reference/day/hour, the collapsible
/// line-item breakdown, and the download/Sadaad footer.
class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    required this.deferred,
    required this.detailsExpanded,
    required this.onToggleDetails,
    this.referenceNumber = OrderMockData.receiptReference,
    this.day = OrderMockData.deliveryDate,
    this.hour = OrderMockData.deliveryHour,
    this.onShare,
    this.onDownload,
    super.key,
  });

  /// Green once the invoice is settled, orange while it is still owed.
  final bool deferred;

  /// The breakdown starts open, except once the order is delivered — by
  /// then the total is all the design keeps on screen.
  final bool detailsExpanded;
  final VoidCallback onToggleDetails;

  final String referenceNumber;
  final String day;
  final String hour;

  final VoidCallback? onShare;
  final VoidCallback? onDownload;

  Color get _accent => deferred ? AppColors.warningOrange : AppColors.green;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(OrderCard.radius),
        border: Border.all(color: AppColors.itemBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // The accent reads across the top edge only. It is a strip rather
          // than a Border side because a rounded box needs one uniform
          // colour.
          Container(height: AppSizes.orderReceiptAccentHeight, color: _accent),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: onShare ?? () {},
                      tooltip: OrderDetailKeys.shareReceipt.tr(),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.share_outlined,
                        color: AppColors.blue,
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _accent,
                    fontSize: AppFontSizes.title,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                ReceiptBreakdownRow(
                  OrderDetailKeys.referenceNumber.tr(),
                  referenceNumber,
                  isValueMuted: true,
                ),
                const SizedBox(height: AppSpacing.sm),
                ReceiptBreakdownRow(
                  OrderDetailKeys.day.tr(),
                  day,
                  isValueMuted: true,
                ),
                const SizedBox(height: AppSpacing.sm),
                ReceiptBreakdownRow(
                  OrderDetailKeys.hour.tr(),
                  hour,
                  isValueMuted: true,
                ),
                const SizedBox(height: AppSpacing.lg),
                ReceiptBreakdown(
                  invoices: _receiptInvoices(),
                  total: OrderFormatting.money(OrderMockData.receiptTotal),
                  expanded: detailsExpanded,
                  onToggleExpanded: onToggleDetails,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextButton.icon(
                  onPressed: onDownload ?? () {},
                  icon: const Icon(
                    Icons.file_download_outlined,
                    color: AppColors.blue,
                  ),
                  label: Text(
                    OrderDetailKeys.downloadReceipt.tr(),
                    style: const TextStyle(
                      color: AppColors.blue,
                      fontSize: AppFontSizes.bodyLarge,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SvgPicture.asset(
                  AppAssets.sadaadLogo,
                  height: AppSizes.orderReceiptLogoHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The current order, then the deferred invoice standing behind it — the two
/// blocks the design lists inside the breakdown.
List<ReceiptInvoice> _receiptInvoices() {
  ReceiptInvoice block({required bool deferred}) => (
    lineItem: OrderFormatting.lineItem(
      OrderMockData.fuelGrade,
      OrderMockData.quantityLitres,
    ),
    lineTotal: OrderFormatting.money(OrderMockData.fuelLineTotal),
    deliveryFee: OrderFormatting.money(OrderMockData.deliveryFee),
    serviceFee: OrderFormatting.money(OrderMockData.serviceFee),
    deferred: deferred,
  );

  return [block(deferred: false), block(deferred: true)];
}

/// The deferred counterpart of [_SuccessSeal] — same dashed ring, drawn in
/// the alert colour around a clock. Swap in an artwork asset if one lands.
class _DeferredSeal extends StatelessWidget {
  const _DeferredSeal();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppSizes.orderSealSize,
      height: AppSizes.orderSealSize,
      child: CustomPaint(
        painter: _DashedRingPainter(),
        child: Center(
          child: Icon(
            Icons.schedule,
            color: AppColors.warningOrange,
            size: AppSizes.orderSealIconSize,
          ),
        ),
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  const _DashedRingPainter();

  static const _strokeWidth = 2.0;
  static const _ringInset = 6.0;
  static const _dash = 5.0;
  static const _dashPitch = 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final solid = Paint()
      ..color = AppColors.warningOrange
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2 - _strokeWidth / 2,
      solid,
    );

    final ring = Path()
      ..addOval(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: size.width / 2 - _ringInset,
        ),
      );

    for (final metric in ring.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + _dash), solid);
        distance += _dashPitch;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// The animated dashed-ring tick that heads the paid receipt.
class _SuccessSeal extends StatelessWidget {
  const _SuccessSeal();

  /// The resting ring occupies 208 of the GIF's 640px canvas, so the frame
  /// is drawn oversized and the surrounding transparency cropped away;
  /// otherwise the tick would render at a third of its intended size.
  static const _restingArtwork = 208.0;
  static const _canvas = AppSizes.orderSealSize * 640 / _restingArtwork;

  /// Mid-animation the ring swells to 253px of that canvas, so the box has
  /// to leave room for it — sized to the resting ring the outer sweep gets
  /// cut.
  static const _peakArtwork = 253.0;
  static const _box = AppSizes.orderSealSize * _peakArtwork / _restingArtwork;

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
