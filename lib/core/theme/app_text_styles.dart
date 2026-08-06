import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Named, fully-formed text styles — including colour — resolved against the
/// palette for the current brightness.
///
/// Widgets ask for a style by the role it plays (`welcomeTitle`,
/// `fieldHint`) rather than assembling `TextStyle(fontSize: 12.5, ...)`
/// inline, which keeps font sizes and weights out of the widget tree
/// (Constitution Principle I) and makes both themes correct by default.
class AppTextStyles {
  const AppTextStyles._(this._colors);

  /// The Arabic-first family shipped in `assets/fonts/`. Latin glyphs are
  /// covered by the same family, so no per-locale font switch is needed.
  static const String fontFamily = 'Tajawal';

  /// Every style below is built from this, so none can silently lose the
  /// family. That matters for styles handed to a [ButtonStyle]: `Material`
  /// *replaces* the ambient `DefaultTextStyle` rather than merging with it,
  /// so a button label carrying `fontFamily: null` renders in the platform
  /// default — not in Tajawal — however the app-wide theme is configured.
  static const TextStyle _base = TextStyle(fontFamily: fontFamily);

  final AppPalette _colors;

  factory AppTextStyles.of(BuildContext context) =>
      AppTextStyles._(AppColors.of(context));

  /// For contexts that already hold a palette (e.g. building a [ThemeData]).
  const factory AppTextStyles.fromPalette(AppPalette colors) = AppTextStyles._;

  // --- Brand lockup -----------------------------------------------------
  TextStyle get wordmark => _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 8,
  );

  TextStyle get tagline => _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    letterSpacing: 2,
  );

  // --- Headings ---------------------------------------------------------
  TextStyle get welcomeTitle => _base.copyWith(
    fontSize: 21,
    fontWeight: FontWeight.w800,
    color: _colors.textPrimary,
  );

  TextStyle get welcomeSubtitle =>
      _base.copyWith(fontSize: 12.5, color: _colors.textSecondary);

  // --- Form -------------------------------------------------------------
  TextStyle get fieldInput =>
      _base.copyWith(fontSize: 14, color: _colors.textPrimary);

  TextStyle get fieldLabel =>
      _base.copyWith(fontSize: 11, color: _colors.textSecondary);

  TextStyle get fieldHint =>
      _base.copyWith(fontSize: 13, color: _colors.textTertiary);

  TextStyle get countryCode => _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: _colors.brandBlue,
  );

  TextStyle get checkboxLabel =>
      _base.copyWith(fontSize: 12.5, color: _colors.textPrimary);

  TextStyle get link => _base.copyWith(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: _colors.brandBlue,
  );

  // --- Actions ----------------------------------------------------------
  TextStyle get primaryButton =>
      _base.copyWith(fontSize: 16, fontWeight: FontWeight.w700);

  TextStyle get secondaryButton => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: _colors.textPrimary,
  );

  TextStyle get chipLabel => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: _colors.textPrimary,
  );

  // --- Supporting copy --------------------------------------------------
  TextStyle get dividerLabel =>
      _base.copyWith(fontSize: 11.5, color: _colors.textTertiary);

  TextStyle get caption =>
      _base.copyWith(fontSize: 11.5, color: _colors.textSecondary);

  TextStyle get captionStrong => _base.copyWith(
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    color: _colors.textSecondary,
  );

  TextStyle get footnote =>
      _base.copyWith(fontSize: 10.5, color: _colors.textTertiary);
}
