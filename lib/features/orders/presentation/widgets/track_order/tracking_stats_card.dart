import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../core/theme/theme_context.dart';

/// Status, remaining distance and ETA, measured off the design: the
/// status and ETA groups need about half again the room of the distance
/// one.
class TrackingStatsCard extends StatelessWidget {
  const TrackingStatsCard({
    this.statusLabel,
    this.distance,
    this.etaTime,
    this.etaDate,
    super.key,
  });

  // Nullable rather than defaulted: the placeholder copy is translated, and
  // a default parameter value has to be a compile-time constant.
  final String? statusLabel;
  final String? distance;
  final String? etaTime;
  final String? etaDate;

  static const _stationIconSize = 36.0;

  @override
  Widget build(BuildContext context) {
    final statusLabel = this.statusLabel ?? OrderDetailKeys.inDelivery.tr();
    final distance = this.distance ?? '12.7 ${CommonKeys.km.tr()}';
    final etaTime = this.etaTime ?? '04:35 م';
    final etaDate = this.etaDate ?? '02/05/2024 ${CommonKeys.today.tr()}';

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
                        Text(
                          OrderDetailKeys.orderStatus.tr(),
                          style: TextStyle(
                            color: context.colors.textSecondary,
                            fontSize: 8,
                          ),
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
                                style: TextStyle(
                                  color: context.colors.brandGreen,
                                  fontSize: 11,
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
                          style: TextStyle(
                            color: context.colors.textSecondary,
                            fontSize: 7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 14,
              thickness: AppSizes.dividerThickness,
              color: context.colors.borderHairline,
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TrackOrderKeys.remainingDistance.tr(),
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 8),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    distance,
                    maxLines: 1,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 14,
              thickness: AppSizes.dividerThickness,
              color: context.colors.borderHairline,
            ),
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
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 8),
                  ),
                  Text(
                    etaTime,
                    maxLines: 1,
                    style: TextStyle(
                      color: context.colors.brandGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    etaDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 7),
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
      decoration: BoxDecoration(
        color: context.colors.brandGreen,
        shape: BoxShape.circle,
      ),
    );
  }
}
