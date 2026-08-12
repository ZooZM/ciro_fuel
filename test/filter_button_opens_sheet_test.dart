import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_action_icon.dart';
import 'package:mobile_app/core/widgets/filter_sheet.dart';
import 'package:mobile_app/features/orders/presentation/view/orders_list_screen.dart';

import 'helpers/localized_harness.dart';

/// Tapping the funnel has to open the sheet. The button is an SVG, and a
/// GestureDetector defaulting to `deferToChild` only fires where its child
/// reports a hit — which a painted-only render box does not.
void main() {
  testWidgets('the funnel opens the filter sheet', (tester) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      const OrdersListScreen(),
      locale: AppLocales.arabic,
      theme: AppTheme.lightTheme,
    );

    expect(find.byType(FilterSheet), findsNothing);

    await tester.tap(find.byType(AppActionIcon).last);
    await tester.pumpAndSettle();

    expect(
      find.byType(FilterSheet),
      findsOneWidget,
      reason: 'tapping the funnel did nothing',
    );
  });
}
