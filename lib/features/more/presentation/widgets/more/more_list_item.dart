import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// One tappable row of a [MoreCard]: a leading glyph, the title, and
/// whatever the row shows on its trailing edge.
///
/// The leading glyph is either [iconPath] artwork or, where design has not
/// supplied any, the closest Material [icon]. The trailing edge shows
/// [trailingWidget] if given, else [trailingText] followed by a chevron,
/// else the chevron alone.
class MoreListItem extends StatelessWidget {
  const MoreListItem({
    required this.title,
    required this.onTap,
    this.iconPath,
    this.icon,
    this.trailingText,
    this.trailingWidget,
    super.key,
  }) : assert(
         iconPath != null || icon != null,
         'Provide an asset path or a Material icon.',
       );

  final String title;
  final VoidCallback onTap;
  final String? iconPath;
  final IconData? icon;
  final String? trailingText;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.tile),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Row(
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath!,
                width: AppSizes.moreListIconSize,
                height: AppSizes.moreListIconSize,
              )
            else
              Icon(
                icon,
                size: AppSizes.moreListIconSize,
                color: AppColors.mutedLabel,
              ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: AppFontSizes.title,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slateCharcoal,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: AppFontSizes.bodyLarge,
                  color: AppColors.warmGray,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            if (trailingWidget != null)
              trailingWidget!
            else
              // `arrow_forward_ios` is a matchTextDirection icon, so on this
              // right-to-left page it mirrors into the '<' the design draws.
              const Icon(
                Icons.arrow_forward_ios,
                size: AppSizes.icon16,
                color: AppColors.warmGray,
              ),
          ],
        ),
      ),
    );
  }
}
