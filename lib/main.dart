import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/constants/app_assets.dart';
import 'core/di/injector.dart';
import 'core/error/app_bloc_observer.dart';
import 'core/error/error_boundary.dart';
import 'core/localization/app_locales.dart';

void main() {
  runAppGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    Bloc.observer = const AppBlocObserver();
    await configureDependencies();
    runApp(
      EasyLocalization(
        supportedLocales: AppLocales.supported,
        fallbackLocale: AppLocales.fallback,
        path: AppAssets.translationsPath,
        child: const App(),
      ),
    );
  });
}
