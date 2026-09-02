import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_context.dart';
import '../../domain/usecases/sign_out.dart';
import '../cubit/app_lock_cubit.dart';
import '../cubit/app_lock_state.dart';
import '../cubit/session_cubit.dart';

/// The mandatory driver unlock challenge (spec 006 US2). Mounted only by
/// `AppLockGate` while `AppLockCubit` is not in [AppLockUnlocked] — never
/// routed to directly, so it needs no route of its own.
///
/// FR-014/015: a failed or dismissed challenge never ends the session by
/// itself — the driver stays here with the option to retry, or to sign
/// out entirely. There is no third way past this screen.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-prompt once per mount — `AppLockGate` mounts a fresh
    // `LockScreen` each time the cubit re-enters a non-unlocked state, so
    // this fires once per "the driver needs to prove it's them" event,
    // not once per rebuild.
    final cubit = context.read<AppLockCubit>();
    if (cubit.state is AppLockLocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _attemptUnlock());
    }
  }

  void _attemptUnlock() {
    if (!mounted) return;
    context.read<AppLockCubit>().unlock(
      localizedReason: LockKeys.challengeReason.tr(),
    );
  }

  /// Mirrors `driver_profile_screen.dart`'s `_confirmAndSignOut` ordering:
  /// clear the persisted tokens first, then drop the session — otherwise
  /// there is a window where the app looks signed out while the
  /// Keychain/Keystore still holds a usable refresh token. Resolved from
  /// `getIt`, not this widget's tree, so sign-out still lands if the
  /// screen goes away mid-await.
  Future<void> _signOut(BuildContext context) async {
    try {
      await getIt<SignOut>()();
    } catch (_) {
      // Swallowed on purpose — see driver_profile_screen.dart's identical
      // comment. The session ends either way, below.
    } finally {
      getIt<SessionCubit>().signOut();
    }
    if (context.mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // No back-gesture/back-button escape (FR-014's only exits are
      // retry and sign-out, both explicit taps below).
      canPop: false,
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: SafeArea(
          child: BlocBuilder<AppLockCubit, AppLockState>(
            builder: (context, state) => switch (state) {
              AppLockUnavailable() => _UnavailableView(
                onSignOut: () => _signOut(context),
              ),
              AppLockAuthenticating() => const _ChallengeInFlightView(),
              AppLockLocked() => _ChallengeView(
                onRetry: _attemptUnlock,
                onSignOut: () => _signOut(context),
              ),
              // Transient: AppLockGate is about to unmount this screen.
              AppLockUnlocked() => const SizedBox.shrink(),
            },
          ),
        ),
      ),
    );
  }
}

class _ChallengeView extends StatelessWidget {
  const _ChallengeView({required this.onRetry, required this.onSignOut});

  final VoidCallback onRetry;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
              color: context.colors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              LockKeys.title.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: onRetry,
              child: Text(LockKeys.retry.tr()),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onSignOut,
              child: Text(
                MoreKeys.signOut.tr(),
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeInFlightView extends StatelessWidget {
  const _ChallengeInFlightView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// FR-013a: the device has neither an enrolled biometric nor a passcode.
/// There is nothing this app can challenge against, so this is a dead end
/// with one honest way out.
class _UnavailableView extends StatelessWidget {
  const _UnavailableView({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.no_encryption_gmailerrorred_outlined,
              size: 64,
              color: context.colors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              LockKeys.unavailableTitle.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              LockKeys.unavailableBody.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: onSignOut,
              child: Text(MoreKeys.signOut.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
