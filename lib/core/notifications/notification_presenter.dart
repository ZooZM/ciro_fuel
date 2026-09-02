/// Domain-safe seam over the platform's local-notification stack (spec 011
/// FR-004a / research R4) — no `flutter_local_notifications` import anywhere
/// near this file, mirroring how [NfcReader] isolates `nfc_manager` and
/// [PositionReader] isolates `geolocator`. The only concrete implementation
/// is `LocalNotificationPresenter`; tests substitute this interface
/// directly, so "did we alert the driver about this?" is assertable without
/// a device or a plugin.
///
/// **Why this exists at all**: before spec 011 the app had no way to surface
/// anything while backgrounded. Notifications were a stored document plus a
/// socket event rendered on an in-app list — invisible to a driver mid-drive,
/// which is precisely when the platform most needs to reach them. The
/// location foreground service already keeps this app and its socket alive
/// for the duration of a delivery, so the event arrives; this closes the last
/// gap between arriving and being seen.
abstract interface class NotificationPresenter {
  /// Creates the platform's notification channel (Android) and requests
  /// authorization (iOS). Safe to call more than once.
  Future<void> initialize();

  /// Whether the driver has granted notification permission. `false` is a
  /// normal, expected answer — a driver may refuse, and the platform-side
  /// escalation to the transporter is what covers that case (spec 011
  /// Story 3). Never treat a refusal as an error, and never pretend an
  /// alert was delivered when it was not.
  Future<bool> ensurePermission();

  /// Raises a single device-level alert. [payload] travels back through
  /// [taps] when the driver opens it.
  Future<void> present({
    required String title,
    required String body,
    required String payload,
  });

  /// Payloads of alerts the driver has tapped — how the app knows to open
  /// the reason prompt for one specific stop.
  Stream<String> get taps;
}
