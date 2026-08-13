import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';

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
    final currency = CommonKeys.riyal.tr();
    final fuelType = this.fuelType ?? FuelKeys.gasoline98.tr();
    final quantity = this.quantity ?? '20,000 ${CommonKeys.litre.tr()}';
    final pricePerLiter = this.pricePerLiter ?? '2.33 $currency';
    final totalWithTax = this.totalWithTax ?? '46,600.00 $currency';
    final transportFees = this.transportFees ?? '1,200.00 $currency';
    final vat = this.vat ?? '6,060.00 $currency';
    final finalTotal = this.finalTotal ?? '46,600.00 $currency';

    return OrderCard(
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: context.colors.textPrimary,
                size: AppSizes.iconLg,
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
