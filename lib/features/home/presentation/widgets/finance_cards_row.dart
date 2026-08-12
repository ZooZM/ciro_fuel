import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/localization/translation_keys.dart';
import 'finance_card.dart';

/// The pending-invoice and available-balance tiles side by side.
class FinanceCardsRow extends StatelessWidget {
  const FinanceCardsRow({
    required this.pendingInvoiceAmount,
    required this.availableBalanceAmount,
    super.key,
  });

  final String pendingInvoiceAmount;
  final String availableBalanceAmount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // First child renders right-most in RTL.
        Expanded(
          child: FinanceCard(
            label: HomeKeys.pendingInvoice.tr(),
            amount: pendingInvoiceAmount,
            asset: AppAssets.dashboardPendingInvoiceIcon,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: FinanceCard(
            label: HomeKeys.availableBalance.tr(),
            amount: availableBalanceAmount,
            asset: AppAssets.dashboardAvailableBalanceIcon,
          ),
        ),
      ],
    );
  }
}
