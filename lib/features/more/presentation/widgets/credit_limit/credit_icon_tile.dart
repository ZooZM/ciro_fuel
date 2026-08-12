import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';

/// The credit-card glyph on a tinted rounded square.
///
/// Used twice at different sizes and tints — orange beside the card's title,
/// red inside its empty state — so both the box and the glyph are sized by
/// the caller.
class CreditIconTile extends StatelessWidget {
  const CreditIconTile({
    required this.background,
    required this.color,
    required this.size,
    required this.iconSize,
    super.key,
  });

  final Color background;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.tile),
      ),
      child: Center(
        child: SvgPicture.asset(
          AppAssets.morePaymentIcon,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }
}
