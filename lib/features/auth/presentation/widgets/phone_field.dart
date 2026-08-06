import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../domain/entities/country_dial_code.dart';

/// Mobile-number input with an inline country-code selector.
///
/// Built from a plain container rather than [InputDecoration] because the
/// frame stacks a caption *inside* the box above the number — Material's
/// floating label can only sit on the border, which is what makes the label
/// appear to escape the field. The trade-off is that this widget owns its
/// own border and error rendering; a [FormField] supplies the latter so it
/// still participates in the surrounding [Form].
///
/// The selector is pinned to the *physical* left in both text directions,
/// because a phone number always reads left-to-right.
class PhoneField extends StatelessWidget {
  const PhoneField({
    required this.controller,
    required this.country,
    required this.onCountryChanged,
    super.key,
  });

  final TextEditingController controller;
  final CountryDialCode country;
  final ValueChanged<CountryDialCode> onCountryChanged;

  /// Generous enough for formatting characters the user may type; the
  /// validator works on normalised digits, so this only stops runaway input.
  static const int _maxRawLength = 20;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final ambientDirection = Directionality.of(context);

    return FormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) => _validate(controller.text),
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(AppRadii.field),
              border: Border.all(
                color: field.hasError ? colors.brandRed : colors.borderHairline,
              ),
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CountrySelector(country: country, onChanged: onCountryChanged),
                Expanded(
                  child: Directionality(
                    textDirection: ambientDirection,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            LoginKeys.phoneLabel.tr(),
                            style: textStyles.fieldLabel,
                          ),
                          TextField(
                            controller: controller,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.telephoneNumberNational,
                            ],
                            style: textStyles.fieldInput,
                            onChanged: field.didChange,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[\d\s-]'),
                              ),
                              LengthLimitingTextInputFormatter(_maxRawLength),
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              filled: false,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              hintText: LoginKeys.phoneHint.tr(),
                              hintStyle: textStyles.fieldHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (field.hasError)
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.xs,
                left: AppSpacing.md,
                right: AppSpacing.md,
              ),
              child: Text(
                field.errorText!,
                style: textStyles.fieldLabel.copyWith(color: colors.brandRed),
              ),
            ),
        ],
      ),
    );
  }

  String? _validate(String value) {
    if (CountryDialCode.normalizeNationalNumber(value).isEmpty) {
      return LoginKeys.phoneRequired.tr();
    }
    if (!country.isValidNationalNumber(value)) {
      return LoginKeys.phoneInvalid.tr();
    }
    return null;
  }
}

class _CountrySelector extends StatelessWidget {
  const _CountrySelector({required this.country, required this.onChanged});

  final CountryDialCode country;
  final ValueChanged<CountryDialCode> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PopupMenuButton<CountryDialCode>(
      initialValue: country,
      onSelected: onChanged,
      tooltip: LoginKeys.phoneLabel.tr(),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        for (final option in CountryDialCode.values)
          PopupMenuItem(
            value: option,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                '${option.isoCode}  ${option.dialCode}',
                style: context.textStyles.fieldInput,
              ),
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.md),
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSvgIcon(
              AppAssets.phoneIcon,
              size: AppSizes.iconMd,
              color: colors.brandBlue,
            ),
            const SizedBox(width: AppSpacing.sm),
            // A Row's textDirection orders its children but does not reach
            // the text inside them. Without this the leading `+` — a bidi
            // neutral — takes the ambient RTL direction and "+966" renders
            // as "966+".
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                country.dialCode,
                style: context.textStyles.countryCode,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: AppSizes.iconSm,
              color: colors.brandBlue,
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              width: AppSizes.dividerThickness,
              height: AppSizes.countryDividerHeight,
              color: colors.borderHairline,
            ),
          ],
        ),
      ),
    );
  }
}
