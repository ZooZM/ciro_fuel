import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/home/presentation/view/client_home_screen.dart';

void main() {
  testWidgets('g', (tester) async {
    final loader = FontLoader('Tajawal');
    for (final f in const [
      'assets/fonts/Tajawal-Regular.ttf',
      'assets/fonts/Tajawal-Medium.ttf',
      'assets/fonts/Tajawal-Bold.ttf',
      'assets/fonts/Tajawal-ExtraBold.ttf',
    ]) {
      loader.addFont(rootBundle.load(f));
    }
    await loader.load();

    tester.view.physicalSize = const Size(1206, 3400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Tajawal', useMaterial3: true),
        home: const ClientHomeScreen(),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(ClientHomeScreen),
      matchesGoldenFile('goldens/g.png'),
    );
  });
}
