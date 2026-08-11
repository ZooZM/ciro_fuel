// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../localization/translation_keys.dart';
import '../theme/app_colors.dart';
import '../theme/theme_context.dart';

const _kPayment = 'assets/NavBar/payment.svg';
const _kOrder = 'assets/NavBar/order.svg';
const _kHome = 'assets/NavBar/home.svg';
const _kInvoice = 'assets/NavBar/invoice.svg';
const _kMore = 'assets/NavBar/more.svg';

class MainNavBar extends StatelessWidget {
  const MainNavBar({
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
    // `.tr()` reads easy_localization's global store, not an InheritedWidget,
    // so nothing in this bar would otherwise depend on the locale. The shell
    // that hosts it is only rebuilt by navigation, which is why the labels
    // used to keep whatever language they were first built in until another
    // tab was opened. Depending on `Localizations` fixes that, and does it at
    // the right moment: it republishes only once every delegate has reloaded,
    // by which point the catalogue behind `.tr()` is the new locale's.
    final locale = context.locale;

    return SizedBox(
      key: ValueKey(locale),
      height: 120,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // ── Layer 2: White navbar with notch cutout ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 80),
              painter: _NavBarPainter(
                context.colors.surface,
                shadow:
                    (Theme.of(context).brightness == Brightness.dark
                            ? AppColors.shadowNavDark
                            : AppColors.shadowNav)
                        .first,
              ),
            ),
          ),

          // ── Layer 3: Navigation items ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 80,
              // No explicit textDirection: the row mirrors with the locale,
              // so Payments leads on the right in Arabic and on the left in
              // English.
              child: Row(
                children: [
                  // Payments - index 0
                  _NavItem(
                    icon: _kPayment,
                    label: NavKeys.payments.tr(context: context),
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  // Orders - index 1
                  _NavItem(
                    icon: _kOrder,
                    label: NavKeys.orders.tr(context: context),
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                    badgeCount: notificationCount,
                  ),
                  // Center gap for FAB — only the label here
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(2),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 42),
                        child: Text(
                          NavKeys.home.tr(context: context),
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
                  // Invoices - index 3
                  _NavItem(
                    icon: _kInvoice,
                    label: NavKeys.invoices.tr(context: context),
                    isSelected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  // More - index 4
                  _NavItem(
                    icon: _kMore,
                    label: NavKeys.more.tr(context: context),
                    isSelected: currentIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),

          // ── Layer 4: Green FAB (Home button) ──
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

// ── Individual nav bar item ──
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
                SvgPicture.asset(
                  icon,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
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

// ── Custom painter: the bar with a U-shaped notch and rounded top corners ──
class _NavBarPainter extends CustomPainter {
  const _NavBarPainter(this.color, {required this.shadow});

  /// The surface colour of the active theme — a painter has no [BuildContext]
  /// of its own, so the bar's fill is handed in from the widget above.
  final Color color;

  /// Lifts the bar off the screen behind it. Handed in for the same reason as
  /// [color]: the dark theme casts a far deeper one.
  final BoxShadow shadow;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final double w = size.width;
    final double h = size.height;
    const double cornerRadius = 24.0;

    // Notch dimensions — deep smooth U-shape
    final double center = w / 2;
    const double notchRadius = 42.0;
    const double notchDepth = 36.0;
    const double notchSpread = notchRadius + 14.0;

    // Start from top-left corner (rounded)
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Line to the left edge of the notch
    path.lineTo(center - notchSpread, 0);

    // Smooth cubic bezier into the notch
    path.cubicTo(
      center - notchSpread + 20,
      0,
      center - notchRadius + 8,
      notchDepth,
      center,
      notchDepth,
    );

    // Smooth cubic bezier out of the notch
    path.cubicTo(
      center + notchRadius - 8,
      notchDepth,
      center + notchSpread - 20,
      0,
      center + notchSpread,
      0,
    );

    // Line to the top-right corner (rounded)
    path.lineTo(w - cornerRadius, 0);
    path.quadraticBezierTo(w, 0, w, cornerRadius);

    // Down the right side and across the bottom, rounded at both corners:
    // the bar floats clear of the screen edge, so its underside shows.
    path.lineTo(w, h - cornerRadius);
    path.quadraticBezierTo(w, h, w - cornerRadius, h);
    path.lineTo(cornerRadius, h);
    path.quadraticBezierTo(0, h, 0, h - cornerRadius);
    path.lineTo(0, cornerRadius);

    path.close();

    // A blurred copy of the same outline rather than `canvas.drawShadow`:
    // the notch and the rounded corners cast it too, and the token throws it
    // upwards — the bar sits on the bottom edge, so a downward shadow would
    // fall off the screen.
    canvas.drawPath(
      path.shift(shadow.offset),
      Paint()
        ..color = shadow.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurSigma),
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NavBarPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.shadow != shadow;
}
