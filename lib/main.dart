import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/di/injector.dart';
import 'core/error/error_boundary.dart';

void main() {
  runAppGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies();
    runApp(const App());
  });
}
