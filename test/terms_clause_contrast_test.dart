import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/more/presentation/view/client_terms_screen.dart';

import 'helpers/localized_harness.dart';

/// The terms screen sets each clause on a green-tinted card. Under dark mode
/// that tint has to actually go dark, or the (now light) body text sits on a
/// pale mint ground and cannot be read.
void main() {
  /// WCAG relative luminance.
  double luminance(Color c) => c.computeLuminance();

  /// WCAG contrast ratio between two opaque colours.
  double contrast(Color a, Color b) {
    final la = luminance(a), lb = luminance(b);
    final hi = la > lb ? la : lb;
    final lo = la > lb ? lb : la;
    return (hi + 0.05) / (lo + 0.05);
  }

  test('the dark green tint is genuinely dark', () {
    expect(
      luminance(AppColors.dark.greenTint),
      lessThan(0.1),
      reason: 'a pale mint card would swallow the light body text',
    );
    expect(luminance(AppColors.light.greenTint), greaterThan(0.7));
  });

  test('clause text stays legible on the dark tint', () {
    final bg = AppColors.dark.greenTint;
    // Body copy is the tightest case; WCAG AA for normal text is 4.5:1.
    expect(contrast(AppColors.dark.textSecondary, bg), greaterThan(4.5));
    expect(contrast(AppColors.dark.textPrimary, bg), greaterThan(7.0));
  });

  testWidgets('the clause card paints the dark tint under a dark theme', (
    tester,
  ) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      const ClientTermsScreen(),
      theme: AppTheme.darkTheme,
    );
    expect(tester.takeException(), isNull);

    final fills = tester
        .widgetList<Container>(find.byType(Container))
        .map((c) => c.decoration)
        .whereType<BoxDecoration>()
        .map((d) => d.color)
        .whereType<Color>()
        .toSet();

    expect(
      fills,
      contains(AppColors.dark.greenTint),
      reason: 'no clause card is drawn in the dark tint',
    );
    expect(
      fills,
      isNot(contains(AppColors.light.greenTint)),
      reason: 'a light tint leaked into the dark theme',
    );
  });
}
