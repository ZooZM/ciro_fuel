import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Files the request. Both acknowledgements are ticked by default; untick one
/// and the button dims and stops responding rather than disappearing.
class CreditSubmitButton extends StatelessWidget {
  const CreditSubmitButton({
    required this.isEnabled,
    required this.onPressed,
    super.key,
  });

  final bool isEnabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1 : AppSizes.creditSubmitDisabledOpacity,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
          // The lift is dropped along with the tap, so a dimmed button does
          // not still read as floating above the form.
          boxShadow: isEnabled ? AppColors.shadowFloating : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
            onTap: isEnabled ? onPressed : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.space18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.morePaymentIcon,
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    CreditLimitKeys.submit.tr(),
                    style: const TextStyle(
                      fontSize: AppFontSizes.title,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
