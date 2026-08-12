import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_action_icon.dart';

/// The reload / download / filter marks each bake a chip fill, a hairline
/// border and a coloured symbol into one file, so they cannot be tinted — the
/// dark cut has to remap every one of those roles or the chip stays a bright
/// light square on a dark screen.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  String hex(Color c) =>
      '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).toUpperCase().padLeft(6, '0')}';

  const pairs = <String, (String, String)>{
    'reload': (AppAssets.reloadIcon, AppAssets.reloadIconDark),
    'download': (AppAssets.downloadIcon, AppAssets.downloadIconDark),
    'filter': (AppAssets.filterIcon, AppAssets.filterIconDark),
    'paymentsReload': (
      AppAssets.paymentsReloadIcon,
      AppAssets.paymentsReloadIconDark,
    ),
  };

  pairs.forEach((name, pair) {
    test('$name dark cut carries no light-palette colour', () async {
      final dark = await rootBundle.loadString(pair.$2);

      // The light chip and border are the whole problem: if either survives,
      // the mark reads as a pale tile on the dark canvas.
      expect(dark, isNot(contains(hex(AppColors.light.surface2))));
      expect(dark, isNot(contains(hex(AppColors.light.borderHairline))));

      expect(dark, contains(hex(AppColors.dark.surface2)));
      expect(dark, contains(hex(AppColors.dark.borderHairline)));
    });

    test('$name cuts differ only in their colours', () async {
      final light = await rootBundle.loadString(pair.$1);
      final dark = await rootBundle.loadString(pair.$2);

      final strip = RegExp(r'#[0-9A-Fa-f]{6}');
      expect(
        dark.replaceAll(strip, '#'),
        light.replaceAll(strip, '#'),
        reason: 'the cuts must differ by nothing but colour',
      );
    });
  });

  testWidgets('each mark renders in both themes', (tester) async {
    const marks = [
      AppActionIcon.reload(),
      AppActionIcon.download(),
      AppActionIcon.filter(),
      AppActionIcon.paymentsReload(),
    ];

    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(body: Row(children: marks)),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(AppActionIcon), findsNWidgets(marks.length));
    }
  });
}
