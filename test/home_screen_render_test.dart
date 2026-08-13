// `hide TextDirection`: easy_localization re-exports intl, whose
// TextDirection would shadow the one this test asserts on.
import 'package:easy_localization/easy_localization.dart'
    hide TextDirection;
// `Localization` and `Translations` are what `.tr()` reads from, but
// easy_localization only re-exports the widget that populates them. Seeding
// them directly is the only way to translate a tree the EasyLocalization
// widget is not wrapped around.
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/home/presentation/view/client_home_screen.dart';

import 'helpers/localized_harness.dart';
import 'support/orders_test_di.dart';

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

  setUp(() {
    registerOrdersTestDi();
    registerFinanceTestDi();
  });
  tearDown(() {
    resetOrdersTestDi();
    resetFinanceTestDi();
  });

  testWidgets('lays out on a phone screen without overflowing', (tester) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1206, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      // ClientHomeScreen reads SessionCubit from an ancestor provider in
      // production (app.dart's app-root MultiBlocProvider) — mirrored here.
      BlocProvider<SessionCubit>.value(
        value: sampleAuthenticatedSessionCubit(),
        child: const ClientHomeScreen(),
      ),
      theme: ThemeData(fontFamily: 'Tajawal', useMaterial3: true),
    );

    expect(tester.takeException(), isNull);

    // Station card (sourced from the authenticated session, spec 004
    // FR-009/T088 — no longer a hardcoded placeholder), the نظرة سريعة
    // counters, and the order card. The station name and driver are sample
    // data, so they stay Arabic in both locales; the labels around them come
    // from the catalogue.
    expect(find.text('محطة الرحاب'), findsOneWidget);
    expect(find.text('تغيير المحطة'), findsOneWidget);
    expect(find.text('نظرة سريعة'), findsOneWidget);
    // findsWidgets, not findsOneWidget: 'قيد التوصيل' is both a counter label
    // and the current order's status badge.
    for (final label in ['تم التوصيل', 'قيد التوصيل', 'قيد التجهيز', 'ملغاة']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    // The active order now comes from the orders API (see sampleOrders), so
    // assert the wired values rather than the retired placeholder driver.
    expect(find.text('بنزين 95'), findsWidgets);
    expect(find.text('20,000 لتر'), findsWidgets);
    // Driver summary and ETA are wired end to end (spec 004 FR-028/FR-029,
    // T086) — no more '—' placeholder for the order that has both.
    expect(find.text('محمد العتيبي'), findsWidgets);
    expect(find.text('ABC-1234'), findsWidgets);
  });

  testWidgets('renders English copy and flips to LTR under the en locale', (
    tester,
  ) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1206, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      BlocProvider<SessionCubit>.value(
        value: sampleAuthenticatedSessionCubit(),
        child: const ClientHomeScreen(),
      ),
      locale: const Locale('en'),
      theme: ThemeData(fontFamily: 'Tajawal', useMaterial3: true),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Change station'), findsOneWidget);
    expect(find.text('At a glance'), findsOneWidget);
    // No screen forces its own direction any more, so the locale decides.
    expect(
      Directionality.of(tester.element(find.byType(ClientHomeScreen))),
      TextDirection.ltr,
    );
  });
}
