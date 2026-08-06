import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_svg_icon.dart';

/// Password input.
///
/// The lock glyph mirrors the phone field's icon placement (physical left);
/// the reveal toggle takes the opposite slot. The toggle is an addition to
/// the Figma frame — a password field with no way to check what was typed
/// is a common source of failed sign-ins on mobile keyboards.
class PasswordField extends StatelessWidget {
  const PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final lock = Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: AppSvgIcon(
        AppAssets.lockIcon,
        size: AppSizes.iconMd,
        color: colors.brandBlue,
      ),
    );

    final revealToggle = IconButton(
      onPressed: onToggleObscure,
      iconSize: AppSizes.iconLg,
      color: colors.textTertiary,
      tooltip: (obscure ? LoginKeys.showPassword : LoginKeys.hidePassword).tr(),
      icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
    );

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      style: context.textStyles.fieldInput,
      onFieldSubmitted: (_) => onSubmitted(),
      validator: (value) => (value == null || value.isEmpty)
          ? LoginKeys.passwordRequired.tr()
          : null,
      decoration: InputDecoration(
        hintText: LoginKeys.passwordHint.tr(),
        prefixIcon: isRtl ? revealToggle : lock,
        suffixIcon: isRtl ? lock : revealToggle,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}
