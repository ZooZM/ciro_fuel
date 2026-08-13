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

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final colors = context.colors;
        final textStyles = context.textStyles;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Grabber
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.borderHairline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                LoginKeys.chooseCountry.tr(),
                style: textStyles.welcomeTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: CountryDialCode.values.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    thickness: 1,
                    color: colors.borderHairline,
                    indent: 20,
                    endIndent: 20,
                  ),
                  itemBuilder: (context, index) {
                    final option = CountryDialCode.values[index];
                    final isSelected = option == country;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      leading: Text(
                        option.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        option.nameKey.tr(),
                        style: textStyles.fieldInput.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? colors.brandBlue
                              : colors.textPrimary,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              option.dialCode,
                              style: textStyles.countryCode.copyWith(
                                color: isSelected
                                    ? colors.brandBlue
                                    : colors.textPrimary,
                              ),
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.check_circle,
                              color: colors.brandBlue,
                              size: 20,
                            ),
                          ] else ...[
                            const SizedBox(width: 32),
                          ],
                        ],
                      ),
                      onTap: () {
                        onChanged(option);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showCountryPicker(context),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(AppRadii.field),
        ),
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
              const SizedBox(width: AppSpacing.md),
              Container(
                width: AppSizes.dividerThickness,
                height: AppSizes.countryDividerHeight,
                color: colors.borderHairline,
              ),
              const SizedBox(width: AppSpacing.md),
              // A Row's textDirection orders its children but does not reach
              // the text inside them. Without this the leading `+` — a bidi
              // neutral — takes the ambient RTL direction and "+966" renders
              // as "966+".
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '${country.flag} ${country.dialCode}',
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
      ),
    );
  }
}
