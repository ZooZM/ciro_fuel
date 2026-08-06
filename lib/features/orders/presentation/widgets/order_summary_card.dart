import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/order_card.dart';
import '../constants/order_detail_strings.dart';

/// The "ملخص الطلب" card: fuel/quantity/price/total, then the
/// fees-plus-tax-equals-total breakdown row.
///
/// Shared by the create-order form (where the totals move as the customer
/// picks a quantity) and the order-detail screen (where they're fixed).
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    this.fuelType = 'بنزين 98',
    this.quantity = '20,000 لتر',
    this.pricePerLiter = '2.33 ريال',
    this.totalWithTax = '46,600.00 ريال',
    this.transportFees = '1,200.00 ريال',
    this.vat = '6,060.00 ريال',
    this.finalTotal = '46,600.00 ريال',
  });

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
          const Row(
            children: [
              Icon(Icons.description_outlined, color: AppColors.navy, size: AppSizes.iconLg),
              SizedBox(width: AppSpacing.sm),
              Text(
                OrderDetailStrings.orderSummary,
                style: TextStyle(
                  color: AppColors.navy,
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
                  title: OrderDetailStrings.fuelType,
                  value: fuelType,
                ),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailStrings.quantity,
                  value: quantity,
                ),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailStrings.pricePerLiter,
                  value: pricePerLiter,
                ),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailStrings.totalWithTax,
                  value: totalWithTax,
                  valueColor: AppColors.blue,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Divider(color: AppColors.itemBorder, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailStrings.transportFees,
                  value: transportFees,
                ),
              ),
              const Text(
                '+',
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: _SummaryColumn(title: OrderDetailStrings.vat, value: vat),
              ),
              const Text(
                '=',
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: _SummaryColumn(
                  title: OrderDetailStrings.finalTotal,
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
          style: const TextStyle(color: AppColors.grey, fontSize: 10),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
