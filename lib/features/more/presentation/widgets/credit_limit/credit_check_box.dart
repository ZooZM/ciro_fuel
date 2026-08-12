import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';

/// The acknowledgement tick — a white box that gains a blue check when set.
///
/// Presentation only: the row around it owns the tap, so the box itself is
/// never a target.
class CreditCheckBox extends StatelessWidget {
  const CreditCheckBox({required this.value, super.key});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.creditCheckBoxSize,
      height: AppSizes.creditCheckBoxSize,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.small),
        border: Border.all(color: AppColors.track),
      ),
      child: value
          ? const Icon(
              Icons.check,
              size: AppSizes.iconMd,
              color: AppColors.blue,
            )
          : null,
    );
  }
}
