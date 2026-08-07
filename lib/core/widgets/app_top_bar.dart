import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';

const _kLogo = 'assets/Logo/appBar Logo.svg';
const _kNotification = 'assets/Icons/notification.svg';

const _kNavy = Color(0xFF162155);
const _kSurface = Color(0xFFFFFFFF);
const _kBadge = Color(0xFFEF3F3F);

/// The header the pushed client screens share: back on the left, the CIRO FUEL
/// logo centred, and the notification bell with its unread badge on the right.
///
/// Laid out left-to-right so the back button keeps the left edge even though
/// the pages it sits on run right-to-left.
class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key, this.notificationCount = 3, this.onBack});

  /// Shown in the bell's badge. Zero hides it.
  final int notificationCount;

  /// Defaults to popping the current route.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    // Left-to-right for the whole bar, not just the Row's layout: the back
    // chevron is a matchTextDirection icon, so under the page's RTL it would
    // mirror and point right. This keeps it pointing left, as drawn.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TopBarButton(
            onTap: onBack ?? () => context.pop(),
            child: const Icon(Icons.arrow_back_ios_new, size: 20, color: _kNavy),
          ),
          SvgPicture.asset(_kLogo, height: 20),
          Stack(
            clipBehavior: Clip.none,
            children: [
              _TopBarButton(
                onTap: () => context.push(AppRoutes.notifications),
                child: SvgPicture.asset(
                  _kNotification,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(_kNavy, BlendMode.srcIn),
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: _kBadge,
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
          color: _kSurface,
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
