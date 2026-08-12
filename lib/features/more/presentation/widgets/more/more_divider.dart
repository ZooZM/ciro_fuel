import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';

/// The hairline between two rows of a [MoreCard], inset from both edges so
/// it stops short of the card's rounded corners.
class MoreDivider extends StatelessWidget {
  const MoreDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: AppSizes.dividerThickness,
      thickness: AppSizes.dividerThickness,
      color: AppColors.track,
      indent: AppSpacing.lg,
      endIndent: AppSpacing.lg,
    );
  }
}
