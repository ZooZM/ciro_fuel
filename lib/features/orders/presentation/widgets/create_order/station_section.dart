import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/create_order_strings.dart';
import 'create_order_data.dart';

/// "1. نوع الوقود" — the current-station summary plus favourite-station
/// shortcuts. (The section keeps the design's original heading, which
/// names the fuel-type step rather than the station step it actually
/// shows.)
class StationSection extends StatelessWidget {
  const StationSection({
    this.stationName = 'محطة الرحاب',
    this.stationAddress = 'جدة - طريق مكة القديم - حي البوادي',
    this.favouriteStations = kFavouriteStations,
    this.onChangeStation,
    super.key,
  });

  final String stationName;
  final String stationAddress;
  final List<Station> favouriteStations;
  final VoidCallback? onChangeStation;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      title: CreateOrderStrings.sectionStation,
      child: Column(
        children: [
          Row(
            children: [
              // `station.png` is a 1024x1024 bitmap embedded as base64 and
              // painted through an SVG <pattern>; flutter_svg does not
              // rasterise <image> elements, so it draws nothing — this is
              // that same bitmap, extracted so it can be shown directly.
              const Icon(Icons.arrow_back_ios, color: AppColors.navy, size: AppSizes.icon16),
              const SizedBox(width: AppSpacing.sm),
              Image.asset(
                AppAssets.orderStationArt,
                width: AppSizes.orderStationArtSize,
                height: AppSizes.orderStationArtSize,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          CreateOrderStrings.currentStation,
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        SvgPicture.asset(
                          AppAssets.orderPinIcon,
                          width: AppSizes.iconMd,
                          height: AppSizes.iconMd,
                          colorFilter: const ColorFilter.mode(
                            AppColors.green,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      stationName,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      stationAddress,
                      style: const TextStyle(color: AppColors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: AppSizes.dividerThickness, color: AppColors.itemBorder),
          const SizedBox(height: AppSpacing.md),
          const Row(
            children: [
              Icon(Icons.star_border_rounded, size: AppSizes.iconMd, color: AppColors.grey),
              SizedBox(width: 6),
              Text(
                CreateOrderStrings.favouriteStations,
                style: TextStyle(color: AppColors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Sharing the width rather than scrolling, so the third station
          // is never clipped off the edge.
          Row(
            children: [
              for (final (index, station) in favouriteStations.indexed) ...[
                if (index > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(child: _FavouriteStationChip(station: station)),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: onChangeStation,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  CreateOrderStrings.changeStation,
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: AppSizes.iconSm,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavouriteStationChip extends StatelessWidget {
  const _FavouriteStationChip({required this.station});

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.orderFavouriteChipRadius),
        border: Border.all(color: AppColors.itemBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  station.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  station.area,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.grey, fontSize: 9),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          SvgPicture.asset(AppAssets.orderBarePinIcon, width: AppSizes.iconSm, height: AppSizes.iconSm),
        ],
      ),
    );
  }
}
