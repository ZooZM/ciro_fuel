import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/more/presentation/view/client_credit_limit_screen.dart';
import 'package:mobile_app/features/more/presentation/view/client_terms_screen.dart';
import 'package:mobile_app/features/stations/presentation/view/client_stations_screen.dart';
import 'package:mobile_app/features/support/presentation/view/support_screen.dart';

import 'helpers/localized_harness.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadTajawal();
  });

  /// A tall viewport: these are long scrolling pages, and an overflow only
  /// reports for the part of the tree that is actually laid out.
  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(1206, 4200);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    // Through the harness, not a bare MaterialApp: these screens read
    // `context.locale`, which needs a real EasyLocalization ancestor.
    await pumpLocalized(
      tester,
      screen,
      theme: ThemeData(fontFamily: 'Tajawal', useMaterial3: true),
    );

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
