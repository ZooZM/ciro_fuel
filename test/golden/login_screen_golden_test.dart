import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/security/biometric_authenticator.dart';
import 'package:mobile_app/core/theme/app_text_styles.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/auth/data/datasources/login_preferences_store.dart';
import 'package:mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_app/features/auth/domain/usecases/restore_session.dart';
import 'package:mobile_app/features/auth/domain/usecases/sign_in.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/auth/presentation/view/login_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockPreferences extends Mock implements LoginPreferencesStore {}

/// Reports Face ID as enrolled so the biometric control is exercised — the
/// test binding has no local_auth plugin, and the real probe would (rightly)
/// report "none" and hide it.
class _FaceIdAuthenticator implements BiometricAuthenticator {
  @override
  Future<BiometricMethod> availableMethod() async => BiometricMethod.face;

  @override
  Future<bool> authenticate({required String localizedReason}) async => false;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Without this the harness substitutes Ahem, which renders every glyph
    // as a filled box and makes the golden useless for judging typography.
    final fonts = FontLoader(AppTextStyles.fontFamily);
    for (final weight in const [
      'ExtraLight',
      'Light',
      'Regular',
      'Medium',
      'Bold',
      'ExtraBold',
      'Black',
    ]) {
      fonts.addFont(rootBundle.load('assets/fonts/Tajawal-$weight.ttf'));
    }
    await fonts.load();

    // `uses-material-design: true` bundles the icon font at this key; the
    // test harness does not register it, so Icons would render as boxes.
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });

  testWidgets('login screen matches the Figma frame', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();

    final preferences = _MockPreferences();
    when(preferences.read).thenAnswer((_) async => null);

    final repository = _MockAuthRepository();
    await getIt.reset();
    getIt
      ..registerSingleton<SessionCubit>(SessionCubit())
      ..registerSingleton<SignIn>(SignIn(repository))
      ..registerSingleton<RestoreSession>(RestoreSession(repository))
      ..registerSingleton<LoginPreferencesStore>(preferences)
      ..registerSingleton<BiometricAuthenticator>(_FaceIdAuthenticator());

    tester.view
      ..physicalSize =
          const Size(1179, 2556) // iPhone 15 Pro
      ..devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: AppLocales.supported,
        fallbackLocale: AppLocales.fallback,
        startLocale: AppLocales.arabic,
        path: AppAssets.translationsPath,
        child: Builder(
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            theme: AppTheme.lightTheme,
            home: const LoginScreen(),
          ),
        ),
      ),
    );
    // EasyLocalization renders a placeholder until its JSON has loaded.
    await tester.pumpAndSettle();

    // Asset images resolve on a real async path the fake-async test zone
    // never advances, so without this the hero photo silently paints blank.
    await tester.runAsync(
      () => precacheImage(
        const AssetImage(AppAssets.loginBackground),
        tester.element(find.byType(LoginScreen)),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(LoginScreen),
      matchesGoldenFile('login_screen.png'),
    );
  });
}
