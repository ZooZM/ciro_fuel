import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// One invoice inside a receipt: what was bought, and what it cost to get
/// there. [deferred] heads the block with the "فاتورة مؤجلة" notice — an
/// earlier invoice that has to be settled alongside this one.
typedef ReceiptInvoice = ({
  String lineItem,
  String lineTotal,
  String deliveryFee,
  String serviceFee,
  bool deferred,
});

/// The line-by-line receipt, boxed and collapsible as in the design.
///
/// Open it lists every invoice; closed it keeps only the total — the state
/// Figma draws for a settled order, and what "إخفاء التفاصيل" folds the
/// card down to.
///
/// Shared by the order-detail receipt and the SADAD invoice screen, which
/// draw the same breakdown from the same design frame.
class ReceiptBreakdown extends StatelessWidget {
  const ReceiptBreakdown({
    required this.invoices,
    required this.total,
    required this.expanded,
    required this.onToggleExpanded,
    this.bordered = true,
    super.key,
  });

  final List<ReceiptInvoice> invoices;

  /// Pre-formatted, currency included.
  final String total;

  final bool expanded;
  final VoidCallback onToggleExpanded;

  /// The order-detail receipt boxes the breakdown off inside its card; the
  /// invoice screen gives it the card to itself and drops the outline.
  final bool bordered;

  /// No line items to reveal — a pre-feature order with no stored breakdown
  /// (FR-011e). The toggle is dropped along with them: offering to "show
  /// details" that don't exist would read as a bug, not an empty state.
  bool get _totalOnly => invoices.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: bordered ? Border.all(color: AppColors.itemBorder) : null,
      ),
      child: Column(
        children: [
          if (!_totalOnly) ...[
            // AnimatedSize rather than a bare `if`: the card shrinking to
            // the total is the whole point of the control, and a snap makes
            // it read as a different card rather than the same one folding.
            AnimatedSize(
              duration: AppSizes.orderDetailsCollapseDuration,
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: expanded
                  ? Column(
                      children: [
                        for (final invoice in invoices)
                          _InvoiceBlock(invoice: invoice),
                      ],
                    )
                  : const SizedBox(width: double.infinity),
            ),
            _DetailsToggle(expanded: expanded, onTap: onToggleExpanded),
            const SizedBox(height: AppSpacing.lg),
          ],
          _TotalRow(total: total),
        ],
      ),
    );
  }
}

/// A label/value pair on a receipt. Public so the receipt card can set its
/// reference/day/hour rows to the same measure.
class ReceiptBreakdownRow extends StatelessWidget {
  const ReceiptBreakdownRow(
    this.title,
    this.value, {
    this.isMain = false,
    this.isValueMuted = false,
    super.key,
  });

  final String title;
  final String value;

  /// The consignment line that heads an invoice block — heavier than the
  /// fee rows beneath it.
  final bool isMain;

  /// Greys the value, as the receipt's metadata rows do.
  final bool isValueMuted;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: isMain ? AppFontSizes.caption : AppFontSizes.micro,
              fontWeight: isMain ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          value,
          style: TextStyle(
            color: isValueMuted ? AppColors.grey : AppColors.navy,
            fontSize: isMain ? AppFontSizes.body : AppFontSizes.footnote,
            fontWeight: isMain ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _InvoiceBlock extends StatelessWidget {
  const _InvoiceBlock({required this.invoice});

  final ReceiptInvoice invoice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (invoice.deferred) ...[
          const _DeferredInvoiceNotice(),
          const SizedBox(height: AppSpacing.lg),
        ],
        ReceiptBreakdownRow(invoice.lineItem, invoice.lineTotal, isMain: true),
        const SizedBox(height: AppSpacing.sm),
        ReceiptBreakdownRow(
          OrderDetailKeys.deliveryFee.tr(),
          invoice.deliveryFee,
        ),
        const SizedBox(height: AppSpacing.sm),
        ReceiptBreakdownRow(
          OrderDetailKeys.serviceFee.tr(),
          invoice.serviceFee,
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

/// "فاتورة مؤجلة" — the standing invoice that has to be cleared before the
/// current order can complete.
class _DeferredInvoiceNotice extends StatelessWidget {
  const _DeferredInvoiceNotice();

  @override
  Widget build(BuildContext context) {
    return Row(
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
            width: AppSizes.orderCopyIconSize,
            height: AppSizes.orderCopyIconSize,
            colorFilter: const ColorFilter.mode(
              AppColors.blue,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                OrderDetailKeys.deferredInvoiceTitle.tr(),
                style: const TextStyle(
                  color: AppColors.warningOrange,
                  fontSize: AppFontSizes.bodyLarge,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                OrderDetailKeys.deferredInvoiceNote.tr(),
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: AppFontSizes.micro,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.total});

  final String total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          OrderDetailKeys.total.tr(),
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: AppFontSizes.title,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              total,
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.green,
                fontSize: AppFontSizes.titleLarge,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
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
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Text(
                  expanded
                      ? OrderDetailKeys.hideDetails.tr()
                      : OrderDetailKeys.showDetails.tr(),
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: AppFontSizes.micro,
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
