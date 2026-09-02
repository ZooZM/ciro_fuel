import 'package:flutter/material.dart';
import '../session/current_avatar.dart';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_assets.dart';
import 'app_logo.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_context.dart';
import '../router/app_routes.dart';

/// The unified header for all screens: profile or back on the left, the CIRO FUEL
/// logo centred, and the notification bell with its unread badge on the right.
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    this.notificationCount = 3,
    this.onBack,
    this.onNotificationTap,
    this.onProfileTap,
    this.showProfile = false,
  });

  /// Shown in the bell's badge. Zero hides it.
  final int notificationCount;

  /// Defaults to popping the current route.
  final VoidCallback? onBack;

  /// Defaults to pushing the notifications route.
  final VoidCallback? onNotificationTap;

  /// Defaults to pushing the profile route — the same screen the profile card
  /// on المزيد opens. Only consulted when [showProfile] is true.
  final VoidCallback? onProfileTap;

  /// If true, shows the profile picture instead of the back button.
  final bool showProfile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.topBarHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Leading edge: Profile or Back button
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: showProfile
                ? GestureDetector(
                    onTap:
                        onProfileTap ??
                        () => context.push(AppRoutes.clientProfile),
                    child: const _ProfileAvatar(),
                  )
                : _TopBarButton(
                    onTap: onBack ?? () => context.pop(),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 2.0),
                      // No manual swap: arrow_back_ios_new is declared
                      // `matchTextDirection`, so Flutter already mirrors it —
                      // '<' under English, '>' under Arabic. Picking
                      // arrow_forward_ios for RTL on top of that mirrored it
                      // twice and pointed the back button the wrong way.
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
          ),

          // Centered Logo
          const AppLogo(),

          // Trailing edge: Notification bell
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _TopBarButton(
                  onTap:
                      onNotificationTap ??
                      () => context.push(AppRoutes.notifications),
                  child: SvgPicture.asset(
                    AppAssets.notificationIcon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      context.colors.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: context.colors.brandRed,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A white rounded square holding a single top-bar glyph.
class _TopBarButton extends StatelessWidget {
  const _TopBarButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              offset: Offset(0, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

/// The signed-in user's picture, or a neutral glyph until one exists.
///
/// This was a fixed `assets/HomePage/profile image.png` — a photograph of a
/// person — so every account displayed that stranger in the header of every
/// screen.
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  static const _size = AppSizes.dashboardProfileImageSize;

  @override
  Widget build(BuildContext context) {
    // Safe to call from build: it fetches at most once per session and
    // reports back through the notifier rather than by rebuilding here.
    CurrentAvatar.warmUp();

    return ValueListenableBuilder<Uint8List?>(
      valueListenable: CurrentAvatar.bytes,
      builder: (context, bytes, _) => Container(
        width: _size,
        height: _size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.borderHairline.withValues(alpha: 0.35),
        ),
        child: bytes != null
            ? SizedBox(child: Image.memory(bytes, fit: BoxFit.cover))
            : Center(
                child: SvgPicture.asset(
                  'assets/HomePage/profile.svg',
                  width: _size * 0.45,
                  height: _size * 0.45,
                  colorFilter: ColorFilter.mode(
                    context.colors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
      ),
    );
  }
}
