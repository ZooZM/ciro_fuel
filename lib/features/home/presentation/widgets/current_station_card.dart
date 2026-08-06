import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../constants/client_home_strings.dart';

/// The client's current fuel station, with a link to change it.
class CurrentStationCard extends StatelessWidget {
  const CurrentStationCard({
    required this.name,
    required this.address,
    required this.onChangeStation,
    super.key,
  });

  final String name;
  final String address;
  final VoidCallback onChangeStation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // RTL row: the first child renders right-most, so the order
                // here is chevron, icon, then the text block filling the
                // rest. `arrow_back_ios` is mirrored under RTL
                // (matchTextDirection), so it is what actually draws the
                // '>' the design shows.
                const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.navy,
                  size: AppSizes.icon16,
                ),
                const SizedBox(width: AppSpacing.md),
                SvgPicture.asset(
                  AppAssets.dashboardStationIcon,
                  width: AppSizes.dashboardStationIconSize,
                  height: AppSizes.dashboardStationIconSize,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    // In RTL, `end` is the left edge — where the design
                    // sits this block.
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Row(
                        // Hug the content, otherwise the row spans the
                        // full width and the label snaps back to the
                        // right.
                        mainAxisSize: MainAxisSize.min,
                        // Label first so the pin lands to its left, as
                        // designed.
                        children: [
                          Text(
                            ClientHomeStrings.currentStation,
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.green,
                            size: AppSizes.icon16,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        address,
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSizes.dividerThickness,
            color: AppColors.itemBorder,
          ),
          InkWell(
            onTap: onChangeStation,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.lg,
              ),
              child: Row(
                // `end` packs the pair against the left edge; label first
                // so the chevron sits to its left. `arrow_forward_ios` is
                // mirrored under RTL, which is what draws the '<' shown.
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    ClientHomeStrings.changeStation,
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.green,
                    size: AppSizes.dashboardChangeStationIconSize,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
