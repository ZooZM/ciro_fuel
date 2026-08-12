import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';

/// One dated value — a glyph and the value it belongs to, kept together.
///
/// Every card that shows an order's date or time draws it through this, so the
/// artwork and the way it sits against the copy are settled in one place.
class DateTimeLabel extends StatelessWidget {
  const DateTimeLabel._({
    required this.asset,
    required this.label,
    required this.size,
    this.style,
  });

  /// The date glyph and its value.
  const DateTimeLabel.date({
    required String label,
    double size = 12,
    TextStyle? style,
    Key? key,
  }) : this._(
         asset: AppAssets.dashboardDateIcon,
         label: label,
         size: size,
         style: style,
       );

  /// The time glyph and its value.
  const DateTimeLabel.hour({
    required String label,
    double size = 12,
    TextStyle? style,
    Key? key,
  }) : this._(
         asset: AppAssets.dashboardHourIcon,
         label: label,
         size: size,
         style: style,
       );

  final String asset;
  final String label;
  final double size;
  final TextStyle? style;

  /// Centring the glyph against the text box leaves it looking low: the box
  /// carries descender space the copy itself does not fill, so its optical
  /// centre sits above its geometric one. Lifting the glyph — through a
  /// transform, which does not disturb the row's height — puts the two on the
  /// same line.
  static const double _lift = 1.5;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: const Offset(0, -_lift),
          child: SvgPicture.asset(asset, width: size, height: size),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style:
              style ??
              TextStyle(color: context.colors.textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}

/// The "date · time" line the order, invoice, payment and station cards all
/// carry.
///
/// Each glyph stays against the value it belongs to, and the two pairs stay
/// against each other: the cards used to put a `Spacer` between them, which
/// stranded the time at the far edge of the card with the width of the card
/// between it and the rest of the copy. A fixed [gap] keeps the line reading
/// as one phrase in both directions.
///
/// The artwork is the dashboard's, so a card in a list and the same order on
/// the home screen are drawn with the same two glyphs.
class DateTimeRow extends StatelessWidget {
  const DateTimeRow({
    required this.date,
    required this.time,
    this.iconSize = 12,
    this.fontSize = 10,
    this.textColor,
    this.gap = AppSpacing.lg,
    super.key,
  });

  final String date;
  final String time;

  final double iconSize;
  final double fontSize;

  /// Defaults to the secondary text colour.
  final Color? textColor;

  /// Space between the date pair and the time pair.
  final double gap;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: textColor ?? context.colors.textSecondary,
      fontSize: fontSize,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DateTimeLabel.date(label: date, size: iconSize, style: style),
        SizedBox(width: gap),
        DateTimeLabel.hour(label: time, size: iconSize, style: style),
      ],
    );
  }
}
