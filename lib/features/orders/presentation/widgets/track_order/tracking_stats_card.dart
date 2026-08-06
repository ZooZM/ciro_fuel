import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_detail_strings.dart';
import '../../constants/track_order_strings.dart';

/// Status, remaining distance and ETA, measured off the design: the
/// status and ETA groups need about half again the room of the distance
/// one.
class TrackingStatsCard extends StatelessWidget {
  const TrackingStatsCard({
    this.statusLabel = OrderDetailStrings.inDelivery,
    this.distance = '12.7 كم',
    this.etaTime = '04:35 م',
    this.etaDate = '02/05/2024 اليوم',
    super.key,
  });

  final String statusLabel;
  final String distance;
  final String etaTime;
  final String etaDate;

  static const _stationIconSize = 36.0;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.dashboardStationIcon,
                    width: _stationIconSize,
                    height: _stationIconSize,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          OrderDetailStrings.orderStatus,
                          style: TextStyle(color: AppColors.grey, fontSize: 8),
                        ),
                        Row(
                          children: [
                            const _Dot(),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                statusLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.green,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          TrackOrderStrings.onTheWay,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppColors.grey, fontSize: 7),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              width: 14,
              thickness: AppSizes.dividerThickness,
              color: AppColors.itemBorder,
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    TrackOrderStrings.remainingDistance,
                    style: TextStyle(color: AppColors.grey, fontSize: 8),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    distance,
                    maxLines: 1,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              width: 14,
              thickness: AppSizes.dividerThickness,
              color: AppColors.itemBorder,
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    TrackOrderStrings.expectedArrival,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.grey, fontSize: 8),
                  ),
                  Text(
                    etaTime,
                    maxLines: 1,
                    style: const TextStyle(
                      color: AppColors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    etaDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.grey, fontSize: 7),
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

/// The small green disc the tracking header sets before قيد التوصيل.
class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
    );
  }
}
