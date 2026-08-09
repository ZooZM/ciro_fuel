import 'package:easy_localization/easy_localization.dart';
// `Localization` and `Translations` are what `.tr()` reads from, but
// easy_localization only re-exports the widget that populates them. Seeding
// them directly is the only way to translate a tree the EasyLocalization
// widget is not wrapped around.
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/features/home/presentation/view/client_home_screen.dart';

/// Without the real font, text falls back to a fixed-width test face that is
/// far wider than Tajawal, which reports overflows the app would never hit.
Future<void> _loadTajawal() async {
  final loader = FontLoader('Tajawal');
  for (final font in const [
    'assets/fonts/Tajawal-Regular.ttf',
    'assets/fonts/Tajawal-Medium.ttf',
    'assets/fonts/Tajawal-Bold.ttf',
    'assets/fonts/Tajawal-ExtraBold.ttf',
  ]) {
    loader.addFont(rootBundle.load(font));
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // The dashboard's current-order card draws the shared delivery timeline,
    // whose stop labels come from `assets/translations/*.json` — without
    // them it would render raw keys.
    final arabic = await const RootBundleAssetLoader().load(
      AppAssets.translationsPath,
      AppLocales.arabic,
    );
    Localization.load(AppLocales.arabic, translations: Translations(arabic));
  });

  testWidgets('lays out on a phone screen without overflowing', (tester) async {
    await _loadTajawal();
    tester.view.physicalSize = const Size(1206, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Tajawal', useMaterial3: true),
        home: const ClientHomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    // Station card, the نظرة سريعة counters, and the order card.
    expect(find.text('محطة الرحاب'), findsOneWidget);
    expect(find.text('تغيير المحطة'), findsOneWidget);
    expect(find.text('نظرة سريعة'), findsOneWidget);
    // findsWidgets, not findsOneWidget: 'قيد التوصيل' is both a counter label
    // and the current order's status badge.
    for (final label in ['تم التوصيل', 'قيد التوصيل', 'قيد التجهيز', 'ملغاة']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.text('أحمد السبيعي'), findsOneWidget);
  });
}
