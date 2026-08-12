import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/more/presentation/view/client_terms_screen.dart';

import 'helpers/localized_harness.dart';

/// The contents rows used to be inert. Each one now scrolls to the clause it
/// names — the clause cards are as tall as their copy, so the jump has to be
/// measured off the card itself rather than off a fixed offset.
void main() {
  testWidgets('a contents row scrolls to its clause', (tester) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      const ClientTermsScreen(),
      locale: AppLocales.english,
      theme: AppTheme.lightTheme,
    );

    // The last clause's badge, which starts well below the fold.
    final badge = find.text('06');
    final viewport = tester.getRect(find.byType(ClientTermsScreen));
    expect(
      tester.getRect(badge).top,
      greaterThan(viewport.bottom),
      reason: 'clause 06 should start off-screen',
    );

    await tester.tap(find.textContaining('6.'));
    await tester.pumpAndSettle();

    final landed = tester.getRect(badge);
    expect(
      landed.top >= viewport.top && landed.bottom <= viewport.bottom,
      isTrue,
      reason: 'clause 06 should be on screen after tapping its row, got $landed',
    );
  });
}
