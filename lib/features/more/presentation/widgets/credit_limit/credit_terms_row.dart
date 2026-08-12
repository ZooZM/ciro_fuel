import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// The line under the acknowledgements pointing at the terms the limit is
/// granted under.
class CreditTermsRow extends StatelessWidget {
  const CreditTermsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppAssets.moreTermsIcon,
          width: AppSizes.iconLg,
          height: AppSizes.iconLg,
          colorFilter: const ColorFilter.mode(
            AppColors.blue,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          CreditLimitKeys.termsLink.tr(),
          style: const TextStyle(
            fontSize: AppFontSizes.bodyLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.blue,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.info_outline,
          size: AppSizes.icon24,
          color: AppColors.blue,
        ),
      ],
    );
  }
}
