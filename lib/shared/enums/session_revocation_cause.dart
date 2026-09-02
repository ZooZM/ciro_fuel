/// Mirrors backend `SessionRevocationCause` (spec 006 FR-036/FR-042) — why
/// a live session ended other than the driver's own sign-out. The app maps
/// this to a localized string and MUST NOT match on the server's `message`
/// text (Principle I/III).
enum SessionRevocationCause {
  signedInElsewhere('SIGNED_IN_ELSEWHERE'),
  passwordReset('PASSWORD_RESET'),
  accountDeactivated('ACCOUNT_DEACTIVATED');

  const SessionRevocationCause(this.wire);

  final String wire;

  /// `null` for an absent or unrecognised wire value (e.g. plain sign-out
  /// carries no cause at all) — the caller falls back to a generic
  /// "session ended" message rather than throwing on a cause a stale
  /// build doesn't know about yet.
  static SessionRevocationCause? fromWire(String? wire) => switch (wire) {
    'SIGNED_IN_ELSEWHERE' => SessionRevocationCause.signedInElsewhere,
    'PASSWORD_RESET' => SessionRevocationCause.passwordReset,
    'ACCOUNT_DEACTIVATED' => SessionRevocationCause.accountDeactivated,
    _ => null,
  };
}
