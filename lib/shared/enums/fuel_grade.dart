import 'package:flutter/material.dart';

import '../../core/localization/translation_keys.dart';
import 'fuel_type.dart';

/// A selectable fuel grade, with the badge/tile colour it's drawn in on
/// both the home dashboard's quick-request shelf and the create-order
/// form.
///
/// Colours are Tailwind-style swatches distinct from the app's brand
/// palette — each grade gets its own recognisable tile colour rather than
/// a semantic brand token — so they live on the enum itself rather than in
/// `AppColors`.
///
/// [type] is null for grades the backend catalogue does not model yet
/// (gasoline 98, kerosene).
enum FuelGrade {
  gasoline91(FuelKeys.gasoline91, '91', Color(0xFFDC2626), FuelType.gasoline91),
  gasoline95(FuelKeys.gasoline95, '95', Color(0xFF9333EA), FuelType.gasoline95),
  gasoline98(FuelKeys.gasoline98, '98', Color(0xFF16A34A), null),
  diesel(FuelKeys.diesel, 'D', Color(0xFFF97316), FuelType.diesel),
  kerosene(FuelKeys.kerosene, 'K', Color(0xFF2563EB), null);

  const FuelGrade(this.titleKey, this.badge, this.color, this.type);

  /// Translation key for the grade's display name — call `.tr()` on it at the
  /// point of use so the label follows a locale switch.
  final String titleKey;

  /// What the order form matches on when a tile is tapped.
  final String badge;
  final Color color;
  final FuelType? type;
}
