import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_context.dart';

/// The three messaging channels offered under the call button.
///
/// Full-colour brand marks, so none of them is tinted; each carries a
/// semantic label because the artwork has no text of its own.
class SupportChannelsRow extends StatelessWidget {
  const SupportChannelsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.locale.languageCode == 'ar' ? 'او من خلال' : SupportKeys.orVia.tr(),
          style: TextStyle(
            fontSize: AppFontSizes.bodyLarge,
            color: context.colors.brandGreen,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        const _Channel(asset: AppAssets.whatsappIcon, label: SupportKeys.whatsapp),
        const SizedBox(width: AppSpacing.lg),
        const _Channel(asset: AppAssets.telegramIcon, label: SupportKeys.telegram),
        const SizedBox(width: AppSpacing.lg),
        const _Channel(asset: AppAssets.facebookIcon, label: SupportKeys.facebook),
      ],
    );
  }
}

class _Channel extends StatelessWidget {
  const _Channel({required this.asset, required this.label});

  final String asset;

  /// A key from [SupportKeys].
  final String label;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: AppSizes.supportSocialIconSize,
      height: AppSizes.supportSocialIconSize,
      semanticsLabel: label.tr(),
    );
  }
}
