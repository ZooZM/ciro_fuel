import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_top_bar.dart';

import 'helpers/localized_harness.dart';

/// Material's iOS-style arrows and chevrons all declare
/// `matchTextDirection: true`, so Flutter mirrors them under RTL on its own.
/// Choosing a different icon per direction on top of that mirrors twice and
/// lands on the wrong glyph — which is what pointed the top bar's back button
/// the wrong way in Arabic.
void main() {
  test('the arrows in use all mirror themselves', () {
    for (final icon in [
      Icons.arrow_back_ios_new,
      Icons.arrow_back_ios,
      Icons.arrow_forward_ios,
      Icons.chevron_right,
      Icons.chevron_left,
    ]) {
      expect(
        icon.matchTextDirection,
        isTrue,
        reason: 'code relies on Flutter mirroring $icon',
      );
    }
  });

  for (final (name, locale) in [
    ('Arabic', AppLocales.arabic),
    ('English', AppLocales.english),
  ]) {
    testWidgets('the top bar picks one back arrow under $name', (tester) async {
      await loadTajawal();
      await pumpLocalized(
        tester,
        const Scaffold(body: AppTopBar()),
        locale: locale,
        theme: AppTheme.lightTheme,
      );

      // One icon, the same one either way: the mirroring is Flutter's job.
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
      expect(
        find.byIcon(Icons.arrow_forward_ios),
        findsNothing,
        reason: 'swapping the icon by direction mirrors it twice',
      );
    });
  }
}
