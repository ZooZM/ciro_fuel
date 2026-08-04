import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color forestGreen = Color(0xFF2D7919);
  static const Color slateCharcoal = Color(0xFF232324);
  static const Color warmCream = Color(0xFFF6F3EF);
  static const Color warmGray = Color(0xFF6E6A62);
  static const Color dieselBlue = Color(0xFF0063BA);
  static const Color ignitionOrange = Color(0xFFFF5810);
  static const Color ecoGreen = Color(0xFF40AD24);
  static const Color errorRed = Color(0xFFD32F2F);
  static const _LightPalette light = _LightPalette(
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

  static const _DarkPalette dark = _DarkPalette(
    // Brand
    brandBlue: Color(0xFF4C7DFF), // derived — lightened for contrast on dark bg
    brandBluePressed: Color(0xFF3A66E6), // derived
    blueTint: Color(
      0xFF1A2540,
    ), // derived — dark-mode tint (subtle blue-tinted surface)

    brandGreen: Color(0xFF2ECC71), // figma: Dark/Brand Green
    greenPressed: Color(0xFF27AE60), // derived
    greenTint: Color(0xFF16281E), // derived

    brandRed: Color(0xFFFF6B6B), // derived — lightened for contrast on dark bg
    redTint: Color(0xFF3A1F1F), // derived

    brandOrange: Color(
      0xFFFF7A3D,
    ), // derived — lightened for contrast on dark bg
    orangeTint: Color(0xFF3A2416), // derived

    brandPurple: Color(
      0xFFA976F0,
    ), // derived — lightened for contrast on dark bg
    purpleTint: Color(0xFF2B2140), // derived
    // Text
    textPrimary: Color(0xFFF5F6FA), // derived
    textSecondary: Color(0xFF9BA1AE), // figma: Dark/Text Secondary
    textTertiary: Color(
      0xFF6B7280,
    ), // derived — reused light tertiary, works on dark too
    // Surfaces
    canvas: Color(0xFF121316), // derived — near-black screen background
    surface: Color(0xFF1C1E24), // derived — cards, one step lighter than canvas
    surface2: Color(0xFF262932), // derived — chips
    sunken: Color(0xFF0D0E10), // derived — wells, darker than canvas
    borderHairline: Color(0xFF2E3038), // derived
  );
  static const List<BoxShadow> shadowCard = [
    BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 10),
  ];
  static const List<BoxShadow> shadowNav = [
    BoxShadow(color: Color(0x0F000000), offset: Offset(0, -2), blurRadius: 16),
  ];
  static const List<BoxShadow> shadowFloating = [
    BoxShadow(color: Color(0x401E5FFF), offset: Offset(0, 8), blurRadius: 24),
  ];
}

class _LightPalette {
  const _LightPalette({
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

class _DarkPalette extends _LightPalette {
  const _DarkPalette({
    required super.brandBlue,
    required super.brandBluePressed,
    required super.blueTint,
    required super.brandGreen,
    required super.greenPressed,
    required super.greenTint,
    required super.brandRed,
    required super.redTint,
    required super.brandOrange,
    required super.orangeTint,
    required super.brandPurple,
    required super.purpleTint,
    required super.textPrimary,
    required super.textSecondary,
    required super.textTertiary,
    required super.canvas,
    required super.surface,
    required super.surface2,
    required super.sunken,
    required super.borderHairline,
  });
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.light.canvas,
    colorScheme: ColorScheme.light(
      primary: AppColors.light.brandBlue,
      secondary: AppColors.light.brandGreen,
      error: AppColors.light.brandRed,
      surface: AppColors.light.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.light.textPrimary,
    ),
    cardColor: AppColors.light.surface,
    dividerColor: AppColors.light.borderHairline,
    textTheme: _textTheme(
      AppColors.light.textPrimary,
      AppColors.light.textSecondary,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.dark.canvas,
    colorScheme: ColorScheme.dark(
      primary: AppColors.dark.brandBlue,
      secondary: AppColors.dark.brandGreen,
      error: AppColors.dark.brandRed,
      surface: AppColors.dark.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: AppColors.dark.textPrimary,
    ),
    cardColor: AppColors.dark.surface,
    dividerColor: AppColors.dark.borderHairline,
    textTheme: _textTheme(
      AppColors.dark.textPrimary,
      AppColors.dark.textSecondary,
    ),
  );

  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      bodyLarge: TextStyle(color: primary),
      bodyMedium: TextStyle(color: primary),
      bodySmall: TextStyle(color: secondary),
      titleLarge: TextStyle(color: primary, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: primary, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(color: secondary),
    );
  }
}
