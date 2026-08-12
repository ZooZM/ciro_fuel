import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';

/// One of the amount stepper's two square keys. A null [onTap] greys the
/// glyph out rather than removing the key, so the row keeps its shape.
class CreditStepperButton extends StatelessWidget {
  const CreditStepperButton({required this.icon, required this.onTap, super.key});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(AppRadii.tile),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        child: SizedBox(
          width: AppSizes.creditStepperButtonWidth,
          height: AppSizes.creditStepperButtonHeight,
          child: Icon(
            icon,
            size: AppSizes.icon22,
            color: onTap == null ? AppColors.disabledInk : AppColors.blue,
          ),
        ),
      ),
    );
  }
}
