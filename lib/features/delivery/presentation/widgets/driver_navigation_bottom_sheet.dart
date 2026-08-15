import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../view/driver_scan_screen.dart';

class DriverNavigationBottomSheet extends StatefulWidget {
  const DriverNavigationBottomSheet({super.key});

  @override
  State<DriverNavigationBottomSheet> createState() => _DriverNavigationBottomSheetState();
}

class _DriverNavigationBottomSheetState extends State<DriverNavigationBottomSheet> {
  bool _isExpanded = true;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! > 0 && _isExpanded) {
            _toggleExpanded();
          } else if (details.primaryVelocity! < 0 && !_isExpanded) {
            _toggleExpanded();
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            GestureDetector(
              onTap: _toggleExpanded,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.colors.borderHairline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),

            // ===== Station Info Row =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Station icon (appears on RIGHT in RTL)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colors.brandGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/driverOrderPage/station.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(context.colors.brandGreen, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info (middle)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DriverNavigationKeys.stationName.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DriverNavigationKeys.stationAddress.tr(),
                        style: TextStyle(fontSize: 10, color: context.colors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset('assets/driverOrderPage/map_pin.svg', width: 14, height: 14),
                          const SizedBox(width: 4),
                          Text(
                            DriverNavigationKeys.viewOnMap.tr(),
                            style: TextStyle(fontSize: 10, color: context.colors.brandGreen, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Contact button (appears on LEFT in RTL)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: context.colors.borderHairline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/driverOrderPage/phone.svg',
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(context.colors.brandBlue, BlendMode.srcIn),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DriverNavigationKeys.contactCustomer.tr(),
                        style: TextStyle(color: context.colors.brandBlue, fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // ===== Collapsible Content =====
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: !_isExpanded
                  ? const SizedBox(width: double.infinity)
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 3 Info Cards
                        Row(
                          children: [
                            Expanded(child: _InfoTile(icon: 'assets/driverOrderPage/date.svg', title: DriverNavigationKeys.requestedTime.tr(), value: 'اليوم, 04:30 م', color: const Color(0xFF22C55E))),
                            const SizedBox(width: 10),
                            Expanded(child: _InfoTile(icon: 'assets/driverOrderPage/station 98.svg', title: DriverNavigationKeys.fuelType.tr(), value: 'بنزين 95', color: Colors.purple)),
                            const SizedBox(width: 10),
                            Expanded(child: _InfoTile(icon: 'assets/driverOrderPage/waterDrop.svg', title: DriverNavigationKeys.quantity.tr(), value: '20,000 لتر', color: Colors.orange)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Scan Code Button
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DriverScanScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: context.colors.borderHairline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(DriverNavigationKeys.scanDeliveryCode.tr(), style: TextStyle(color: context.colors.brandBlue, fontSize: 14, fontWeight: FontWeight.w700)),
                              const SizedBox(width: 8),
                              SvgPicture.asset('assets/driverOrderPage/scan_code.svg', width: 20, height: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Info Banner
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: context.colors.brandBlue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/driverOrderPage/shield_check.svg', width: 16, height: 16),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  DriverNavigationKeys.deliveryHint.tr(),
                                  style: TextStyle(color: context.colors.brandBlue, fontSize: 10, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
            ),

            // ===== Start Navigation Button =====
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: context.colors.brandBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DriverNavigationKeys.startNavigation.tr(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/driverOrderPage/navigation.svg', width: 20, height: 20),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ===== I Cannot Reach Button =====
            TextButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DriverNavigationKeys.cannotReach.tr(), style: TextStyle(color: context.colors.brandBlue, fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/driverOrderPage/info_circle.svg', width: 16, height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final String icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.borderHairline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(icon, width: 16, height: 16, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(title, style: TextStyle(color: context.colors.textSecondary, fontSize: 9)),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(color: context.colors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
