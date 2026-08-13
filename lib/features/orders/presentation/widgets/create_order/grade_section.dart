import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/fuel_pump_icon.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/enums/fuel_grade.dart';
import '../../../../../core/theme/theme_context.dart';

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
      // Five grades share this row; splitting the card between them left the
      // names ellipsized, so each tile keeps its own width and the row
      // scrolls.
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final (index, grade) in grades.indexed) ...[
              if (index > 0) const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: AppSizes.orderGradeTileWidth,
                child: _GradeTile(
                  grade: grade,
                  selected: selectedIndex == index,
                  onTap: () => onSelect(index),
                ),
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

  static const _pumpIconSize = 38.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.orderGradeTileHeight,
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
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      FuelPumpIcon(
                        grade: grade.badge,
                        color: grade.color,
                        size: _pumpIconSize,
                      ),
                      if (selected)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.colors.surface,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              size: AppSizes.iconMd,
                              color: context.colors.brandGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // No ellipsis: the tile spells the grade out, wrapping to a
                  // second line inside the tile's height if it has to.
                  Text(
                    grade.titleKey.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
