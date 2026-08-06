import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/enums/fuel_grade.dart';

/// The horizontally-shared row of fuel grade shortcuts. Sized to share the
/// available width rather than a fixed-width scrolling list — a fixed
/// width previously pushed the last grade (بنزين 91) off the edge.
///
/// Shown right-to-left in the opposite order from the create-order form's
/// grade picker — كيروسين leads here, بنزين 91 trails — so
/// [FuelGrade.values] is walked in reverse.
class QuickRequestList extends StatelessWidget {
  const QuickRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    final grades = FuelGrade.values.reversed.toList();

    return SizedBox(
      height: AppSizes.dashboardFuelTileHeight,
      child: Row(
        children: [
          for (final (index, grade) in grades.indexed) ...[
            if (index > 0) const SizedBox(width: AppSpacing.sm),
            Expanded(child: _FuelGradeTile(grade)),
          ],
        ],
      ),
    );
  }
}

class _FuelGradeTile extends StatelessWidget {
  const _FuelGradeTile(this.grade);

  final FuelGrade grade;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Opens the order form already on the grade that was tapped — the
      // badge ('95', 'D', …) is what the form matches on.
      onTap: () => context.push(AppRoutes.clientCreateOrder, extra: grade.badge),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(color: AppColors.itemBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.dashboardFuelTilePadding),
              decoration: BoxDecoration(
                color: grade.color,
                borderRadius: BorderRadius.circular(
                  AppSizes.dashboardFuelIconRadius,
                ),
              ),
              child: SizedBox(
                width: AppSizes.dashboardFuelIconSize,
                height: AppSizes.dashboardFuelIconSize,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      AppAssets.dashboardGasStationIcon,
                      width: AppSizes.dashboardFuelIconSize,
                      height: AppSizes.dashboardFuelIconSize,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    // The grade goes on the pump's body, not the middle of
                    // the icon — the nozzle takes up the right third.
                    // Centring inside the body rect keeps one-character
                    // grades ('K') and two-digit ones ('98') aligned the
                    // same. The white tint makes the body solid white, so
                    // the grade is drawn in the tile colour to stay
                    // legible.
                    Positioned(
                      left: AppSizes.dashboardFuelIconSize * AppSizes.dashboardPumpBodyLeft,
                      width: AppSizes.dashboardFuelIconSize * AppSizes.dashboardPumpBodyWidth,
                      top: AppSizes.dashboardFuelIconSize * AppSizes.dashboardPumpFaceTop,
                      height: AppSizes.dashboardFuelIconSize * AppSizes.dashboardPumpFaceHeight,
                      child: Center(
                        child: Text(
                          grade.badge,
                          style: TextStyle(
                            color: grade.color,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              grade.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
