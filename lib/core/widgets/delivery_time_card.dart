import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../localization/translation_keys.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'order_card.dart';

/// The موعد التسليم panel: when and where the load is due, against the station
/// artwork that bleeds off the card's leading edge.
///
/// Every stage of the order shows it, so it lives here rather than in any one
/// screen.
class DeliveryTimeCard extends StatelessWidget {
  const DeliveryTimeCard({
    super.key,
    required this.date,
    required this.time,
    required this.station,
  });

  final String date;
  final String time;

  /// Address only — the word محطة is part of the layout.
  final String station;

  static const _art = AppAssets.orderStationIcon;

  // The forecourt overhangs the card so it runs to the edges.
  static const _artLeft = -4.0;
  static const _artTop = 14.0;
  static const _artBottom = 10.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(OrderCard.radius),
        border: Border.all(color: AppColors.itemBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(
            left: _artLeft,
            top: _artTop,
            bottom: _artBottom,
            child: _StationArt(),
          ),
          Padding(
            padding: const EdgeInsets.all(OrderCard.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    DeliveryTimeKeys.title.tr(),
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: AppFontSizes.titleLarge,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _Line(icon: Icons.calendar_today_outlined, text: date),
                const SizedBox(height: AppSpacing.md),
                _Line(icon: Icons.access_time, text: time),
                const SizedBox(height: AppSizes.orderSectionGap),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: AppFontSizes.bodyLarge,
                    ),
                    children: [
                      TextSpan(
                        text: DeliveryTimeKeys.stationPrefix.tr(),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: station,
                        style: const TextStyle(color: AppColors.grey),
                      ),
                    ],
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

class _StationArt extends StatelessWidget {
  const _StationArt();

  @override
  Widget build(BuildContext context) =>
      SvgPicture.asset(DeliveryTimeCard._art, fit: BoxFit.fitHeight);
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSizes.iconMd, color: AppColors.green),
        const SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: AppFontSizes.body,
          ),
        ),
      ],
    );
  }
}
