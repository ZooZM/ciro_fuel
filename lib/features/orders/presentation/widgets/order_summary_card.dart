import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/order_card.dart';
import '../constants/order_formatting.dart';
import '../constants/order_mock_data.dart';

/// The "ملخص الطلب" card: fuel/quantity/price/total, then the
/// fees-plus-tax-equals-total breakdown row.
///
/// Shared by the create-order form (where the totals move as the customer
/// picks a quantity) and the order-detail screen (where they're fixed).
class OrderSummaryCard extends StatelessWidget {
  OrderSummaryCard({
    super.key,
    this.fuelType = OrderMockData.summaryFuelGrade,
    String? quantity,
    String? pricePerLiter,
    String? totalWithTax,
    String? transportFees,
    String? vat,
    String? finalTotal,
  }) : quantity =
           quantity ?? OrderFormatting.litres(OrderMockData.quantityLitres),
       pricePerLiter =
           pricePerLiter ??
           OrderFormatting.moneyLong(OrderMockData.pricePerLitre),
       totalWithTax =
           totalWithTax ??
           OrderFormatting.moneyLong(OrderMockData.summaryTotal),
       transportFees =
           transportFees ??
           OrderFormatting.moneyLong(OrderMockData.transportFees),
       vat = vat ?? OrderFormatting.moneyLong(OrderMockData.vat),
       finalTotal =
           finalTotal ??
           OrderFormatting.moneyLong(OrderMockData.summaryTotal);

  final String fuelType;
  final String quantity;
  final String pricePerLiter;

  /// Value of the fuel line itself, shown blue in the top row.
  final String totalWithTax;
  final String transportFees;
  final String vat;

  /// Fuel total plus fees and VAT, shown green in the bottom row. Distinct
  /// from [totalWithTax] — the create-order form computes them separately.
  final String finalTotal;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.navy,
                size: AppSizes.iconLg,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  OrderDetailKeys.orderSummary.tr(),
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: AppFontSizes.subtitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  valueColor: AppColors.blue,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Divider(
              color: AppColors.itemBorder,
              height: AppSizes.dividerThickness,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailKeys.transportFees.tr(),
                  value: transportFees,
                ),
              ),
              const _Operator('+'),
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailKeys.vat.tr(),
                  value: vat,
                ),
              ),
              const _Operator('='),
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailKeys.finalTotal.tr(),
                  value: finalTotal,
                  valueColor: AppColors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The `+` / `=` between the fee columns. Padded down so it reads against
/// the values rather than the labels above them.
class _Operator extends StatelessWidget {
  const _Operator(this.symbol);

  final String symbol;

  static const _baselineNudge = 14.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: _baselineNudge),
      child: Text(
        symbol,
        style: const TextStyle(
          color: AppColors.blue,
          fontSize: AppFontSizes.titleLarge,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  const _SummaryColumn({
    required this.title,
    required this.value,
    this.valueColor = AppColors.navy,
  });

  final String title;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.grey,
            fontSize: AppFontSizes.micro,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        // Four columns share the card's width, and a six-figure total is
        // wider than its quarter of it — scale rather than clip.
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: valueColor,
              fontSize: AppFontSizes.footnote,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
