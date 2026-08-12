import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/fuel_pump_icon.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/enums/fuel_grade.dart';

/// "2. نوع الوقود" — the row of selectable fuel-grade tiles. Exactly one
/// grade is on order at a time; picking another replaces it.
class GradeSection extends StatelessWidget {
  const GradeSection({
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });

  /// Index into [FuelGrade.values], or null before anything is chosen.
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const grades = FuelGrade.values;

    return OrderCard(
      title: CreateOrderKeys.sectionGrade.tr(),
      child: Row(
        children: [
          for (final (index, grade) in grades.indexed) ...[
            if (index > 0) const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _GradeTile(
                grade: grade,
                selected: selectedIndices.contains(index),
                onTap: () => onToggle(index),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GradeTile extends StatelessWidget {
  const _GradeTile({
    required this.grade,
    required this.selected,
    required this.onTap,
  });

  final FuelGrade grade;
  final bool selected;
  final VoidCallback onTap;

  static const _checkOffset = -4.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.orderGradeTileHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected ? context.colors.greenTint : context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: selected ? context.colors.brandGreen : context.colors.borderHairline,
            width: selected
                ? AppSizes.orderTileSelectedBorderWidth
                : AppSizes.orderTileBorderWidth,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  FuelPumpIcon(
                    grade: grade.badge,
                    color: grade.color,
                    size: AppSizes.orderGradePumpIconSize,
                  ),
                  if (selected)
                    const Positioned(
                      top: _checkOffset,
                      right: _checkOffset,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: AppSizes.iconMd,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              // Five grades across a phone leave ~60pt each; scaling the
              // label keeps "بنزين 95" whole instead of ellipsising it.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  grade.title,
                  maxLines: 1,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: AppFontSizes.caption,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
