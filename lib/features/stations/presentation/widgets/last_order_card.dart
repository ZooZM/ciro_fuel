import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/progress_bar.dart';
import '../constants/client_stations_mock_data.dart';

/// The most recent completed order, laid out like the payments screen's card:
/// the text column on the right, the station artwork on the left.
class LastOrderCard extends StatelessWidget {
  const LastOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: AppSpacing.lg,
        // The artwork keeps a margin off the card's left edge rather than
        // bleeding into it.
        end: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
        boxShadow: AppColors.shadowCardSoft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryRow(),
                SizedBox(height: AppSpacing.space10),
                _StatusRow(),
                SizedBox(height: AppSpacing.space10),
                _AddressLine(),
                SizedBox(height: AppSpacing.space10),
                _ScheduleRow(),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SvgPicture.asset(
            AppAssets.dashboardStationIcon,
            width: AppSizes.stationsLastOrderArtSize,
            height: AppSizes.stationsLastOrderArtSize,
          ),
        ],
      ),
    );
  }
}

/// The fuel grade and quantity, with the order's reference trailing it.
class _SummaryRow extends StatelessWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Text(
            ClientStationsMockData.lastOrderSummary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.blue,
              fontSize: AppFontSizes.body,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Text(
          ClientStationsMockData.lastOrderReference,
          style: TextStyle(color: AppColors.grey, fontSize: AppFontSizes.footnote),
        ),
      ],
    );
  }
}

/// The delivery bar, its dot, and what the order is waiting on.
class _StatusRow extends StatelessWidget {
  const _StatusRow();

  @override
  Widget build(BuildContext context) {
    // Bar first so it sits on the right under the fuel line, with the dot and
    // then the label trailing off to the left. The label is [Flexible]
    // because 'تم التسليم (الفاتورة مؤجلة)' is long enough to push the
    // fixed-width bar off the card on narrower screens.
    return Row(
      children: [
        const ProgressBar(
          progress: ClientStationsMockData.lastOrderProgress,
          color: AppColors.warningOrange,
        ),
        const SizedBox(width: AppSpacing.sm),
        const SizedBox(
          width: AppSizes.stationsStatusDotSize,
          height: AppSizes.stationsStatusDotSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.warningOrange,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            StationsKeys.deliveredDeferredInvoice.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: AppFontSizes.footnote,
            ),
          ),
        ),
      ],
    );
  }
}

/// Where it was delivered.
class _AddressLine extends StatelessWidget {
  const _AddressLine();

  @override
  Widget build(BuildContext context) {
    return const Text(
      ClientStationsMockData.lastOrderAddress,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: AppColors.blue,
        fontSize: AppFontSizes.body,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// When: the date on the right, the hour on the left.
class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppAssets.dateIcon,
          width: AppSizes.icon16,
          height: AppSizes.icon16,
        ),
        const SizedBox(width: AppSpacing.xs),
        const Text(
          ClientStationsMockData.lastOrderDate,
          style: TextStyle(
            color: AppColors.navy,
            fontSize: AppFontSizes.footnote,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.access_time,
          color: AppColors.green,
          size: AppSizes.icon16,
        ),
        const SizedBox(width: AppSpacing.xs),
        const Text(
          ClientStationsMockData.lastOrderTime,
          style: TextStyle(
            color: AppColors.navy,
            fontSize: AppFontSizes.footnote,
          ),
        ),
      ],
    );
  }
}
