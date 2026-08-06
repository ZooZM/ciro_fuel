import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/create_order_strings.dart';
import 'create_order_data.dart';

/// "4. موعد التوصيل" — the three delivery-timing tiles.
class DeliverySection extends StatelessWidget {
  const DeliverySection({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final DeliveryOption selected;
  final ValueChanged<DeliveryOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      title: CreateOrderStrings.sectionDelivery,
      // IntrinsicHeight so the three tiles share the tallest one's height;
      // `stretch` alone would demand infinite height inside the ListView.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _DeliveryTile(
                asset: AppAssets.orderScheduleIcon,
                title: CreateOrderStrings.scheduleTitle,
                subtitle: CreateOrderStrings.scheduleSubtitle,
                selected: selected == DeliveryOption.schedule,
                onTap: () => onChanged(DeliveryOption.schedule),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _DeliveryTile(
                asset: AppAssets.orderDateIcon,
                title: CreateOrderStrings.todayTitle,
                subtitle: CreateOrderStrings.todaySubtitle,
                selected: selected == DeliveryOption.today,
                onTap: () => onChanged(DeliveryOption.today),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _DeliveryTile(
                asset: AppAssets.orderFlashIcon,
                title: CreateOrderStrings.fastestTitle,
                subtitle: CreateOrderStrings.fastestSubtitle,
                selected: selected == DeliveryOption.fastest,
                onTap: () => onChanged(DeliveryOption.fastest),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryTile extends StatelessWidget {
  const _DeliveryTile({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.withClock = false,
  });

  final String asset;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  /// Draws the small clock the design hangs off the calendar on جدول موعد,
  /// which the shared date artwork does not carry.
  final bool withClock;

  @override
  Widget build(BuildContext context) {
    final glyphColor = selected ? AppColors.green : AppColors.grey;
    final titleColor = selected ? AppColors.green : AppColors.navy;
    final subtitleColor = selected ? AppColors.green : AppColors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(color: subtitleColor, fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          asset,
                          width: AppSizes.iconLg,
                          height: AppSizes.iconLg,
                          colorFilter: ColorFilter.mode(
                            glyphColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        if (withClock)
                          Positioned(
                            left: -2,
                            bottom: -2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white
                                    : AppColors.screenBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.access_time_filled,
                                size: 10,
                                color: glyphColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Positioned(
                top: 6,
                right: 6,
                child: Icon(Icons.check_circle, size: AppSizes.iconSm, color: AppColors.green),
              ),
          ],
        ),
      ),
    );
  }
}
