// `intl` (re-exported by easy_localization) declares its own TextDirection,
// which would shadow the dart:ui one used for the fixed LTR pill lockup.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/localization/app_locales.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// The floating pill that switches the app between Arabic and English.
///
/// Changing the locale also flips the whole app's text direction, which
/// `MaterialApp` handles once `context.locale` is set — no widget here has
/// to know about RTL.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surface,
      elevation: 1,
      shadowColor: colors.textPrimary,
      borderRadius: BorderRadius.circular(AppRadii.chip),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.chip),
        onTap: () => context.setLocale(AppLocales.next(context.locale)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          // Globe, then name, then chevron — a fixed lockup in both
          // locales, as drawn. Mirroring it would put the chevron on the
          // wrong side of the label it belongs to.
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language,
                size: AppSizes.iconSm,
                color: colors.brandBlue,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                CommonKeys.languageName.tr(),
                style: context.textStyles.chipLabel,
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: AppSizes.iconSm,
                color: colors.brandBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
