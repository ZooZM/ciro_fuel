import 'dart:async';

import 'package:flutter/foundation.dart';

/// Centralized sink for uncaught errors (Constitution Principle III):
/// zone errors and Flutter framework errors that never reach a Cubit's
/// `Failure` handling still funnel through one place instead of being
/// swallowed or printed ad hoc. Complements [ErrorInterceptor] (network
/// layer) and the widget-level error presenter (Cubit `Failure` → UI).
typedef ErrorReporter = void Function(Object error, StackTrace stackTrace);

void _defaultErrorReporter(Object error, StackTrace stackTrace) {
  if (kDebugMode) {
    debugPrint('Uncaught error: $error\n$stackTrace');
  }
}

/// Runs [body] inside a guarded zone and routes both zone errors and
/// [FlutterError.onError] framework errors to [onError].
void runAppGuarded(
  void Function() body, {
  ErrorReporter onError = _defaultErrorReporter,
}) {
  FlutterError.onError = (FlutterErrorDetails details) {
    onError(details.exception, details.stack ?? StackTrace.current);
  };

  runZonedGuarded(body, onError);
}
