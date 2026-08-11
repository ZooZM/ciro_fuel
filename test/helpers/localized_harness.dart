import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Test harness for screens that call `.tr()`.
///
/// Every widget in the app now reads its copy from the translation catalogue,
/// so pumping a bare `MaterialApp` would render raw keys ('home.current_station')
/// and report no direction. [pumpLocalized] supplies both: the loaded
/// catalogue and the `Directionality` the locale implies — RTL under Arabic,
/// which is what the screens were designed against.
Future<void> pumpLocalized(
  WidgetTester tester,
  Widget home, {
  Locale locale = AppLocales.arabic,
  ThemeData? theme,
}) async {
  // easy_localization persists the last chosen locale through
  // shared_preferences; the test binding has no real store behind it.
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  await _precacheTranslations(tester);

  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      fallbackLocale: AppLocales.fallback,
      startLocale: locale,
      path: AppAssets.translationsPath,
      child: Builder(
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: theme,
          home: home,
        ),
      ),
    ),
  );
  await _settleTranslations(tester);
}

/// EasyLocalization reads its JSON off the asset bundle on a real async path
/// that the fake-async test zone never advances, so `pumpAndSettle` alone can
/// return while the catalogue is still loading — the screen then renders raw
/// keys. Draining the real event queue first makes the load land.
Future<void> _settleTranslations(WidgetTester tester) async {
  // `Localizations` renders nothing until every delegate's future completes,
  // and easy_localization's delegate reads the JSON off the asset bundle.
  // That is real I/O the fake-async test zone will not advance on its own, so
  // give it the real event loop until the tree appears.
  for (var i = 0; i < 50; i++) {
    if (find.byType(Text).evaluate().isNotEmpty) return;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pumpAndSettle();
  }
  fail('EasyLocalization did not finish loading its translations.');
}

/// Reads the catalogues once per test process so the delegate's later
/// `rootBundle` reads are served from cache.
Future<void> _precacheTranslations(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final locale in AppLocales.supported) {
      await rootBundle.loadString(
        '${AppAssets.translationsPath}/${locale.languageCode}.json',
      );
    }
  });
}

/// [pumpLocalized] for tests that drive navigation through a [GoRouter].
Future<void> pumpLocalizedRouter(
  WidgetTester tester,
  GoRouter router, {
  Locale locale = AppLocales.arabic,
  ThemeData? theme,
}) async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  await _precacheTranslations(tester);

  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      fallbackLocale: AppLocales.fallback,
      startLocale: locale,
      path: AppAssets.translationsPath,
      child: Builder(
        builder: (context) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: theme,
          routerConfig: router,
        ),
      ),
    ),
  );
  await _settleTranslations(tester);
}

/// Without the real font, text falls back to a fixed-width test face that is
/// far wider than Tajawal, which reports overflows the app would never hit.
Future<void> loadTajawal() async {
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
