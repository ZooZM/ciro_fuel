// `easy_localization` re-exports intl, whose own `TextDirection` would
// otherwise shadow the `dart:ui` one this file lays the chevron out with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_mock_data.dart';
import 'create_order_data.dart';

/// "1. نوع الوقود" — the current-station summary plus favourite-station
/// shortcuts. (The section keeps the design's original heading, which
/// names the fuel-type step rather than the station step it actually
/// shows.)
class StationSection extends StatelessWidget {
  const StationSection({
    this.stationName = OrderMockData.stationName,
    this.stationAddress = OrderMockData.stationAddress,
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
      title: CreateOrderKeys.sectionStation.tr(),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.arrow_back_ios,
                color: AppColors.navy,
                size: AppSizes.icon16,
              ),
              const SizedBox(width: AppSpacing.sm),
              // `station.png` is a 1024x1024 bitmap embedded as base64 and
              // painted through an SVG <pattern>; flutter_svg does not
              // rasterise <image> elements, so it draws nothing — this is
              // that same bitmap, extracted so it can be shown directly.
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
                        Flexible(
                          child: Text(
                            CreateOrderKeys.currentStation.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.green,
                              fontSize: AppFontSizes.body,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: AppFontSizes.titleLarge,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      stationAddress,
                      maxLines: 2,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: AppFontSizes.footnote,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(
            height: AppSizes.dividerThickness,
            color: AppColors.itemBorder,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(
                Icons.star_border_rounded,
                size: AppSizes.iconMd,
                color: AppColors.grey,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                CreateOrderKeys.favouriteStations.tr(),
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppFontSizes.body,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Sharing the width rather than scrolling, so the third station
          // is never clipped off the edge.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, station) in favouriteStations.indexed) ...[
                  if (index > 0) const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _FavouriteStationChip(station: station)),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: onChangeStation,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  CreateOrderKeys.changeStation.tr(),
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: AppFontSizes.bodyLarge,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Directionality(
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.orderFavouriteChipRadius),
        border: Border.all(color: AppColors.itemBorder),
      ),
      child: Row(
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
                    fontSize: AppFontSizes.caption,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  station.area,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: AppFontSizes.micro,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          SvgPicture.asset(
            AppAssets.orderBarePinIcon,
            width: AppSizes.iconSm,
            height: AppSizes.iconSm,
          ),
        ],
      ),
    );
  }
}
