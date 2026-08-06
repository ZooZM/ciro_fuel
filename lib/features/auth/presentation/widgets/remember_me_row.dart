// `intl` (re-exported by easy_localization) declares its own TextDirection,
// which would shadow the dart:ui one used for the fixed box-then-label order.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// "Remember me" on one side, "Forgot password?" on the other.
class RememberMeRow extends StatelessWidget {
  const RememberMeRow({
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
    super.key,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _RememberMeCheckbox(value: rememberMe, onChanged: onRememberMeChanged),
        TextButton(
          onPressed: onForgotPassword,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            LoginKeys.forgotPassword.tr(),
            style: context.textStyles.link,
          ),
        ),
      ],
    );
  }
}

/// A checkbox drawn to the Figma spec — Material's own is a fixed 18dp mark
/// inside a 48dp tap target with its own ripple, which breaks the row's
/// alignment. Semantics are declared explicitly so it still reads as a
/// checkbox to assistive tech.
class _RememberMeCheckbox extends StatelessWidget {
  const _RememberMeCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      checked: value,
      label: LoginKeys.rememberMe.tr(),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(AppSizes.checkboxRadius),
        // Box then label, unmirrored — the frame keeps the tick to the left
        // of the Arabic label rather than flipping it to the RTL start.
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.checkboxSide,
              height: AppSizes.checkboxSide,
              decoration: BoxDecoration(
                color: value ? colors.brandBlue : colors.surface,
                borderRadius: BorderRadius.circular(AppSizes.checkboxRadius),
                border: Border.all(
                  color: value ? colors.brandBlue : colors.borderHairline,
                  width: AppSizes.checkboxBorderWidth,
                ),
              ),
              child: value
                  ? Icon(
                      Icons.check,
                      size: AppSizes.iconXs,
                      color: colors.surface,
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.sm),
            ExcludeSemantics(
              child: Text(
                LoginKeys.rememberMe.tr(),
                style: context.textStyles.checkboxLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
