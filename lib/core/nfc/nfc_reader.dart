/// Domain-safe seam over the platform's NFC stack (spec 008 US3/research
/// R5) — no `nfc_manager` import anywhere near this file, mirroring how
/// `PhoneDialer` isolates `url_launcher`. The only concrete implementation
/// is `NfcManagerReader`; tests substitute this interface directly.
abstract interface class NfcReader {
  /// Whether this device can read NFC at all. `false` is a normal, expected
  /// answer on iOS without the paid-account entitlement, or on any device
  /// with no NFC hardware — never an error (research R5).
  Future<bool> isAvailable();

  /// Waits for a single tag and returns its identifier, or `null` if the
  /// session was cancelled/timed out before one was read. Never queues,
  /// never retries silently — one physical tap, one result.
  Future<String?> readTagId();

  /// Ends any in-progress read session. Safe to call even if none is active.
  Future<void> stopSession();
}
