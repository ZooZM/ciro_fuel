import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// One of the two choices the language section folds open to reveal — a
/// radio dot and its label, tinted blue once chosen.
class MoreLanguageChip extends StatelessWidget {
  const MoreLanguageChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSizes.moreSelectionDuration,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.light.blueTint : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.small),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.track,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RadioDot(isSelected: isSelected),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.bodyLarge,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.blue : AppColors.mutedLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The chip's radio: a ring that gains a filled centre when chosen.
class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.moreLanguageRadioSize,
      height: AppSizes.moreLanguageRadioSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.blue : AppColors.disabledInk,
          width: AppSizes.moreLanguageRadioBorderWidth,
        ),
      ),
      child: isSelected
          ? const Center(
              child: SizedBox(
                width: AppSizes.moreLanguageRadioDotSize,
                height: AppSizes.moreLanguageRadioDotSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.blue,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
