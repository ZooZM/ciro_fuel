// =============================================================================
// CIRO Fuel — App Colors
// Generated from Figma design tokens (file: "CIRO Fuel — Mobile App")
// https://www.figma.com/design/xwjDc3qJBMo5NVUJBy0gf8/
//
// SOURCE NOTES:
// - LIGHT values below are extracted directly from bound Figma variables
//   (fully defined and used consistently across the whole file).
// - DARK values marked "// figma" are extracted directly from actual bound
//   dark variables found in the file (only 2 exist: Text Secondary, Brand Green).
// - All other DARK values are DERIVED (marked "// derived") using standard
//   dark-theme conventions, since a full dark palette hasn't been designed
//   in Figma yet. Swap these out once/if Figma defines them.
// =============================================================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------
  // Ciro brand palette (mode-independent brand foundation)
  // ---------------------------------------------------------------------
  static const Color forestGreen = Color(0xFF2D7919);
  static const Color slateCharcoal = Color(0xFF232324);
  static const Color warmCream = Color(0xFFF6F3EF);
  static const Color warmGray = Color(0xFF6E6A62);
  static const Color dieselBlue = Color(0xFF0063BA);
  static const Color ignitionOrange = Color(0xFFFF5810);
  static const Color ecoGreen = Color(0xFF40AD24);
  static const Color errorRed = Color(0xFFD32F2F);

  // ---------------------------------------------------------------------
  // LIGHT THEME — extracted directly from Figma
  // ---------------------------------------------------------------------
  static const AppPalette light = AppPalette(
    // Brand
    brandBlue: Color(0xFF1E5FFF),
    brandBluePressed: Color(0xFF1650E0),
    blueTint: Color(0xFFE7EEFF),

    brandGreen: Color(0xFF12A150),
    greenPressed: Color(0xFF0E8A44),
    greenTint: Color(0xFFE4F7EC),

    brandRed: Color(0xFFEF3F3F),
    redTint: Color(0xFFFDE9E9),

    brandOrange: Color(0xFFFF5810),
    orangeTint: Color(0xFFFEEEDF),

    brandPurple: Color(0xFF8B3FE8),
    purpleTint: Color(0xFFF2E7FD),

    // Text
    textPrimary: Color(0xFF162155),
    textSecondary: Color(0xFF6B7280),
    textTertiary: Color(0xFF9CA3AF),

    // Surfaces
    canvas: Color(0xFFF4F6FA), // screen background
    surface: Color(0xFFFFFFFF), // cards
    surface2: Color(0xFFF0F2F7), // chips
    sunken: Color(0xFFEAEDF3), // wells
    borderHairline: Color(0xFFE7E9EF),
  );

  // ---------------------------------------------------------------------
  // DARK THEME — 2 tokens confirmed from Figma, rest derived
  // ---------------------------------------------------------------------
  static const AppPalette dark = AppPalette(
    // Brand
    brandBlue: Color(0xFF4C7DFF), // derived — lightened for contrast on dark bg
    brandBluePressed: Color(0xFF3A66E6), // derived
    blueTint: Color(0xFF1A2540), // derived — subtle blue-tinted dark surface

    brandGreen: Color(0xFF2ECC71), // figma: Dark/Brand Green
    greenPressed: Color(0xFF27AE60), // derived
    greenTint: Color(0xFF16281E), // derived

    brandRed: Color(0xFFFF6B6B), // derived — lightened for contrast on dark bg
    redTint: Color(0xFF3A1F1F), // derived

    brandOrange: Color(0xFFFF7A3D), // derived — lightened for dark bg
    orangeTint: Color(0xFF3A2416), // derived

    brandPurple: Color(0xFFA976F0), // derived — lightened for dark bg
    purpleTint: Color(0xFF2B2140), // derived
    // Text
    textPrimary: Color(0xFFF5F6FA), // derived
    textSecondary: Color(0xFF9BA1AE), // figma: Dark/Text Secondary
    textTertiary: Color(
      0xFF6B7280,
    ), // derived — light tertiary reads on dark too
    // Surfaces
    canvas: Color(0xFF121316), // derived — near-black screen background
    surface: Color(0xFF1C1E24), // derived — cards, one step above canvas
    surface2: Color(0xFF262932), // derived — chips
    sunken: Color(0xFF0D0E10), // derived — wells, darker than canvas
    borderHairline: Color(0xFF2E3038), // derived
  );

  /// The palette matching [context]'s current brightness. Screens read
  /// colours through this (or the `context.colors` shorthand in
  /// theme_context.dart) rather than naming [light]/[dark] directly, so a
  /// theme switch needs no edits at the call sites.
  static AppPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;

  // ---------------------------------------------------------------------
  // Elevation shadows (from Figma effect styles — light mode only)
  // ---------------------------------------------------------------------
  static const List<BoxShadow> shadowCard = [
    BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 10),
  ];
  static const List<BoxShadow> shadowNav = [
    BoxShadow(color: Color(0x0F000000), offset: Offset(0, -2), blurRadius: 16),
  ];
  static const List<BoxShadow> shadowFloating = [
    BoxShadow(color: Color(0x401E5FFF), offset: Offset(0, 8), blurRadius: 24),
  ];

  /// The login card lifts off the hero photo, so its shadow is cast upward —
  /// the inverse of [shadowNav], which sits at the bottom of the screen.
  static const List<BoxShadow> shadowSheet = [
    BoxShadow(color: Color(0x1A0F1B2E), offset: Offset(0, -8), blurRadius: 24),
  ];

  // ---------------------------------------------------------------------
  // Screens palette — the mockup-style screens (home dashboard, order
  // detail/tracking, nav bar) predate [AppPalette] and have no dark variant
  // yet, so these are mode-independent constants rather than palette
  // entries. [blue] and [red] happen to match [light]'s brandBlue/brandRed
  // exactly but are declared flat here (not routed through `light.—`)
  // because Dart won't fold a field access on a const object into a
  // constant expression, which made them unusable in the many `const`
  // widgets across these screens.
  // ---------------------------------------------------------------------
  static const Color blue = Color(0xFF1E5FFF);
  static const Color red = Color(0xFFEF3F3F);
  static const Color green = Color(0xFF17A34A);
  static const Color navy = Color(0xFF0F1B2E);
  static const Color grey = Color(0xFF8A93A6);
  static const Color screenBackground = Color(0xFFF5F6F8);
  static const Color itemBorder = Color(0xFFE6E9F0);
  static const Color amber = Color(0xFFF59E0B);

  /// Warning/pending/deferred accent used across the order screens (the
  /// order-flow "warning" step, deferred receipts, credit-limit UI).
  static const Color warningOrange = Color(0xFFF97316);

  /// Background of the muted status pill on the order-detail screen.
  static const Color chipBackground = Color(0xFFECEFF4);

  /// A second blue tint used for selected-state fills (quantity tiles,
  /// custom-order screen) and the receipt breakdown's copy-icon chip.
  /// Distinct from [AppPalette.blueTint] — a separate one-off from the same
  /// design.
  static const Color blueTintAlt = Color(0xFFEEF2FF);

  /// Tint behind the credit-card icon on the credit-limit card. Distinct
  /// from [AppPalette.orangeTint] — a separate one-off from the same design.
  static const Color creditIconBackground = Color(0xFFFFF7ED);
}

/// One resolved set of semantic colours. Both [AppColors.light] and
/// [AppColors.dark] are instances of this single type so callers can hold
/// "the current palette" without caring which mode produced it.
class AppPalette {
  const AppPalette({
    required this.brandBlue,
    required this.brandBluePressed,
    required this.blueTint,
    required this.brandGreen,
    required this.greenPressed,
    required this.greenTint,
    required this.brandRed,
    required this.redTint,
    required this.brandOrange,
    required this.orangeTint,
    required this.brandPurple,
    required this.purpleTint,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.canvas,
    required this.surface,
    required this.surface2,
    required this.sunken,
    required this.borderHairline,
  });

  final Color brandBlue;
  final Color brandBluePressed;
  final Color blueTint;
  final Color brandGreen;
  final Color greenPressed;
  final Color greenTint;
  final Color brandRed;
  final Color redTint;
  final Color brandOrange;
  final Color orangeTint;
  final Color brandPurple;
  final Color purpleTint;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color canvas;
  final Color surface;
  final Color surface2;
  final Color sunken;
  final Color borderHairline;
}
