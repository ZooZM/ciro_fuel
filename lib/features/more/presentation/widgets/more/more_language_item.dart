import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/app_locales.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'more_language_chip.dart';

/// The اللغة row and the two choices it folds open to reveal.
///
/// Unlike the other rows this one is not a `MoreListItem`: tapping it expands
/// in place rather than pushing a screen, so it owns both the row and the
/// panel underneath.
class MoreLanguageItem extends StatelessWidget {
  const MoreLanguageItem({
    required this.isExpanded,
    required this.selectedLanguage,
    required this.onToggleExpanded,
    required this.onLanguageSelected,
    super.key,
  });

  /// Whether the two choices are showing.
  final bool isExpanded;

  /// The chosen locale, one of [AppLocales.supported].
  final Locale selectedLanguage;

  final VoidCallback onToggleExpanded;
  final ValueChanged<Locale> onLanguageSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onToggleExpanded,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssets.moreLanguageIcon,
                  width: AppSizes.moreListIconSize,
                  height: AppSizes.moreListIconSize,
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Text(
                    MoreKeys.language.tr(),
                    style: const TextStyle(
                      fontSize: AppFontSizes.title,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slateCharcoal,
                    ),
                  ),
                ),
                // The language's own name, which is already translated per
                // locale — 'العربية' under ar, 'English' under en.
                Text(
                  CommonKeys.languageName.tr(),
                  style: const TextStyle(
                    fontSize: AppFontSizes.bodyLarge,
                    color: AppColors.warmGray,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: AppSizes.moreSelectionDuration,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: AppSizes.iconLg,
                    color: AppColors.warmGray,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: MoreLanguageChip(
                    label: MoreKeys.languageArabic.tr(),
                    isSelected: selectedLanguage == AppLocales.arabic,
                    onTap: () => onLanguageSelected(AppLocales.arabic),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: MoreLanguageChip(
                    label: MoreKeys.languageEnglish.tr(),
                    isSelected: selectedLanguage == AppLocales.english,
                    onTap: () => onLanguageSelected(AppLocales.english),
                  ),
                ),
              ],
            ),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: AppSizes.moreToggleDuration,
        ),
      ],
    );
  }
}
