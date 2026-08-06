import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_svg_icon.dart';

/// Apple and Google sign-in.
///
/// Presentation only for now: neither provider is wired to a backend
/// token-exchange endpoint yet, so [onProviderSelected] is expected to
/// explain that rather than start a flow.
class FederatedSignInRow extends StatelessWidget {
  const FederatedSignInRow({required this.onProviderSelected, super.key});

  final ValueChanged<FederatedProvider> onProviderSelected;

  @override
  Widget build(BuildContext context) {
    // Apple first from the physical left in both locales, matching the
    // frame — provider buttons are brand lockups, not reading-order content.
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        for (final provider in FederatedProvider.values) ...[
          if (provider != FederatedProvider.values.first)
            const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _ProviderButton(
              provider: provider,
              onPressed: () => onProviderSelected(provider),
            ),
          ),
        ],
      ],
    );
  }
}

enum FederatedProvider {
  apple(AppAssets.appleIcon, LoginKeys.continueWithApple),
  google(AppAssets.googleIcon, LoginKeys.continueWithGoogle);

  const FederatedProvider(this.iconAsset, this.labelKey);

  final String iconAsset;
  final String labelKey;
}

class _ProviderButton extends StatelessWidget {
  const _ProviderButton({required this.provider, required this.onPressed});

  final FederatedProvider provider;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      // Provider names are Latin brand marks; keep icon-then-label order
      // fixed so the lockup matches each vendor's brand guidelines.
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // `color: null` — both marks carry their own brand colours.
            AppSvgIcon(provider.iconAsset, size: AppSizes.iconMd),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                provider.labelKey.tr(),
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.secondaryButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
