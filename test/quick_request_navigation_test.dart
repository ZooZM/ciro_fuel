import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/home/presentation/view/client_home_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/create_order_screen.dart';

import 'helpers/localized_harness.dart';

void main() {
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

    await pumpLocalizedRouter(tester, router);

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
