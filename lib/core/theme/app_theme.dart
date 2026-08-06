import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Builds both [ThemeData]s from the same palette so light and dark stay in
/// lockstep. Component themes (inputs, buttons) are configured here rather
/// than at each call site — a widget that wants the standard look should
/// need no `style:` argument at all.
abstract final class AppTheme {
  static ThemeData get lightTheme =>
      _themeFor(Brightness.light, AppColors.light);

  static ThemeData get darkTheme => _themeFor(Brightness.dark, AppColors.dark);

  static ThemeData _themeFor(Brightness brightness, AppPalette colors) {
    final textStyles = AppTextStyles.fromPalette(colors);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTextStyles.fontFamily,
      scaffoldBackgroundColor: colors.canvas,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.brandBlue,
        onPrimary: Colors.white,
        secondary: colors.brandGreen,
        onSecondary: brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        error: colors.brandRed,
        onError: Colors.white,
        surface: colors.surface,
        onSurface: colors.textPrimary,
      ),
      cardColor: colors.surface,
      dividerColor: colors.borderHairline,
      dividerTheme: DividerThemeData(
        color: colors.borderHairline,
        thickness: AppSizes.dividerThickness,
      ),
      textTheme: _textTheme(colors),
      inputDecorationTheme: _inputTheme(colors, textStyles),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.brandBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.brandBlue,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSizes.primaryButtonHeight),
          textStyle: textStyles.primaryButton,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadii.pill)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          minimumSize: const Size.fromHeight(AppSizes.secondaryButtonHeight),
          textStyle: textStyles.secondaryButton,
          side: BorderSide(color: colors.borderHairline),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadii.field)),
          ),
        ),
      ),
    );
  }

  static InputDecorationTheme _inputTheme(
    AppPalette colors,
    AppTextStyles textStyles,
  ) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.field),
      borderSide: BorderSide(color: color),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surface2,
      hintStyle: textStyles.fieldHint,
      labelStyle: textStyles.fieldLabel,
      floatingLabelStyle: textStyles.fieldLabel,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      border: border(colors.borderHairline),
      enabledBorder: border(colors.borderHairline),
      focusedBorder: border(colors.brandBlue),
      errorBorder: border(colors.brandRed),
      focusedErrorBorder: border(colors.brandRed),
    );
  }

  static TextTheme _textTheme(AppPalette colors) => TextTheme(
    bodyLarge: TextStyle(color: colors.textPrimary),
    bodyMedium: TextStyle(color: colors.textPrimary),
    bodySmall: TextStyle(color: colors.textSecondary),
    titleLarge: TextStyle(
      color: colors.textPrimary,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: colors.textPrimary,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(color: colors.textSecondary),
  );
}
