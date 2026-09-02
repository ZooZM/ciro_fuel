import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:mobile_app/features/auth/presentation/cubit/login_form_state.dart';
import 'package:mobile_app/features/auth/presentation/widgets/biometric_button.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// Primary call to action. Shape, colour and height come from
/// `elevatedButtonTheme`, so this widget only decides its content.
class SignInButton extends StatelessWidget {
  const SignInButton({
    required this.isLoading,
    required this.onPressed,
    super.key,
    required this.signInWithBiometrics,
    required this.form,
  });

  final bool isLoading;
  final VoidCallback? onPressed;
  final VoidCallback signInWithBiometrics;
  final LoginFormState form;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? SizedBox.square(
                  dimension: AppSizes.progressDiameter,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.progressStrokeWidth,
                    color: context.colors.surface,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LoginKeys.submit.tr()),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Icons.arrow_forward, size: AppSizes.iconLg),
                  ],
                ),
        ),
        if (form.supportsBiometrics) ...[
          BiometricButton(
            method: form.biometricMethod,
            onPressed: signInWithBiometrics,
          ),
          // const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}
