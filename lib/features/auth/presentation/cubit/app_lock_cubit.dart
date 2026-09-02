import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/security/biometric_authenticator.dart';
import '../../../../shared/enums/user_role.dart';
import 'app_lock_state.dart';
import 'session_cubit.dart';
import 'session_state.dart';

/// Drives the mandatory driver app lock (spec 006 US2). Scoped to the
/// driver persona only (FR-010) — a CLIENT session never engages it,
/// which is why this observes [SessionCubit] rather than being told
/// per-screen whether it applies.
///
/// A session-lifetime singleton, like [SessionCubit] itself: it must be
/// alive and observing app lifecycle from launch, not only once some
/// screen first builds it — a background/resume cycle that happens before
/// any screen resolves this cubit must still be caught.
class AppLockCubit extends Cubit<AppLockState> with WidgetsBindingObserver {
  AppLockCubit({
    required BiometricAuthenticator biometrics,
    required SessionCubit sessionCubit,
    DateTime Function() now = DateTime.now,
  }) : _biometrics = biometrics,
       _sessionCubit = sessionCubit,
       _now = now,
       super(const AppLockState.unlocked()) {
    WidgetsBinding.instance.addObserver(this);
    _sessionSubscription = sessionCubit.stream.listen(_onSessionChanged);
    // Cold launch into an already-restored driver session (FR-012) — by
    // the time this constructor runs, launch hydration has already
    // resolved `sessionCubit.state` (see injector.dart's
    // `_registerAuthFeature`), so this is a correct read, not a race.
    if (_appliesToCurrentSession) {
      emit(const AppLockState.locked());
    }
  }

  final BiometricAuthenticator _biometrics;
  final SessionCubit _sessionCubit;
  /// Overridable only in tests, so the 2-minute threshold can be exercised
  /// deterministically without a real wait.
  final DateTime Function() _now;
  late final StreamSubscription<SessionState> _sessionSubscription;

  /// Null while foregrounded. Set the moment the app leaves the
  /// foreground; read (and cleared) on the next resume to measure how
  /// long it was away.
  DateTime? _backgroundedAt;

  bool get _appliesToCurrentSession {
    final session = _sessionCubit.state;
    return session is SessionAuthenticated && session.user.role == UserRole.driver;
  }

  void _onSessionChanged(SessionState session) {
    final isDriverSession =
        session is SessionAuthenticated && session.user.role == UserRole.driver;
    if (isDriverSession) {
      // A fresh sign-in is, for this purpose, the same event as a cold
      // launch into an existing session: the first frame of a driver
      // session that has not yet proven who is holding the device.
      emit(const AppLockState.locked());
    } else {
      // CLIENT session, or signed out — FR-010 scopes the mandate to
      // drivers only; the client keeps its own separate, optional
      // behaviour (unaffected by this cubit).
      _backgroundedAt = null;
      emit(const AppLockState.unlocked());
    }
  }

  // Deliberately not named `state`: `Cubit<AppLockState>` already exposes a
  // `state` getter for this cubit's own AppLockState, and the `resumed`
  // case below reads it (`state is! AppLockLocked`) — naming this
  // parameter `state` would shadow that getter with an AppLifecycleState
  // and silently break that check instead of merely renaming it.
  @override
  // ignore: avoid_renaming_method_parameters
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (!_appliesToCurrentSession) return;
    switch (lifecycleState) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        _backgroundedAt ??= _now();
      case AppLifecycleState.resumed:
        final backgroundedAt = _backgroundedAt;
        _backgroundedAt = null;
        final elapsed = backgroundedAt == null
            ? Duration.zero
            : _now().difference(backgroundedAt);
        if (elapsed >= AppDurations.appLockThreshold &&
            state is! AppLockLocked &&
            state is! AppLockAuthenticating) {
          emit(const AppLockState.locked());
        }
      case AppLifecycleState.detached:
        break;
    }
  }

  /// Runs one challenge attempt. Re-checks device-lock availability on
  /// every call rather than caching it — a driver can remove their only
  /// enrolled biometric or a device passcode mid-session (spec 006 edge
  /// cases), and FR-017 already commits to never trusting a stale
  /// enrolment judgement.
  Future<void> unlock({required String localizedReason}) async {
    if (!_appliesToCurrentSession) return;
    emit(const AppLockState.authenticating());

    if (!await _biometrics.isDeviceLockAvailable()) {
      emit(const AppLockState.unavailable());
      return;
    }

    final approved = await _biometrics.authenticate(
      localizedReason: localizedReason,
      // FR-013: the mandatory lock must accept the device passcode when
      // biometrics are absent or fail — unlike login's biometric sign-in,
      // which keeps the stricter default (see that call site).
      allowDeviceCredential: true,
    );
    emit(approved ? const AppLockState.unlocked() : const AppLockState.locked());
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_sessionSubscription.cancel());
    return super.close();
  }
}
