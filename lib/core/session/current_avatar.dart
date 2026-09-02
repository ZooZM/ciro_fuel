
import 'package:flutter/foundation.dart';

/// The signed-in user's profile picture, for chrome that sits outside any one
/// feature — the app bar shows it on every screen, and `AppTopBar` lives in
/// `core/`, so it cannot reach into the profile feature for it.
///
/// A holder rather than a cubit: this is one nullable value with no states to
/// model, read by a widget that must never own the fetching.
///
/// `core/` stays free of feature imports — [loader] is supplied by the
/// composition root (`injector.dart`), which is the one place that already
/// knows both layers.
abstract final class CurrentAvatar {
  /// Null means "no picture", which the app bar renders as a neutral glyph —
  /// never a stock photograph of somebody else.
  static final ValueNotifier<Uint8List?> bytes = ValueNotifier<Uint8List?>(null);

  /// Fetches the signed-in user's picture. Set once at startup.
  static Future<void> Function()? loader;

  static bool _loading = false;
  static bool _attempted = false;

  /// Fetches once per session, on first demand. Repeat calls are ignored:
  /// the app bar is rebuilt constantly, and a fetch per rebuild would hammer
  /// the backend for a value that changes only on upload.
  static Future<void> ensureLoaded() async {
    if (_attempted || _loading || loader == null) return;
    _loading = true;
    try {
      await loader!();
      _attempted = true;
    } finally {
      _loading = false;
    }
  }

  /// Kicks off the one-time fetch without awaiting it — for a `build`, which
  /// cannot be async.
  static void warmUp() {
    if (_attempted || _loading) return;
    // ignore: discarded_futures — fire and forget; the notifier delivers it.
    ensureLoaded();
  }

  /// Publishes a freshly known picture — after a successful upload, or when
  /// the profile screen has already downloaded it.
  static void publish(Uint8List? value) {
    _attempted = true;
    bytes.value = value;
  }

  /// Drops the picture on sign-out, so the next account never briefly wears
  /// the previous one's face.
  static void clear() {
    _attempted = false;
    _loading = false;
    bytes.value = null;
  }
}
