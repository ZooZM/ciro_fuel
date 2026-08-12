import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/theme_cubit.dart';
import 'package:mobile_app/features/home/presentation/view/client_main_scaffold.dart';
import 'package:mobile_app/features/more/presentation/view/client_more_screen.dart';

import 'helpers/localized_harness.dart';

/// The nav bar lives in the shell that hosts every tab, and go_router only
/// rebuilds that shell when navigation happens. `.tr()` reads
/// easy_localization's global store rather than an InheritedWidget, so with
/// nothing in the bar depending on the locale it kept its original language
/// after a switch: the More screen turned English while the bar underneath it
/// stayed Arabic until another tab was opened.
void main() {
  testWidgets('nav bar labels follow a language switch without navigating', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1206, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/more',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              ClientMainScaffold(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const Scaffold(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/more',
                  // The screen's theme toggle reads a ThemeCubit the real app
                  // provides at its root.
                  builder: (context, state) => BlocProvider(
                    create: (_) => ThemeCubit(),
                    child: const ClientMoreScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    await pumpLocalizedRouter(tester, router);

    expect(find.text('الرئيسية'), findsOneWidget);

    // Switch the language the way a user does — the chips on the More screen,
    // staying on the tab that is already open.
    await tester.tap(find.text('اللغة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pump();
    // setLocale reloads the catalogue off the asset bundle, which is real I/O
    // the fake-async test zone will not advance on its own.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('الرئيسية'), findsNothing);
  });
}
