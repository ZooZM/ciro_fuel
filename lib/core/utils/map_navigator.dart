import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

/// Hands a destination to the platform's own maps app.
///
/// A seam in the same shape as [PhoneDialer], for the same reason: the
/// callers need identical failure handling, and a plain function is what
/// lets a widget test substitute the launch without a platform channel.
///
/// The platform's maps app rather than an in-app map (spec 008 FR-027): a
/// driver already has a navigator they trust, with their own traffic data
/// and voice guidance, and re-implementing turn-by-turn inside this app
/// would be worse at the one job the driver actually needs done.
abstract final class MapNavigator {
  /// Swapped in tests. Production always launches for real.
  static Future<bool> Function(Uri uri) launcher = (uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);

  /// Opens navigation to [latitude]/[longitude], returning false when the
  /// coordinates are unusable or no maps app answers.
  ///
  /// [label] is only a display name for the pin; navigation is always by
  /// coordinate, never by searching the name — a depot's name is not a
  /// searchable address, and a near-miss search result is worse than none.
  static Future<bool> navigateTo({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    if (latitude.abs() > 90 || longitude.abs() > 180) return false;

    // Apple Maps on iOS, Google Maps (or whatever claims geo:) elsewhere —
    // `geo:` is not answered on iOS, and `maps:` is not answered anywhere
    // else, so this is a real branch rather than a preference.
    final uri = Platform.isIOS
        ? Uri.parse(
            'maps:?daddr=$latitude,$longitude&dirflg=d'
            '${label == null ? '' : '&q=${Uri.encodeComponent(label)}'}',
          )
        : Uri.parse(
            'geo:$latitude,$longitude?q=$latitude,$longitude'
            '${label == null ? '' : '(${Uri.encodeComponent(label)})'}',
          );

    try {
      return await launcher(uri);
    } catch (_) {
      // A device with no maps app at all (the simulator, a stripped ROM)
      // throws rather than returning false; the caller shows the same
      // "can't open maps" copy either way.
      return false;
    }
  }
}
