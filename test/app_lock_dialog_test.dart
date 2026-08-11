import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/security/biometric_authenticator.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/more/presentation/widgets/app_lock_dialog.dart';

import 'helpers/localized_harness.dart';

/// Stands in for a device offering exactly [method].
class _Device extends BiometricAuthenticator {
  _Device(this.method) : super(localAuth: LocalAuthentication());

  final BiometricMethod method;

  @override
  Future<BiometricMethod> availableMethod() async => method;
}

/// The dialog must offer only what the phone can actually do — a handset with
/// no enrolled print should not present fingerprint unlock as a choice — while
/// still explaining the gap rather than quietly dropping the row.
void main() {
  Future<void> pumpSheet(
    WidgetTester tester,
    BiometricMethod device, {
    AppLockMethod selected = AppLockMethod.none,
  }) async {
    await loadTajawal();
    tester.view.physicalSize = const Size(1080, 1600);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpLocalized(
      tester,
      Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: AppLockDialog(
            selected: selected,
            authenticator: _Device(device),
          ),
        ),
      ),
      locale: AppLocales.english,
      theme: AppTheme.lightTheme,
    );
    await tester.pumpAndSettle();
  }

  /// Whether the row for [label] can be tapped.
  bool rowEnabled(WidgetTester tester, String label) {
    final row = find.ancestor(
      of: find.text(label),
      matching: find.byType(InkWell),
    );
    return tester.widget<InkWell>(row.first).onTap != null;
  }

  testWidgets('password and no-lock are always offered', (tester) async {
    await pumpSheet(tester, BiometricMethod.none);
    expect(rowEnabled(tester, 'Password'), isTrue);
    expect(rowEnabled(tester, 'No lock'), isTrue);
  });

  testWidgets('a fingerprint phone cannot pick Face ID', (tester) async {
    await pumpSheet(tester, BiometricMethod.fingerprint);
    expect(rowEnabled(tester, 'Fingerprint'), isTrue);
    expect(rowEnabled(tester, 'Face ID'), isFalse);
    expect(find.text('Not available on this device'), findsOneWidget);
  });

  testWidgets('a Face ID phone cannot pick fingerprint', (tester) async {
    await pumpSheet(tester, BiometricMethod.face);
    expect(rowEnabled(tester, 'Face ID'), isTrue);
    expect(rowEnabled(tester, 'Fingerprint'), isFalse);
  });

  testWidgets('a phone with no biometrics rules both out', (tester) async {
    await pumpSheet(tester, BiometricMethod.none);
    expect(rowEnabled(tester, 'Fingerprint'), isFalse);
    expect(rowEnabled(tester, 'Face ID'), isFalse);
    expect(find.text('Not available on this device'), findsNWidgets(2));
  });

  testWidgets('the always-available rows never claim to be unsupported', (
    tester,
  ) async {
    await pumpSheet(tester, BiometricMethod.none);
    // Exactly the two biometrics carry the caption — not password or no-lock.
    expect(find.text('Not available on this device'), findsNWidgets(2));
  });

  testWidgets('the current method is ticked', (tester) async {
    await pumpSheet(
      tester,
      BiometricMethod.fingerprint,
      selected: AppLockMethod.fingerprint,
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('choosing a method hands it back', (tester) async {
    AppLockMethod? chosen;

    await loadTajawal();
    await pumpLocalized(
      tester,
      Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              chosen = await AppLockDialog.show(
                context,
                selected: AppLockMethod.none,
                authenticator: _Device(BiometricMethod.fingerprint),
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
      locale: AppLocales.english,
      theme: AppTheme.lightTheme,
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fingerprint'));
    await tester.pumpAndSettle();

    expect(chosen, AppLockMethod.fingerprint);
  });
}
