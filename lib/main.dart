import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/di/injector.dart';
import 'core/error/app_bloc_observer.dart';
import 'core/error/error_boundary.dart';

void main() {
  runAppGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = const AppBlocObserver();
    await configureDependencies();
    runApp(const App());
  });
}
