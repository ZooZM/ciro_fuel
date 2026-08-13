import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// اتصال مباشر — the quickest way to a human.
///
/// The label is centred on the button while the handset sits at the leading
/// edge, so the two are stacked rather than laid out in a row: a row would
/// pull the label off centre by the width of the glyph.
class SupportCallButton extends StatelessWidget {
  const SupportCallButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.small),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colors.blueTint,
          borderRadius: BorderRadius.circular(AppRadii.small),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              SupportKeys.directCall.tr(),
              style: TextStyle(
                fontSize: AppFontSizes.title,
                fontWeight: FontWeight.w600,
                color: context.colors.brandBlue,
              ),
            ),
            PositionedDirectional(
              start: AppSpacing.lg,
              child: SvgPicture.asset(
                AppAssets.phoneIcon,
                width: AppSizes.iconLg,
                height: AppSizes.iconLg,
                colorFilter: ColorFilter.mode(
                  context.colors.brandBlue,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
