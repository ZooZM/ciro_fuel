import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'credit_amount.dart';
import 'credit_stepper_button.dart';

/// The figure being requested, with ‏+‎ and ‏−‎ either side of it.
///
/// The keys are listed plus-first so that, under this page's right-to-left
/// direction, ‏+‎ lands on the right as designed.
class CreditAmountStepper extends StatelessWidget {
  const CreditAmountStepper({
    required this.amount,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  final double amount;
  final VoidCallback onIncrement;

  /// Null at the floor — the key stays, greyed.
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
        boxShadow: AppColors.shadowCard,
      ),
      child: Row(
        children: [
          CreditStepperButton(icon: Icons.add, onTap: onIncrement),
          Expanded(
            child: CreditAmount(
              amount: amount,
              color: AppColors.heading,
              stacked: true,
            ),
          ),
          CreditStepperButton(icon: Icons.remove, onTap: onDecrement),
        ],
      ),
    );
  }
}
