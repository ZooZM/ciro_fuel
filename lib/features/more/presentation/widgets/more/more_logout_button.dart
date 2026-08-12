import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// The outlined row that ends the settings list.
///
/// While a sign-out is in flight the glyph gives way to a spinner and [onTap]
/// is dropped altogether rather than replaced with a no-op, so the row also
/// loses its ripple — a tap that does nothing but still splashes reads as
/// "didn't register, tap again".
class MoreLogoutButton extends StatelessWidget {
  const MoreLogoutButton({
    required this.isLoggingOut,
    required this.onTap,
    super.key,
  });

  final bool isLoggingOut;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoggingOut ? null : onTap,
      borderRadius: BorderRadius.circular(AppRadii.tile),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(color: AppColors.track),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoggingOut)
              const SizedBox(
                width: AppSizes.iconLg,
                height: AppSizes.iconLg,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(AppColors.errorRed),
                ),
              )
            else
              const Icon(
                Icons.logout,
                color: AppColors.errorRed,
                size: AppSizes.iconLg,
              ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              MoreKeys.logout.tr(),
              style: const TextStyle(
                fontSize: AppFontSizes.title,
                fontWeight: FontWeight.bold,
                color: AppColors.errorRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
