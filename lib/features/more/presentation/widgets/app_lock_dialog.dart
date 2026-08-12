import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/security/biometric_authenticator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// How the client wants the app unlocked.
enum AppLockMethod { none, fingerprint, face, password }

/// Picks the app-lock method, as a centred dialog — the same card the
/// calendar uses, rather than a sheet from the bottom.
///
/// Which biometrics the device actually offers is asked of
/// [BiometricAuthenticator] rather than assumed: a phone with no enrolled
/// print should not be offered fingerprint unlock. Unsupported rows are shown
/// but disabled, so the list explains why an option is missing instead of
/// silently dropping it.
class AppLockDialog extends StatefulWidget {
  const AppLockDialog({required this.selected, this.authenticator, super.key});

  final AppLockMethod selected;

  /// Injectable so a test can pin what the device reports.
  final BiometricAuthenticator? authenticator;

  static Future<AppLockMethod?> show(
    BuildContext context, {
    required AppLockMethod selected,
    BiometricAuthenticator? authenticator,
  }) {
    return showDialog<AppLockMethod>(
      context: context,
      // The More screen is a branch of a StatefulShellRoute, whose Navigator
      // sits inside the scaffold that draws the bottom nav bar — a route
      // pushed there leaves the bar sitting on top.
      useRootNavigator: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
        child: AppLockDialog(selected: selected, authenticator: authenticator),
      ),
    );
  }

  @override
  State<AppLockDialog> createState() => _AppLockDialogState();
}

class _AppLockDialogState extends State<AppLockDialog> {
  late final BiometricAuthenticator _auth =
      widget.authenticator ?? BiometricAuthenticator();

  /// Null until the device has answered.
  BiometricMethod? _available;

  @override
  void initState() {
    super.initState();
    _auth.availableMethod().then((method) {
      if (mounted) setState(() => _available = method);
    });
  }

  static bool _isBiometric(AppLockMethod m) =>
      m == AppLockMethod.fingerprint || m == AppLockMethod.face;

  /// A password and no-lock are always offered; the biometrics depend on the
  /// hardware, and stay disabled until the device has said which it has.
  bool _isEnabled(AppLockMethod method) => switch (method) {
    AppLockMethod.none || AppLockMethod.password => true,
    AppLockMethod.fingerprint => _available == BiometricMethod.fingerprint,
    AppLockMethod.face => _available == BiometricMethod.face,
  };

  /// Only a biometric the device has actually ruled out earns the caption —
  /// while the answer is still pending the row is merely inert, and saying
  /// "not available" then would be a guess.
  bool _isRuledOut(AppLockMethod method) =>
      _available != null && _isBiometric(method) && !_isEnabled(method);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.sheet),
        border: Border.all(color: colors.borderHairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // Stretch, so the heading block fills the width and aligns to the
        // reading edge rather than shrink-wrapping to the centre.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MoreKeys.appLockTitle.tr(),
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  MoreKeys.appLockBody.tr(),
                  style: TextStyle(color: colors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          for (final method in AppLockMethod.values)
            _MethodRow(
              method: method,
              selected: method == widget.selected,
              enabled: _isEnabled(method),
              ruledOut: _isRuledOut(method),
              onTap: () => Navigator.of(context).pop(method),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _MethodRow extends StatelessWidget {
  const _MethodRow({
    required this.method,
    required this.selected,
    required this.enabled,
    required this.ruledOut,
    required this.onTap,
  });

  final AppLockMethod method;
  final bool selected;
  final bool enabled;

  /// The device answered and does not offer this one.
  final bool ruledOut;

  final VoidCallback onTap;

  String get _label => switch (method) {
    AppLockMethod.none => MoreKeys.appLockOff,
    AppLockMethod.fingerprint => LoginKeys.fingerprint,
    AppLockMethod.face => LoginKeys.faceId,
    AppLockMethod.password => MoreKeys.appLockPassword,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ink = enabled ? colors.textPrimary : colors.textTertiary;

    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            SizedBox(
              width: AppSizes.iconLg,
              height: AppSizes.iconLg,
              child: _Glyph(method: method, color: ink),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _label.tr(),
                    style: TextStyle(
                      color: ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (ruledOut) ...[
                    const SizedBox(height: 2),
                    Text(
                      MoreKeys.appLockUnavailable.tr(),
                      style: TextStyle(
                        color: colors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            if (selected)
              Icon(
                Icons.check,
                color: colors.brandGreen,
                size: AppSizes.iconLg,
              ),
          ],
        ),
      ),
    );
  }
}

/// The artwork for a method — the shipped biometric marks, and Material
/// glyphs for the two that have none.
class _Glyph extends StatelessWidget {
  const _Glyph({required this.method, required this.color});

  final AppLockMethod method;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final asset = switch (method) {
      AppLockMethod.fingerprint => AppAssets.fingerprintIcon,
      AppLockMethod.face => AppAssets.faceIdIcon,
      _ => null,
    };

    if (asset != null) {
      return SvgPicture.asset(
        asset,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return Icon(
      method == AppLockMethod.password
          ? Icons.password_outlined
          : Icons.lock_open_outlined,
      color: color,
      size: AppSizes.iconLg,
    );
  }
}
