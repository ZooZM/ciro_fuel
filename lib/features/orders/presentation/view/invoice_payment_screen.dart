// `easy_localization` re-exports intl, whose own `TextDirection` would
// otherwise shadow the `dart:ui` one this screen sets RTL with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/order_card.dart';
import '../constants/order_formatting.dart';
import '../constants/order_mock_data.dart';
import '../widgets/order_detail/receipt_breakdown.dart';
import '../widgets/order_top_bar.dart';
import 'order_detail_screen.dart';

/// The SADAD hand-off: the biller and invoice numbers to type into a
/// banking app, over the same collapsible breakdown the receipt shows.
class InvoicePaymentScreen extends StatefulWidget {
  const InvoicePaymentScreen({super.key});

  @override
  State<InvoicePaymentScreen> createState() => _InvoicePaymentScreenState();
}

class _InvoicePaymentScreenState extends State<InvoicePaymentScreen> {
  /// The breakdown opens with the screen — the customer is here to check
  /// what they are about to pay — and folds to the total on demand.
  bool _detailsExpanded = true;

  void _toggleDetails() => setState(() => _detailsExpanded = !_detailsExpanded);

  void _confirm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const OrderDetailScreen(
          orderId: 'mock',
          mockState: MockOrderState.paid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.lg,
                  AppSpacing.gutter,
                  AppSpacing.orderScreenBottomPadding,
                ),
                children: [
                  OrderTopBar(
                    notificationCount: OrderMockData.notificationCount,
                    onBack: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SadadCard(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    InvoicePaymentKeys.sadadNote.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: AppFontSizes.micro,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  OrderCard(
                    child: ReceiptBreakdown(
                      invoices: _invoices(),
                      total: OrderFormatting.money(OrderMockData.receiptTotal),
                      expanded: _detailsExpanded,
                      onToggleExpanded: _toggleDetails,
                      bordered: false,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {},
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
                  ),
                ],
              ),
              Positioned(
                left: AppSpacing.gutter,
                right: AppSpacing.gutter,
                bottom: AppSpacing.xl,
                child: SizedBox(
                  height: AppSizes.orderConfirmButtonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(OrderCard.radius),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _confirm,
                    child: Text(
                      InvoicePaymentKeys.confirmAndComplete.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSizes.title,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The current order plus the deferred invoice standing behind it.
List<ReceiptInvoice> _invoices() {
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

/// Invoice identity, boxed in the SADAD colourway.
class _SadadCard extends StatelessWidget {
  const _SadadCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(OrderCard.radius),
        border: Border.all(color: AppColors.warningOrange),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      InvoicePaymentKeys.invoiceDetails.tr(),
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: AppFontSizes.title,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text(
                      OrderMockData.receiptReference,
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: AppFontSizes.footnote,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SvgPicture.asset(
                AppAssets.sadaadLogo,
                height: AppSizes.orderInvoiceLogoHeight,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _CopyableNumber(
                  label: InvoicePaymentKeys.invoiceNumber.tr(),
                  value: OrderMockData.invoiceNumber,
                  highlighted: true,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _CopyableNumber(
                  label: InvoicePaymentKeys.billerNumber.tr(),
                  value: OrderMockData.billerNumber,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                InvoicePaymentKeys.validUntil.tr(),
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppFontSizes.footnote,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Flexible(
                child: Text(
                  OrderMockData.invoiceValidUntil,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: AppFontSizes.footnote,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A labelled reference the customer has to retype into their banking app,
/// with the copy affordance that saves them from doing so.
class _CopyableNumber extends StatelessWidget {
  const _CopyableNumber({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;

  /// The invoice number is chipped in the design; the biller number is not.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final number = Text(
      value,
      maxLines: 1,
      style: const TextStyle(
        color: AppColors.navy,
        fontSize: AppFontSizes.titleLarge,
        fontWeight: FontWeight.w800,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.grey,
            fontSize: AppFontSizes.footnote,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Flexible(
              child: highlighted
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSizes.orderChipPaddingV,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blueTintAlt,
                        borderRadius: BorderRadius.circular(
                          AppSizes.orderChipRadius,
                        ),
                      ),
                      child: number,
                    )
                  : number,
            ),
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: () => Clipboard.setData(ClipboardData(text: value)),
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(
                AppAssets.copyIcon,
                width: AppSizes.orderInvoiceCopyIconSize,
                height: AppSizes.orderInvoiceCopyIconSize,
                colorFilter: const ColorFilter.mode(
                  AppColors.green,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
