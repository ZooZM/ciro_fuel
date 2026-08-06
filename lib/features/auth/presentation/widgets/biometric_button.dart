import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/security/biometric_authenticator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_svg_icon.dart';

/// Circular biometric unlock control, captioned with whichever modality the
/// device actually offers. The caller is responsible for not rendering this
/// at all when no biometrics are enrolled — see
/// `LoginFormState.supportsBiometrics`.
class BiometricButton extends StatelessWidget {
  const BiometricButton({
    required this.method,
    required this.onPressed,
    super.key,
  });

  final BiometricMethod method;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isFace = method == BiometricMethod.face;
    final label = (isFace ? LoginKeys.faceId : LoginKeys.fingerprint).tr();

    return Column(
      children: [
        Semantics(
          button: true,
          label: label,
          child: Material(
            color: colors.surface,
            shape: CircleBorder(side: BorderSide(color: colors.borderHairline)),
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: SizedBox.square(
                dimension: AppSizes.biometricButtonDiameter,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: AppColors.shadowCard,
                  ),
                  child: Center(
                    child: AppSvgIcon(
                      isFace ? AppAssets.faceIdIcon : AppAssets.fingerprintIcon,
                      size: AppSizes.iconXl,
                      color: colors.brandBlue,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        ExcludeSemantics(child: Text(label, style: context.textStyles.caption)),
      ],
    );
  }
}
