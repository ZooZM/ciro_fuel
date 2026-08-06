import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/fuel_pump_icon.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/enums/fuel_grade.dart';
import '../../constants/create_order_strings.dart';

/// "2. نوع الوقود" — the row of selectable fuel-grade tiles. Any number of
/// grades may be selected at once, each ordered independently.
class GradeSection extends StatelessWidget {
  const GradeSection({
    required this.selectedIndices,
    required this.onToggle,
    super.key,
  });

  final Set<int> selectedIndices;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    const grades = FuelGrade.values;

    return OrderCard(
      title: CreateOrderStrings.sectionGrade,
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
            ),
          ],
        ],
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
          color: selected ? AppColors.light.greenTint : Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: selected ? AppColors.green : AppColors.itemBorder,
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
                        const Positioned(
                          top: -4,
                          right: -4,
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
                  Text(
                    grade.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.navy,
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
