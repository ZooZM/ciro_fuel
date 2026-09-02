import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../localization/translation_keys.dart';
import '../theme/app_colors.dart';
import '../theme/theme_context.dart';

const _kProfile = 'assets/HomePage/profile.svg';
const _kNotification = 'assets/icons/notification.svg';
const _kHome = 'assets/NavBar/home.svg';
const _kOrder = 'assets/NavBar/order.svg';
const _kMore = 'assets/NavBar/more.svg';

class DriverNavBar extends StatelessWidget {
  const DriverNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.notificationCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return SizedBox(
      key: ValueKey(locale),
      height: 120,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 80),
              painter: _DriverNavBarPainter(
                context.colors.surface,
                shadow:
                    (Theme.of(context).brightness == Brightness.dark
                            ? AppColors.shadowNavDark
                            : AppColors.shadowNav)
                        .first,
                borderColor: context.colors.borderHairline,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 80,
              child: Row(
                children: [
                  // Profile - index 0
                  _NavItem(
                    icon: _kProfile,
                    label: NavKeys.profile.tr(),
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  // Notifications - index 1
                  _NavItem(
                    icon: _kNotification,
                    label: NavKeys.notifications.tr(),
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                    badgeCount: notificationCount,
                  ),
                  // Center gap for FAB
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(2),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 42),
                        child: Text(
                          NavKeys.home.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: currentIndex == 2
                                ? context.colors.brandGreen
                                : context.colors.textSecondary,
                            fontWeight: currentIndex == 2
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Orders - index 3
                  _NavItem(
                    icon: _kOrder,
                    label: NavKeys.orders.tr(),
                    isSelected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  // More - index 4
                  _NavItem(
                    icon: _kMore,
                    label: NavKeys.more.tr(),
                    isSelected: currentIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 6,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: context.colors.brandGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.brandGreen.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    _kHome,
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount = 0,
  });

  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? context.colors.brandBlue
        : context.colors.textSecondary;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Fallback icon in case svg doesn't exist
                Builder(
                  builder: (context) {
                    try {
                      return SvgPicture.asset(
                        icon,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                      );
                    } catch (e) {
                      return Icon(Icons.error, color: color);
                    }
                  }
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.colors.brandRed,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverNavBarPainter extends CustomPainter {
  const _DriverNavBarPainter(this.color, {required this.shadow, required this.borderColor});
  final Color color;
  final BoxShadow shadow;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path();
    final double w = size.width;
    final double h = size.height;
    const double cornerRadius = 24.0;
    final double center = w / 2;
    const double notchRadius = 42.0;
    const double notchDepth = 36.0;
    const double notchSpread = notchRadius + 14.0;

    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(center - notchSpread, 0);
    path.cubicTo(
      center - notchSpread + 20, 0,
      center - notchRadius + 8, notchDepth,
      center, notchDepth,
    );
    path.cubicTo(
      center + notchRadius - 8, notchDepth,
      center + notchSpread - 20, 0,
      center + notchSpread, 0,
    );
    path.lineTo(w - cornerRadius, 0);
    path.quadraticBezierTo(w, 0, w, cornerRadius);
    path.lineTo(w, h - cornerRadius);
    path.quadraticBezierTo(w, h, w - cornerRadius, h);
    path.lineTo(cornerRadius, h);
    path.quadraticBezierTo(0, h, 0, h - cornerRadius);
    path.lineTo(0, cornerRadius);
    path.close();

    canvas.drawPath(
      path.shift(shadow.offset),
      Paint()
        ..color = shadow.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurSigma),
    );
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _DriverNavBarPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.shadow != shadow || oldDelegate.borderColor != borderColor;
}
