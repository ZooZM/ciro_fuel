import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _kPayment = 'assets/NavBar/payment.svg';
const _kOrder = 'assets/NavBar/order.svg';
const _kHome = 'assets/NavBar/home.svg';
const _kInvoice = 'assets/NavBar/invoice.svg';
const _kMore = 'assets/NavBar/more.svg';

const _kGreen = Color(0xFF17A34A);
const _kGrey = Color(0xFF9CA3AF);
const _kDark = Color(0xFF1A1A2E);
const _kBlue = Color(0xFF1E5FFF);

class MainNavBar extends StatelessWidget {
  const MainNavBar({super.key, required this.currentIndex, required this.onTap, this.notificationCount = 0});

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            child: CustomPaint(size: const Size(double.infinity, 80), painter: _NavBarPainter()),
          ),

          // ── Layer 3: Navigation items ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 80,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  // المدفوعات (Payments) - index 0
                  _NavItem(
                    icon: _kPayment,
                    label: 'المدفوعات',
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  // طلباتي (Orders) - index 1
                  _NavItem(
                    icon: _kOrder,
                    label: 'طلباتي',
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
                          'الرئيسية',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: currentIndex == 2 ? _kGreen : _kGrey,
                            fontWeight: currentIndex == 2 ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // الفواتير (Invoices) - index 3
                  _NavItem(
                    icon: _kInvoice,
                    label: 'الفواتير',
                    isSelected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  // المزيد (More) - index 4
                  _NavItem(
                    icon: _kMore,
                    label: 'المزيد',
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
                  color: _kGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _kGreen.withValues(alpha: 0.3),
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
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
    final color = isSelected ? _kBlue : _kGrey;

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
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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

// ── Custom painter: white bar with U-shaped notch and rounded top corners ──
class _NavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    final double w = size.width;
    final double h = size.height;
    final double cornerRadius = 24.0;

    // Notch dimensions — deep smooth U-shape
    final double center = w / 2;
    final double notchRadius = 42.0;
    final double notchDepth = 36.0;
    final double notchSpread = notchRadius + 14.0;

    // Start from top-left corner (rounded)
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Line to the left edge of the notch
    path.lineTo(center - notchSpread, 0);

    // Smooth cubic bezier into the notch
    path.cubicTo(center - notchSpread + 20, 0, center - notchRadius + 8, notchDepth, center, notchDepth);

    // Smooth cubic bezier out of the notch
    path.cubicTo(center + notchRadius - 8, notchDepth, center + notchSpread - 20, 0, center + notchSpread, 0);

    // Line to the top-right corner (rounded)
    path.lineTo(w - cornerRadius, 0);
    path.quadraticBezierTo(w, 0, w, cornerRadius);

    // Down the right side, across the bottom, back up
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.lineTo(0, cornerRadius);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
