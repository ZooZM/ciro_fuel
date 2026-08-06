// `intl` (re-exported by easy_localization) declares its own TextDirection,
// which would shadow the dart:ui one used for the fixed icon-then-text order.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_svg_icon.dart';

/// Support link and the encryption reassurance line at the foot of the card.
class LoginFooter extends StatelessWidget {
  const LoginFooter({required this.onSupportPressed, super.key});

  final VoidCallback onSupportPressed;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;

    return Column(
      children: [
        InkWell(
          onTap: onSupportPressed,
          child: _IconLine(
            asset: AppAssets.supportIcon,
            iconSize: AppSizes.iconSm,
            text: LoginKeys.support.tr(),
            style: textStyles.captionStrong,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _IconLine(
          asset: AppAssets.shieldIcon,
          iconSize: AppSizes.iconXs,
          text: LoginKeys.securityNote.tr(),
          style: textStyles.footnote,
        ),
      ],
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({
    required this.asset,
    required this.iconSize,
    required this.text,
    required this.style,
  });

  final String asset;
  final double iconSize;
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    // Icon leads the line from the physical left in both locales, as drawn.
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppSvgIcon(asset, size: iconSize, color: context.colors.brandBlue),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(text, style: style, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
