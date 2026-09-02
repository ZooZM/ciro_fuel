import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_lock_state.freezed.dart';

/// Drives `AppLockGate`/`LockScreen` (spec 006 US2). Mandatory and
/// unconfigurable (FR-010) — there is deliberately no "off" state; a
/// driver session is always either [AppLockUnlocked] or working its way
/// back to it.
@freezed
sealed class AppLockState with _$AppLockState {
  /// No challenge pending — either it was just satisfied, or the lock does
  /// not apply to this session at all (a CLIENT, or no session yet).
  const factory AppLockState.unlocked() = AppLockUnlocked;

  /// The challenge is pending. Reached past the inactivity threshold, or
  /// on a cold launch into an existing driver session (FR-012).
  const factory AppLockState.locked() = AppLockLocked;

  /// A challenge attempt is in flight — disables a second concurrent tap
  /// on the unlock control.
  const factory AppLockState.authenticating() = AppLockAuthenticating;

  /// The device has neither an enrolled biometric nor a passcode/PIN/
  /// pattern set (FR-013a) — there is nothing for the mandatory lock to
  /// challenge against. Renders a blocking explanation; signing out is the
  /// only other way forward.
  const factory AppLockState.unavailable() = AppLockUnavailable;
}
