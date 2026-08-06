import 'package:flutter/material.dart';

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
/// (بنزين 98، كيروسين).
enum FuelGrade {
  gasoline91('بنزين 91', '91', Color(0xFFDC2626), FuelType.gasoline91),
  gasoline95('بنزين 95', '95', Color(0xFF9333EA), FuelType.gasoline95),
  gasoline98('بنزين 98', '98', Color(0xFF16A34A), null),
  diesel('ديزل', 'D', Color(0xFFF97316), FuelType.diesel),
  kerosene('كيروسين', 'K', Color(0xFF2563EB), null);

  const FuelGrade(this.title, this.badge, this.color, this.type);

  final String title;

  /// What the order form matches on when a tile is tapped.
  final String badge;
  final Color color;
  final FuelType? type;
}
