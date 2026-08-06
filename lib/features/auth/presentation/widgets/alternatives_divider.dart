import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// "Or sign in with" — a rule broken by a caption, separating the password
/// form from the alternative sign-in methods below it.
class AlternativesDivider extends StatelessWidget {
  const AlternativesDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            LoginKeys.alternativesDivider.tr(),
            style: context.textStyles.dividerLabel,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
