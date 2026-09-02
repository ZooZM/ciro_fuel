import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Whether this build can actually show a Google map.
///
/// The question has to be asked of the platform, not of a `--dart-define`:
/// the SDKs read their key from `Info.plist` (iOS, via
/// `ios/Flutter/Secrets.xcconfig`) and from the manifest meta-data (Android,
/// via `android/local.properties`). A dart-define is not wired to either, so
/// keying off one meant a build could pass the check and still abort inside
/// `+[GMSServices checkServicePreconditions]` the moment a map was built.
///
/// The answer is fixed for the life of the process, so it is resolved once
/// and cached.
abstract final class MapsAvailability {
  static const MethodChannel _channel = MethodChannel('com.ciro.fuel/maps');

  static Future<bool>? _pending;

  /// Overridable in tests, which have no platform to ask.
  @visibleForTesting
  static bool? debugOverride;

  static Future<bool> isAvailable() async {
    final override = debugOverride;
    if (override != null) return override;
    if (_pending != null) return _pending!;

    final answer = await _query();
    // Only an affirmative answer is cached. A negative one may just mean the
    // host had not registered its handler yet, and caching that would leave
    // the map permanently withheld on a correctly configured build — the
    // failure mode is silent, so it is worth one cheap call per screen
    // visit to avoid it. "Available" never becomes false within a process.
    if (answer) _pending = Future.value(true);
    return answer;
  }

  static Future<bool> _query() async {
    try {
      return await _channel.invokeMethod<bool>('isAvailable') ?? false;
    } on MissingPluginException {
      // A host that never registered the handler cannot promise a key is
      // present, and guessing "yes" is what crashes the process.
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Drops the cached answer. Tests only.
  @visibleForTesting
  static void reset() {
    _pending = null;
    debugOverride = null;
  }
}
