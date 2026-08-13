import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import 'create_order_data.dart';
import '../../../../../core/theme/theme_context.dart';

/// "4. موعد التوصيل" — the three delivery-timing tiles.
class DeliverySection extends StatelessWidget {
  const DeliverySection({
    required this.selected,
    required this.onChanged,
    required this.onScheduleTap,
    this.scheduledDate,
    super.key,
  });

  final DeliveryOption selected;
  final ValueChanged<DeliveryOption> onChanged;

  /// جدول موعد does not select itself: the screen opens the calendar and only
  /// then reports the choice, so a dismissed dialog changes nothing.
  final VoidCallback onScheduleTap;

  /// The day picked for جدول موعد, shown in place of the tile's subtitle.
  final DateTime? scheduledDate;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      title: CreateOrderKeys.sectionDelivery.tr(),
      // The row scrolls instead of splitting the card three ways — at a third
      // of the width each label collapsed to an ellipsis.
      //
      // IntrinsicHeight so the three tiles share the tallest one's height;
      // `stretch` alone would demand infinite height inside the ListView.
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: AppSizes.orderDeliveryTileWidth,
                child: _DeliveryTile(
                  asset: AppAssets.orderScheduleIcon,
                  title: CreateOrderKeys.scheduleTitle.tr(),
                  subtitle: scheduledDate == null
                      ? CreateOrderKeys.scheduleSubtitle.tr()
                      : DateFormat.yMMMd(
                          context.locale.toLanguageTag(),
                        ).format(scheduledDate!),
                  selected: selected == DeliveryOption.schedule,
                  onTap: onScheduleTap,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: AppSizes.orderDeliveryTileWidth,
                child: _DeliveryTile(
                  asset: AppAssets.orderDateIcon,
                  title: CreateOrderKeys.todayTitle.tr(),
                  subtitle: CreateOrderKeys.todaySubtitle.tr(),
                  selected: selected == DeliveryOption.today,
                  onTap: () => onChanged(DeliveryOption.today),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: AppSizes.orderDeliveryTileWidth,
                child: _DeliveryTile(
                  asset: AppAssets.orderFlashIcon,
                  title: CreateOrderKeys.fastestTitle.tr(),
                  subtitle: CreateOrderKeys.fastestSubtitle.tr(),
                  selected: selected == DeliveryOption.fastest,
                  onTap: () => onChanged(DeliveryOption.fastest),
                ),
              ),
            ],
          ),
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
  });

  final String asset;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final glyphColor = selected ? context.colors.brandGreen : context.colors.textSecondary;
    final titleColor = selected ? context.colors.brandGreen : context.colors.textPrimary;
    final subtitleColor = selected ? context.colors.brandGreen : context.colors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? context.colors.greenTint : context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: selected ? context.colors.brandGreen : context.colors.borderHairline,
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
                        // Wraps rather than ellipsizing: a button has to spell
                        // its label out, and 'Pick a date and time' was being
                        // cut to '…e date and time' at this width. The row is
                        // `IntrinsicHeight`, so a taller tile takes the other
                        // two with it and the three stay level.
                        Text(
                          title,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Positioned(
                top: 6,
                right: 6,
                child: Icon(
                  Icons.check_circle,
                  size: AppSizes.iconSm,
                  color: context.colors.brandGreen,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
