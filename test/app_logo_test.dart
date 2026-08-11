import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_logo.dart';

/// The wordmark ships as two files because a [ColorFilter] would flatten its
/// three colours into one. That only works while the dark cut stays a faithful
/// copy of the light one with the CIRO letterforms recoloured — these pin that
/// down, and pin down that both files are actually reachable at runtime.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<String> load(String path) => rootBundle.loadString(path);

  test('both cuts are bundled and reachable', () async {
    for (final path in [
      AppAssets.appBarLogo,
      AppAssets.appBarLogoDark,
      AppAssets.logo,
      AppAssets.logoDark,
    ]) {
      expect(await load(path), startsWith('<svg'), reason: '$path missing');
    }
  });

  test('dark cut recolours only the CIRO letterforms', () async {
    final light = await load(AppAssets.appBarLogo);
    final dark = await load(AppAssets.appBarLogoDark);

    expect(light.contains('fill="black"'), isTrue, reason: 'light premise');
    expect(dark.contains('fill="black"'), isFalse, reason: 'no black left');
    expect('fill="white"'.allMatches(dark).length, 4);

    // The blue accent and the green FUEL already read on dark: untouched.
    for (final svg in [light, dark]) {
      expect(svg.contains('fill="#1E5FFF"'), isTrue);
      expect(svg.contains('fill="#12A150"'), isTrue);
    }
    expect(
      light.replaceAll('fill="black"', 'fill="white"'),
      dark,
      reason: 'the cuts must differ by nothing but those fills',
    );
  });

  testWidgets('AppLogo renders in both themes', (tester) async {
    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      await tester.pumpWidget(
        MaterialApp(theme: theme, home: const Scaffold(body: AppLogo())),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppLogo), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
