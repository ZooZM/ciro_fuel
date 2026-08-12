// `hide TextDirection`: easy_localization re-exports intl, whose
// TextDirection would shadow the one this dialog lays out with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Asks before signing out, and resolves to `true` only if the client said
/// yes.
///
/// Signing out is easy to mis-tap on a dense settings list and drops the
/// session for real (the tokens are gone — the next launch lands on the login
/// screen), so it asks first. A barrier tap or back gesture resolves to
/// `null`, which callers must treat as "no" rather than as a confirmation.
Future<bool?> showLogoutConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => const Directionality(
      textDirection: TextDirection.rtl,
      child: _LogoutConfirmationDialog(),
    ),
  );
}

class _LogoutConfirmationDialog extends StatelessWidget {
  const _LogoutConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
      ),
      title: Text(
        MoreKeys.logout.tr(),
        style: const TextStyle(
          fontSize: AppFontSizes.titleLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.slateCharcoal,
        ),
      ),
      content: Text(
        MoreKeys.logoutConfirmation.tr(),
        style: const TextStyle(
          fontSize: AppFontSizes.bodyLarge,
          color: AppColors.mutedLabel,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            CommonKeys.cancel.tr(),
            style: const TextStyle(
              fontSize: AppFontSizes.bodyLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedLabel,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            MoreKeys.logout.tr(),
            style: const TextStyle(
              fontSize: AppFontSizes.bodyLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.errorRed,
            ),
          ),
        ),
      ],
    );
  }
}
