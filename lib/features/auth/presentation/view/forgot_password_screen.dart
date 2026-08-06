import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// Placeholder destination for the "forgot password" link.
///
/// The reset flow itself (OTP request, verification, new password) is not
/// specified yet; this exists so the link on the login screen navigates
/// somewhere real rather than being a dead tap.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ForgotPasswordKeys.title.tr(),
          style: context.textStyles.welcomeTitle,
        ),
        backgroundColor: context.colors.canvas,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            ForgotPasswordKeys.body.tr(),
            textAlign: TextAlign.center,
            style: context.textStyles.welcomeSubtitle,
          ),
        ),
      ),
    );
  }
}
