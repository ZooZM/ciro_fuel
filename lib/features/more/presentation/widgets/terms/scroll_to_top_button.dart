import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';

/// The white square that rides over the terms as they scroll, taking the
/// reader back to the top of the document.
class ScrollToTopButton extends StatelessWidget {
  const ScrollToTopButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.tile),
      elevation: 2,
      shadowColor: AppColors.elevationShadow,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.tile),
        onTap: onTap,
        child: Tooltip(
          message: TermsKeys.backToTop.tr(),
          child: const SizedBox(
            width: AppSizes.tapTarget,
            height: AppSizes.tapTarget,
            child: Icon(
              Icons.arrow_upward,
              size: AppSizes.icon22,
              color: AppColors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
