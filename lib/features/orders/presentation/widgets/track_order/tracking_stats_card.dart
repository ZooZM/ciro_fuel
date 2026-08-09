import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/order_mock_data.dart';

/// Status, remaining distance and ETA, measured off the design: the
/// status and ETA groups need about half again the room of the distance
/// one.
class TrackingStatsCard extends StatelessWidget {
  const TrackingStatsCard({
    this.statusLabel,
    this.distance = OrderMockData.remainingDistance,
    this.etaTime = OrderMockData.etaTime,
    this.etaDate = OrderMockData.etaDate,
    super.key,
  });

  /// Defaults to قيد التوصيل, resolved at build so the copy follows the
  /// locale rather than being frozen into a const default.
  final String? statusLabel;

  final String distance;
  final String etaTime;
  final String etaDate;

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
                    width: AppSizes.orderStatIconSize,
                    height: AppSizes.orderStatIconSize,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          OrderDetailKeys.orderStatus.tr(),
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: AppFontSizes.nano,
                          ),
                        ),
                        Row(
                          children: [
                            const _Dot(),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                statusLabel ??
                                    OrderDetailKeys.inDelivery.tr(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.green,
                                  fontSize: AppFontSizes.caption,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          TrackOrderKeys.onTheWay.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: AppFontSizes.nano,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const _Divider(),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TrackOrderKeys.remainingDistance.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: AppFontSizes.nano,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    distance,
                    maxLines: 1,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: AppFontSizes.body,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const _Divider(),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TrackOrderKeys.expectedArrival.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: AppFontSizes.nano,
                    ),
                  ),
                  Text(
                    etaTime,
                    maxLines: 1,
                    style: const TextStyle(
                      color: AppColors.green,
                      fontSize: AppFontSizes.body,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    etaDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: AppFontSizes.nano,
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

/// The hairline between the card's three groups.
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      width: AppSizes.orderDividerWidth,
      thickness: AppSizes.dividerThickness,
      color: AppColors.itemBorder,
    );
  }
}

/// The small green disc the tracking header sets before قيد التوصيل.
class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.orderStatusDotSize,
      height: AppSizes.orderStatusDotSize,
      decoration: const BoxDecoration(
        color: AppColors.green,
        shape: BoxShape.circle,
      ),
    );
  }
}
