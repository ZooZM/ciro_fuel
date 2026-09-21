import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/localization/translation_keys.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/order_card.dart';
import '../../../../core/theme/theme_context.dart';

/// The "ملخص الطلب" card: fuel/quantity/price/total, then the
/// fees-plus-tax-equals-total breakdown row.
///
/// Shared by the create-order form (where the totals move as the customer
/// picks a quantity) and the order-detail screen (where they're fixed).
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    this.fuelType,
    this.quantity,
    this.pricePerLiter,
    this.totalWithTax,
    this.transportFees,
    this.vat,
    this.finalTotal,
  });

  // Nullable rather than defaulted: the placeholder copy carries translated
  // units, and a default parameter value has to be a compile-time constant.
  final String? fuelType;
  final String? quantity;
  final String? pricePerLiter;

  /// Value of the fuel line itself, shown blue in the top row.
  final String? totalWithTax;
  final String? transportFees;
  final String? vat;

  /// Fuel total plus fees and VAT, shown green in the bottom row. Distinct
  /// from [totalWithTax] — the create-order form computes them separately.
  final String? finalTotal;

  @override
  Widget build(BuildContext context) {
    // These defaults were a DESIGN MOCK — gasoline 98, 20,000 L at 2.33, a
    // 46,600.00 total, 1,200.00 of transport and 6,060.00 of VAT. They are
    // money, and they rendered as real figures on a real customer's real order
    // whenever a caller left a slot unset — which `order_detail_screen.dart`
    // did for four of the seven. A station owner reviewing a 1,150 SAR order
    // was shown a 46,600 SAR subtotal beside a genuine total.
    //
    // Absent, never invented — the rule the create-order form already follows
    // when no quote has been priced yet.
    const unknown = '—';
    final fuelType = this.fuelType ?? unknown;
    final quantity = this.quantity ?? unknown;
    final pricePerLiter = this.pricePerLiter ?? unknown;
    final totalWithTax = this.totalWithTax ?? unknown;
    final transportFees = this.transportFees ?? unknown;
    final vat = this.vat ?? unknown;
    final finalTotal = this.finalTotal ?? unknown;

    return OrderCard(
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.moreInvoiceIcon,
                width: AppSizes.iconLg,
                height: AppSizes.iconLg,
                colorFilter: ColorFilter.mode(
                  context.colors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                OrderDetailKeys.orderSummary.tr(),
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailKeys.fuelType.tr(),
                  value: fuelType,
                ),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailKeys.quantity.tr(),
                  value: quantity,
                ),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailKeys.pricePerLiter.tr(),
                  value: pricePerLiter,
                ),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailKeys.totalWithTax.tr(),
                  value: totalWithTax,
                  valueColor: context.colors.brandBlue,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Divider(color: context.colors.borderHairline, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailKeys.transportFees.tr(),
                  value: transportFees,
                ),
              ),
              Text(
                '+',
                style: TextStyle(
                  color: context.colors.brandBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailKeys.vat.tr(),
                  value: vat,
                ),
              ),
              Text(
                '=',
                style: TextStyle(
                  color: context.colors.brandBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailKeys.finalTotal.tr(),
                  value: finalTotal,
                  valueColor: context.colors.brandGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  const _SummaryColumn({
    required this.title,
    required this.value,
    this.valueColor,
  });

  final String title;
  final String value;

  /// Null takes the palette's primary text colour — a default cannot resolve
  /// the theme, so it is filled in at build time.
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? context.colors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
