// `hide TextDirection`: easy_localization re-exports intl, whose
// TextDirection would shadow the one the lockup is forced into.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The CIRO FUEL lockup shown at the head of the signed-out support screen.
///
/// Laid out left-to-right whatever the page's direction: it is a wordmark,
/// and 'FUEL' always follows the mark.
class SupportBrandHeader extends StatelessWidget {
  const SupportBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children: [
        SvgPicture.asset(
          AppAssets.logo,
          height: AppSizes.supportLogoHeight,
        ),
        const SizedBox(width: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.only(
            top: AppSizes.supportBrandBaselineOffset,
          ),
          child: Text(
            SupportKeys.brandSuffix.tr(),
            style: const TextStyle(
              fontSize: AppFontSizes.titleLarge,
              fontWeight: FontWeight.w700,
              color: AppColors.green,
              letterSpacing: AppSizes.supportBrandLetterSpacing,
              height: AppSizes.supportBrandLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}
