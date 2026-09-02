import 'package:url_launcher/url_launcher.dart';

/// Hands a phone number to the platform dialler.
///
/// A thin seam rather than a raw `launchUrl` at each call site: the callers
/// (track-order, the dashboard's current-order card) both need the same
/// null/blank handling, and a plain function is what lets a widget test
/// substitute the launch without a platform channel.
abstract final class PhoneDialer {
  /// Swapped in tests. Production always launches for real.
  static Future<bool> Function(Uri uri) launcher = (uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);

  /// Opens the dialler pre-filled with [phone], returning false when there
  /// is nothing to dial or the platform refuses.
  ///
  /// The number is NOT placed — every platform shows it in the dialler for
  /// the user to confirm, which is the behaviour we want: tapping a call
  /// icon should never silently start a call.
  static Future<bool> call(String? phone) async {
    final trimmed = phone?.trim();
    if (trimmed == null || trimmed.isEmpty) return false;

    // Strip formatting the dialler would choke on, keeping a leading `+`
    // so an E.164 number still dials internationally.
    final sanitized = trimmed.replaceAll(RegExp(r'[^\d+]'), '');
    if (sanitized.isEmpty || sanitized == '+') return false;

    try {
      return await launcher(Uri(scheme: 'tel', path: sanitized));
    } catch (_) {
      // A device with no telephony (an iPad, the simulator) throws rather
      // than returning false. The caller shows the same "can't call" copy
      // either way, so this must not escape as an unhandled error.
      return false;
    }
  }
}
