import 'package:flutter/widgets.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Call-site sugar for the two token lookups every screen needs. Kept in its
/// own file so `app_colors.dart` and `app_text_styles.dart` stay
/// dependency-free of each other.
extension ThemeContextX on BuildContext {
  /// `context.colors.brandBlue`
  AppPalette get colors => AppColors.of(this);

  /// `context.textStyles.welcomeTitle`
  AppTextStyles get textStyles => AppTextStyles.of(this);
}
