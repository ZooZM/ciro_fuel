import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_detail_strings.dart';

/// The paid/deferred receipt: seal, reference/day/hour, the collapsible
/// line-item breakdown, and the download/Sadaad footer.
class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    required this.deferred,
    required this.detailsExpanded,
    required this.onToggleDetails,
    this.referenceNumber = '#889241035',
    this.day = '9 صفر 1446',
    this.hour = '06.30 صباحاً',
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
  final String day;
  final String hour;
  final String total;

  static const _sadaadLogoHeight = 26.0;

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
                      onPressed: () {},
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
                      ? OrderDetailStrings.headlineDeferred
                      : OrderDetailStrings.paidSuccessfully,
                  style: TextStyle(
                    color: _accent,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _BreakdownRow(
                  OrderDetailStrings.referenceNumber,
                  referenceNumber,
                  isRightGray: true,
                ),
                const SizedBox(height: AppSpacing.sm),
                _BreakdownRow(OrderDetailStrings.day, day, isRightGray: true),
                const SizedBox(height: AppSpacing.sm),
                _BreakdownRow(OrderDetailStrings.hour, hour, isRightGray: true),
                const SizedBox(height: AppSpacing.lg),
                _ReceiptBreakdown(
                  expanded: detailsExpanded,
                  onToggleExpanded: onToggleDetails,
                  total: total,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.file_download_outlined,
                    color: AppColors.blue,
                  ),
                  label: const Text(
                    OrderDetailStrings.downloadReceipt,
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SvgPicture.asset(AppAssets.sadaadLogo, height: _sadaadLogoHeight),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The line-by-line receipt, boxed and collapsible as in the design: open
/// it shows both invoices, closed it keeps only the total.
class _ReceiptBreakdown extends StatelessWidget {
  const _ReceiptBreakdown({
    required this.expanded,
    required this.onToggleExpanded,
    required this.total,
  });

  final bool expanded;
  final VoidCallback onToggleExpanded;
  final String total;

  static const _copyIconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(color: AppColors.itemBorder),
      ),
      child: Column(
        children: [
          if (expanded) ...[
            const _BreakdownRow(
              'بنزين 95 • 20,000 لتر',
              '450,000.00 ر.س',
              isMain: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _BreakdownRow(
              OrderDetailStrings.deliveryFee,
              '30.00 ر.س',
            ),
            const SizedBox(height: AppSpacing.sm),
            const _BreakdownRow(OrderDetailStrings.serviceFee, '30.00 ر.س'),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.orderReceiptIconPadding),
                  decoration: BoxDecoration(
                    color: AppColors.blueTintAlt,
                    borderRadius: BorderRadius.circular(
                      AppSizes.orderReceiptIconRadius,
                    ),
                  ),
                  child: SvgPicture.asset(
                    AppAssets.copyIcon,
                    width: _copyIconSize,
                    height: _copyIconSize,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF1E5FFF),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        OrderDetailStrings.deferredInvoiceTitle,
                        style: TextStyle(
                          color: AppColors.warningOrange,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        OrderDetailStrings.deferredInvoiceNote,
                        style: TextStyle(color: AppColors.green, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const _BreakdownRow(
              'بنزين 95 • 20,000 لتر',
              '450,000.00 ر.س',
              isMain: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _BreakdownRow(
              OrderDetailStrings.deliveryFee,
              '30.00 ر.س',
            ),
            const SizedBox(height: AppSpacing.sm),
            const _BreakdownRow(OrderDetailStrings.serviceFee, '30.00 ر.س'),
            const SizedBox(height: AppSpacing.lg),
          ],
          _DetailsToggle(expanded: expanded, onTap: onToggleExpanded),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                OrderDetailStrings.total,
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: total,
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const TextSpan(
                      text: 'ر.س',
                      style: TextStyle(color: AppColors.green, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
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
            color: AppColors.grey,
            fontSize: isMain ? 11 : 10,
            fontWeight: isMain ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isRightGray ? AppColors.grey : AppColors.navy,
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
        painter: _DashedRingPainter(),
        child: const Center(
          child: Icon(Icons.schedule, color: AppColors.warningOrange, size: 30),
        ),
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final solid = Paint()
      ..color = AppColors.warningOrange
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

/// The `إظهار / إخفاء التفاصيل` control, centred in a hairline rule.
class _DetailsToggle extends StatelessWidget {
  const _DetailsToggle({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.itemBorder)),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Text(
                  expanded
                      ? OrderDetailStrings.hideDetails
                      : OrderDetailStrings.showDetails,
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  expanded
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.green,
                  size: AppSizes.iconSm,
                ),
              ],
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.itemBorder)),
      ],
    );
  }
}
