import 'package:easy_localization/easy_localization.dart';
// `Localization` and `Translations` are what `.tr()` reads from, but
// easy_localization only re-exports the widget that populates them. Seeding
// them directly is the only way to translate a tree the EasyLocalization
// widget is not wrapped around.
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/home/presentation/view/client_home_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/create_order_screen.dart';

<<<<<<< HEAD
import 'support/orders_test_di.dart';
=======
import 'helpers/localized_harness.dart';
>>>>>>> df7a18f732afd39bbce1817509b7b32640330465

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Both screens read their copy from `assets/translations/*.json`; the
    // order form would otherwise lay out around raw keys.
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


  testWidgets('tapping a طلب سريع tile opens the order form on that grade', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1206, 3400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/client',
      routes: [
        GoRoute(path: '/client', builder: (_, _) => const ClientHomeScreen()),
        GoRoute(
          path: '/client/orders/new',
          builder: (_, state) =>
              CreateOrderScreen(initialGradeBadge: state.extra as String?),
        ),
      ],
    );
    addTearDown(router.dispose);

<<<<<<< HEAD
    await tester.pumpWidget(
      // ClientHomeScreen reads SessionCubit from an ancestor provider in
      // production (app.dart's app-root MultiBlocProvider) — mirrored here.
      BlocProvider<SessionCubit>.value(
        value: sampleAuthenticatedSessionCubit(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
=======
    await pumpLocalizedRouter(tester, router);
>>>>>>> df7a18f732afd39bbce1817509b7b32640330465

    expect(find.byType(CreateOrderScreen), findsNothing);

    // 'بنزين 95' also appears in the current-order card, so target the tile —
    // the طلب سريع row is built after it.
    final tile = find.text('بنزين 95').last;
    await tester.ensureVisible(tile);
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.pumpAndSettle();

    expect(find.byType(CreateOrderScreen), findsOneWidget);
    final screen = tester.widget<CreateOrderScreen>(
      find.byType(CreateOrderScreen),
    );
    expect(screen.initialGradeBadge, '95');
  });
}
