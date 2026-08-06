// `intl` (re-exported by easy_localization) declares its own TextDirection,
// which would shadow the dart:ui one this file needs for the LTR wordmark.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// The CIRO mark, wordmark and welcome copy at the top of the login screen.
class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key});

  // The wordmark and strapline are the registered logotype: always Latin,
  // always this casing, in every locale. They are brand assets rather than
  // copy, which is why they are not translation keys.
  static const String _fuelInitial = 'F';
  static const String _fuelRemainder = ' U E L';
  static const String _straplineLead = 'FUEL TRANSPORT';
  static const String _straplineJoin = ' & ';
  static const String _straplineTail = 'LOGISTICS';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(AppAssets.logo, width: AppSizes.logoWidth),
        const SizedBox(height: AppSpacing.xxs),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              Text.rich(
                TextSpan(
                  style: textStyles.wordmark,
                  children: [
                    TextSpan(
                      text: _fuelInitial,
                      style: TextStyle(color: colors.brandGreen),
                    ),
                    TextSpan(
                      text: _fuelRemainder,
                      style: TextStyle(color: colors.brandBlue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text.rich(
                TextSpan(
                  style: textStyles.tagline,
                  children: [
                    TextSpan(
                      text: _straplineLead,
                      style: TextStyle(color: colors.brandGreen),
                    ),
                    TextSpan(
                      text: _straplineJoin,
                      style: TextStyle(color: colors.textPrimary),
                    ),
                    TextSpan(
                      text: _straplineTail,
                      style: TextStyle(color: colors.brandBlue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(LoginKeys.welcomeTitle.tr(), style: textStyles.welcomeTitle),
        const SizedBox(height: AppSpacing.xs),
        Text(
          LoginKeys.welcomeSubtitle.tr(),
          textAlign: TextAlign.center,
          style: textStyles.welcomeSubtitle,
        ),
      ],
    );
  }
}
