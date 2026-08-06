import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../constants/client_home_strings.dart';

/// One order-status counter shown on the "نظرة سريعة" row.
///
/// [asset] wins over [icon] where artwork exists; counters without their
/// own artwork fall back to the closest Material glyph.
class OrderCountStat {
  const OrderCountStat({
    required this.label,
    required this.count,
    required this.color,
    this.icon,
    this.asset,
  }) : assert(icon != null || asset != null, 'Provide an icon or an asset.');

  final String label;
  final String count;
  final Color color;
  final IconData? icon;
  final String? asset;
}

/// Order-status counters. Listed so that, in RTL, تم التوصيل ends up on
/// the left and ملغاة on the right — the order shown in the design.
///
/// Rendered as four separate cards rather than one bordered strip, as
/// designed.
class QuickGlanceRow extends StatelessWidget {
  const QuickGlanceRow({required this.stats, super.key});

  final List<OrderCountStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (index, stat) in stats.indexed) ...[
          if (index > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(child: _StatCard(stat)),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.stat);

  final OrderCountStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.dashboardStatCardPaddingH,
        vertical: AppSizes.dashboardStatCardPaddingV,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(color: AppColors.itemBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Count first so it sits right-most in RTL, putting the
              // icon immediately to its left.
              Text(
                stat.count,
                style: TextStyle(
                  color: stat.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              // SvgPicture keeps the source aspect ratio, so the 17x16
              // truck would sit 1px wider than the Material glyphs beside
              // it — the SizedBox pins every icon to the same size.
              SizedBox(
                width: AppSizes.icon16,
                height: AppSizes.icon16,
                child: stat.asset == null
                    ? Icon(
                        stat.icon,
                        size: AppSizes.icon16,
                        color: stat.color,
                      )
                    : SvgPicture.asset(
                        stat.asset!,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          stat.color,
                          BlendMode.srcIn,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.dashboardStatCardRowGap),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.grey, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

/// The dashboard's default stat set — cancelled, in-preparation,
/// in-delivery and delivered order counts.
const defaultOrderCountStats = [
  OrderCountStat(
    label: ClientHomeStrings.statCancelled,
    count: '0',
    color: AppColors.red,
    icon: Icons.highlight_off,
  ),
  OrderCountStat(
    label: ClientHomeStrings.statInPreparation,
    count: '1',
    color: AppColors.amber,
    icon: Icons.hourglass_empty,
  ),
  OrderCountStat(
    label: ClientHomeStrings.statInDelivery,
    count: '3',
    color: AppColors.blue,
    icon: Icons.access_time,
  ),
  OrderCountStat(
    label: ClientHomeStrings.statDelivered,
    count: '12',
    color: AppColors.green,
    // Uses the truck artwork, so it has no Material fallback.
    asset: AppAssets.dashboardStatTruckIcon,
  ),
];
