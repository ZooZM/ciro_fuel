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
import 'package:mobile_app/features/more/presentation/view/client_credit_limit_screen.dart';
import 'package:mobile_app/features/more/presentation/view/client_terms_screen.dart';
import 'package:mobile_app/features/stations/presentation/view/client_stations_screen.dart';
import 'package:mobile_app/features/support/presentation/view/support_screen.dart';

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
    await _loadTajawal();
    // Every one of these screens draws its copy from
    // `assets/translations/*.json` — without it they would render raw keys,
    // whose Latin text lays out nothing like the Arabic it stands in for.
    final arabic = await const RootBundleAssetLoader().load(
      AppAssets.translationsPath,
      AppLocales.arabic,
    );
    Localization.load(AppLocales.arabic, translations: Translations(arabic));
  });

  /// A tall viewport: these are long scrolling pages, and an overflow only
  /// reports for the part of the tree that is actually laid out.
  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(1206, 4200);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Tajawal', useMaterial3: true),
        home: screen,
      ),
    );
    await tester.pumpAndSettle();

    // Catches the RenderFlex overflows and missing-asset errors a layout
    // refactor is most likely to introduce.
    expect(tester.takeException(), isNull);
  }

  testWidgets('the credit-limit screen lays out on a phone screen', (
    tester,
  ) async {
    await pumpScreen(tester, const ClientCreditLimitScreen());
  });

  testWidgets('the terms screen lays out on a phone screen', (tester) async {
    await pumpScreen(tester, const ClientTermsScreen());
  });

  testWidgets('the stations screen lays out on a phone screen', (tester) async {
    await pumpScreen(tester, const ClientStationsScreen());
  });

  testWidgets('the support screen lays out signed out', (tester) async {
    await pumpScreen(tester, const SupportScreen());
  });

  testWidgets('the support screen lays out with the in-app header', (
    tester,
  ) async {
    await pumpScreen(tester, const SupportScreen(showTopBar: true));
  });
}
