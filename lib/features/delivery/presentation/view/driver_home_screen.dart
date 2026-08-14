import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/order_card.dart';
import '../../../../core/router/app_routes.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.lg,
              bottom: 120, // space for nav bar
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(context),
                const SizedBox(height: AppSpacing.xl),

                // Active Order Section
                Text(
                  'driver_home.active_order'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildActiveOrder(context),
                const SizedBox(height: AppSpacing.xl),

                // Orders List Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'driver_home.orders_list'.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    Text(
                      'driver_home.view_all'.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _buildOrdersTabs(context),
                const SizedBox(height: AppSpacing.md),

                // Mock Orders List
                _buildOrderListItem(
                  context: context,
                  orderId: 'ORD-2024-256',
                  fuelType: 'driver_home.fuel_95'.tr(),
                  quantity: 'driver_home.quantity_value'.tr(),
                  stationName: 'driver_mock_extra.station_rehab'.tr(),
                  statusText: 'driver_home.tab_delivering'.tr(),
                  statusColor: context.colors.brandGreen,
                  iconPath: 'assets/driverHomePage/station2.svg',
                  iconBgColor: const Color(0xFFF3E8FF),
                  date: 'driver_mock_extra.date_aug'.tr(),
                  time: 'driver_mock_extra.time_pm'.tr(),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildOrderListItem(
                  context: context,
                  orderId: 'ORD-2024-256',
                  fuelType: 'driver_mock_extra.fuel_diesel'.tr(),
                  quantity: 'driver_mock_extra.quantity_33'.tr(),
                  stationName: 'driver_mock_extra.station_rehab'.tr(),
                  statusText: 'driver_home.status_assigned'.tr(),
                  statusColor: context.colors.brandBlue,
                  iconPath: 'assets/driverHomePage/station3.svg',
                  iconBgColor: const Color(0xFFFFF0E6),
                  date: 'driver_mock_extra.date_aug'.tr(),
                  time: 'driver_mock_extra.time_pm'.tr(),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildOrderListItem(
                  context: context,
                  orderId: 'ORD-2024-256',
                  fuelType: 'driver_mock_extra.fuel_diesel'.tr(),
                  quantity: 'driver_mock_extra.quantity_33'.tr(),
                  stationName: 'driver_mock_extra.station_rehab'.tr(),
                  statusText: 'driver_home.status_completed'.tr(),
                  statusColor: context.colors.textSecondary,
                  iconPath: 'assets/driverHomePage/station3.svg',
                  iconBgColor: const Color(0xFFFFF0E6),
                  date: 'driver_mock_extra.date_aug'.tr(),
                  time: 'driver_mock_extra.time_pm'.tr(),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Quick Actions
                Text(
                  'driver_home.quick_actions'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildQuickActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.greenTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.brandGreen.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Right Side (First Child)
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: context.colors.brandGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset('assets/driverHomePage/steering.svg', width: 24, height: 24),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'driver_home.online'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: context.colors.brandGreen,
                    ),
                  ),
                  Text(
                    'driver_home.ready_to_receive'.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Left Side (Second Child)
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'driver_home.rating'.tr(),
                    style: TextStyle(fontSize: 10, color: context.colors.textSecondary),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/driverHomePage/star.svg', width: 14, height: 14),
                      const SizedBox(width: 4),
                      Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'driver_home.orders_today'.tr(),
                    style: TextStyle(fontSize: 10, color: context.colors.textSecondary),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/driverHomePage/order.svg', width: 14, height: 14),
                      const SizedBox(width: 4),
                      Text(
                        '5',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrder(BuildContext context) {
    return OrderCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Right Side: Fuel Info (First Child)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: SvgPicture.asset('assets/driverHomePage/station2.svg', width: 20, height: 20),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('driver_home.fuel_type'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                            Text('driver_home.fuel_95'.tr(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('driver_home.quantity'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                    Text('driver_home.quantity_value'.tr(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                    const SizedBox(height: 8),
                    Text('driver_home.station'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                    Text('driver_home.driver_name'.tr(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.brandGreen)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Center: Circular progress (Second Child)
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: 0.65,
                      strokeWidth: 8,
                      backgroundColor: context.colors.borderHairline,
                      color: context.colors.brandGreen,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/driverHomePage/station.svg', width: 24, height: 24),
                      const SizedBox(height: 2),
                      Text(
                        'driver_home.time_remaining'.tr(),
                        style: TextStyle(fontSize: 8, color: context.colors.textSecondary),
                      ),
                      Text(
                        '35',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: context.colors.textPrimary),
                      ),
                      Text(
                        'driver_home.minutes'.tr(),
                        style: TextStyle(fontSize: 10, color: context.colors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              // Left Side: Order Info (Third Child)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.greenTint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 6, height: 6, decoration: BoxDecoration(color: context.colors.brandGreen, shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          Text('driver_home.in_transit'.tr(), style: TextStyle(fontSize: 10, color: context.colors.brandGreen, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('ORD-2024-256', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset('assets/driverHomePage/hour.svg', width: 12, height: 12),
                        const SizedBox(width: 4),
                        Text('driver_home.today_time'.tr(), style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                      ],
                    ),
                    Text('driver_home.requested_time'.tr(), style: TextStyle(fontSize: 8, color: context.colors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              SvgPicture.asset('assets/driverHomePage/bin.svg', width: 16, height: 16),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: context.colors.textSecondary, fontFamily: 'Tajawal'),
                    children: [
                      TextSpan(text: 'driver_home.station_name'.tr(), style: TextStyle(fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                      TextSpan(text: 'driver_home.station_address'.tr()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: context.colors.borderHairline),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 44),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/driverHomePage/phone.svg', width: 16, height: 16),
                const SizedBox(width: 8),
                Text('driver_home.contact_customer'.tr(), style: TextStyle(color: context.colors.brandBlue)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              context.push(AppRoutes.driverOrderDetail('ORD-2024-256'));
            },
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.brandBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 44),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/driverHomePage/share.svg', width: 16, height: 16),
                const SizedBox(width: 8),
                Text('driver_home.start_navigation'.tr(), style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        // Rightmost (First Child)
        Expanded(child: _buildActionItem(context, 'assets/driverHomePage/bin.svg', 'driver_home.nearby_stations'.tr())),
        const SizedBox(width: 8),
        Expanded(child: _buildActionItem(context, 'assets/driverHomePage/support.svg', 'driver_home.support'.tr())),
        const SizedBox(width: 8),
        Expanded(child: _buildActionItem(context, 'assets/driverHomePage/invoice.svg', 'driver_home.delivery_report'.tr())),
        const SizedBox(width: 8),
        // Leftmost (Last Child)
        Expanded(child: _buildActionItem(context, 'assets/driverHomePage/scan.svg', 'driver_home.scan_qr'.tr())),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, String iconPath, String label) {
    return Container(
      height: 80, // Fixed height so all items are equal
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: 2),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.borderHairline),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center contents vertically
        children: [
          SvgPicture.asset(iconPath, width: 24, height: 24),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: context.colors.textSecondary, fontWeight: FontWeight.w500, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTabs(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabItem(context, 'driver_home.tab_all'.tr(), true, null),
          const SizedBox(width: 8),
          _buildTabItem(context, 'driver_home.tab_delivering'.tr(), false, 2),
          const SizedBox(width: 8),
          _buildTabItem(context, 'driver_home.tab_on_way'.tr(), false, 2),
          const SizedBox(width: 8),
          _buildTabItem(context, 'driver_home.tab_completed'.tr(), false, 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String label, bool isSelected, int? count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? context.colors.brandBlue : context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? context.colors.brandBlue : context.colors.borderHairline),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : context.colors.textPrimary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : context.colors.textSecondary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? context.colors.brandBlue : context.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderListItem({
    required BuildContext context,
    required String orderId,
    required String fuelType,
    required String quantity,
    required String stationName,
    required String statusText,
    required Color statusColor,
    required String iconPath,
    required Color iconBgColor,
    Color? iconColor,
    required String date,
    required String time,
  }) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.driverOrderDetail(orderId));
      },
      child: OrderCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Far Right: Chevron
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Icon(Icons.arrow_back_ios, color: context.colors.textPrimary, size: 16),
            ),
            const SizedBox(width: 12),
  
            // Right Side: Icon + Fuel Info (Top) and Date/Time (Bottom)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            iconPath,
                            width: 24,
                            height: 24,
                            colorFilter: iconColor != null ? ColorFilter.mode(iconColor, BlendMode.srcIn) : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fuelType, style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                            Text(quantity, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/driverHomePage/date.svg', 
                          width: 12, height: 12,
                          colorFilter: ColorFilter.mode(context.colors.brandGreen, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 4),
                        Text(date, style: TextStyle(fontSize: 10, color: context.colors.brandGreen, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 12),
                        SvgPicture.asset(
                          'assets/driverHomePage/hour.svg', 
                          width: 12, height: 12,
                          colorFilter: ColorFilter.mode(context.colors.brandGreen, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 4),
                        Text(time, style: TextStyle(fontSize: 10, color: context.colors.brandGreen, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
  
            // Left Side: Order Info + Status Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(orderId, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                const SizedBox(height: 4),
                Text(stationName, style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(statusText, style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
