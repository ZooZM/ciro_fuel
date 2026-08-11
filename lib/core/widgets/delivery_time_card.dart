// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../localization/translation_keys.dart';
import 'date_time_row.dart';
import '../theme/theme_context.dart';
import 'order_card.dart';

/// The delivery-time panel: when and where the load is due, against the station
/// artwork that bleeds off the card's leading edge.
///
/// Every stage of the order shows it, so it lives here rather than in any one
/// screen.
class DeliveryTimeCard extends StatelessWidget {
  const DeliveryTimeCard({
    super.key,
    this.date,
    this.time,
    this.station,
  });

  final String? date;
  final String? time;

  /// Address only — the leading "Station" word is part of the layout.
  final String? station;

  static const _art = 'assets/Order/station_icon.svg';

  /// The forecourt artwork. The card draws three SVGs now — this one and the
  /// two glyphs on the date and time lines — so the layout test needs a
  /// handle on the one it measures against.
  static const Key artworkKey = Key('delivery-time-artwork');

  /// The date and time lines are drawn larger here than on the list cards.
  static const double _lineIcon = 18;

  static TextStyle _lineStyle(BuildContext context) =>
      TextStyle(color: context.colors.textPrimary, fontSize: 13);

  // The forecourt is pinned to the card's trailing edge and overhangs it, so
  // the copy has to keep a band clear or it runs underneath. Giving the
  // artwork an explicit width is what makes that band a known quantity —
  // `fitHeight` alone sized it off the card's height, so how much it covered
  // depended on how tall the card happened to be.
  static const double _artWidth = 116;
  static const double _artOverhang = 4;
  static const double _artGap = 8;

  /// How far the artwork reaches in from the padded content box's trailing
  /// edge. The Arabic address stopped just short of it; the longer English one
  /// did not, which is how the overlap showed up.
  static const double _artReserve =
      _artWidth - _artOverhang - OrderCard.padding + _artGap;

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final resolvedDate = date ?? (isAr ? '9 صفر 1446' : '9 Safar 1446');
    final resolvedTime = time ?? (isAr ? '06.30 صباحاً' : '06.30 AM');
    final resolvedStation = station ?? (isAr ? 'طريق أنس بن مالك، حي الملقا' : 'Anas Bin Malik Road, Al Malqa District');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(OrderCard.radius),
        border: Border.all(color: context.colors.borderHairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Overhangs the card so the forecourt runs to the edges.
          Positioned.directional(
            textDirection: Directionality.of(context),
            end: -_artOverhang,
            top: 14,
            bottom: 10,
            width: _artWidth,
            child: Transform.scale(
              // The forecourt is drawn facing the way it needs to sit on the
              // card's left edge, where Arabic puts it. Under English it moves
              // to the right edge and has to mirror — so the flip follows the
              // layout instead of being applied unconditionally.
              scaleX: Directionality.of(context) == TextDirection.rtl ? 1 : -1,
              child: SvgPicture.asset(
                _art,
                key: artworkKey,
                // `fitHeight` inside a fixed band overflowed and got clipped,
                // which cropped the pump; `contain` keeps the whole forecourt.
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(OrderCard.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    DeliveryTimeKeys.title.tr(),
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // The heading stays centred on the card; only the body has to
                // stop short of the forecourt.
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: _artReserve),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateTimeLabel.date(
                        label: resolvedDate,
                        size: _lineIcon,
                        style: _lineStyle(context),
                      ),
                      const SizedBox(height: 12),
                      DateTimeLabel.hour(
                        label: resolvedTime,
                        size: _lineIcon,
                        style: _lineStyle(context),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: DeliveryTimeKeys.stationPrefix.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: resolvedStation,
                              style: TextStyle(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
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

