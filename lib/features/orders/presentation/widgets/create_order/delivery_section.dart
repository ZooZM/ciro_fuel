import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
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
      // IntrinsicHeight so the three tiles share the tallest one's height;
      // `stretch` alone would demand infinite height inside the ListView.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _DeliveryTile(
                asset: AppAssets.orderScheduleIcon,
                title: CreateOrderKeys.scheduleTitle.tr(),
                subtitle: CreateOrderKeys.scheduleSubtitle.tr(),
                selected: selected == DeliveryOption.schedule,
                onTap: () => onChanged(DeliveryOption.schedule),
                withClock: true,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _DeliveryTile(
                asset: AppAssets.orderDateIcon,
                title: CreateOrderKeys.todayTitle.tr(),
                subtitle: CreateOrderKeys.todaySubtitle.tr(),
                selected: selected == DeliveryOption.today,
                onTap: () => onChanged(DeliveryOption.today),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
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
    );
  }
}

/// One timing option.
///
/// The glyph sits *above* the copy rather than beside it. Three tiles across
/// a phone leave roughly 90pt each; an inline icon took a third of that and
/// clipped every label to "بأسرع وق…". Stacking hands the full tile width to
/// the text, which then wraps to two lines instead of being cut.
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

  static const _iconBoxSize = 24.0;
  static const _clockGlyphSize = 10.0;
  static const _clockOffset = -2.0;

  @override
  Widget build(BuildContext context) {
    final glyphColor = selected
        ? context.colors.brandGreen
        : context.colors.textSecondary;
    final titleColor = selected
        ? context.colors.brandGreen
        : context.colors.textPrimary;
    final subtitleColor = selected
        ? context.colors.brandGreen
        : context.colors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppSizes.orderDeliveryTileMinHeight,
        ),
        decoration: BoxDecoration(
          color: selected ? context.colors.greenTint : context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: selected
                ? context.colors.brandGreen
                : context.colors.borderHairline,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Glyph(
                    asset: asset,
                    color: glyphColor,
                    selected: selected,
                    withClock: withClock,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: AppFontSizes.footnote,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: AppFontSizes.micro,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Positioned(
                top: AppSpacing.xs,
                right: AppSpacing.xs,
                child: Icon(
                  Icons.check_circle,
                  size: AppSizes.iconSm,
                  color: AppColors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Glyph extends StatelessWidget {
  const _Glyph({
    required this.asset,
    required this.color,
    required this.selected,
    required this.withClock,
  });

  final String asset;
  final Color color;
  final bool selected;
  final bool withClock;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _DeliveryTile._iconBoxSize,
      height: _DeliveryTile._iconBoxSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            asset,
            width: AppSizes.iconLg,
            height: AppSizes.iconLg,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          if (withClock)
            Positioned(
              left: _DeliveryTile._clockOffset,
              bottom: _DeliveryTile._clockOffset,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? Colors.white : AppColors.screenBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.access_time_filled,
                  size: _DeliveryTile._clockGlyphSize,
                  color: color,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
