import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/order_card.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_action_icon.dart';
import '../../../../core/widgets/search_filter_bar.dart';
import '../../../../shared/models/filter_selection.dart';
import '../../../../shared/models/station_option.dart';

class DriverOrdersScreen extends StatefulWidget {
  const DriverOrdersScreen({super.key});

  @override
  State<DriverOrdersScreen> createState() => _DriverOrdersScreenState();
}

class _DriverOrdersScreenState extends State<DriverOrdersScreen> {
  FilterSelection _filters = const FilterSelection();
  int _selectedTabIndex = 0;

  static const List<String> _tabKeys = [
    InvoicesKeys.tabAll,
    InvoicesKeys.tabDeferred,
    InvoicesKeys.tabPaid,
    InvoicesKeys.tabFailed,
  ];

  static Map<String, Color> _tabColors(BuildContext context) => {
    InvoicesKeys.tabDeferred: context.colors.brandOrange,
    InvoicesKeys.tabPaid: context.colors.brandGreen,
    InvoicesKeys.tabFailed: context.colors.brandRed,
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(OrdersListKeys.title.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: context.colors.textPrimary)),
                      Text(OrdersListKeys.count.tr(namedArgs: {'count': '8'}), style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const AppActionIcon.reload(),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      GestureDetector(
                        onTap: () {},
                        child: const AppActionIcon.download(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Search Bar
              SearchFilterBar(
                hintText: CommonKeys.searchByOrderCode.tr(),
                sortOptions: const [
                  SortOption.newestFirst,
                  SortOption.oldestFirst,
                  SortOption.highestQuantity,
                  SortOption.lowestQuantity,
                ],
                filterStations: [
                  for (final s in kStationOptions)
                    if (s.isActive) s,
                ],
                showFuelTypeFilter: true,
                showDateFilter: true,
                filters: _filters,
                onFiltersChanged: (f) => setState(() => _filters = f),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Tabs
              _buildTabs(),
              const SizedBox(height: AppSpacing.lg),

              // Orders List
              _buildMockOrderListItem(
                context: context,
                orderId: 'ORD-2024-256',
                fuelType: 'driver_mock_extra.fuel_diesel'.tr(),
                quantity: 'driver_mock_extra.quantity_33'.tr(),
                stationName: 'driver_mock_extra.station_rehab'.tr(),
                statusText: 'driver_home.in_transit'.tr(),
                statusColor: context.colors.brandGreen,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildMockOrderListItem(
                context: context,
                orderId: 'ORD-2024-256',
                fuelType: 'driver_home.fuel_95'.tr(),
                quantity: 'driver_mock_extra.quantity_23'.tr(),
                stationName: 'driver_mock_extra.station_safa'.tr(),
                statusText: 'driver_home.status_assigned'.tr(),
                statusColor: context.colors.brandBlue,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildMockOrderListItem(
                context: context,
                orderId: 'ORD-2024-256',
                fuelType: 'driver_mock_extra.fuel_kero'.tr(),
                quantity: 'driver_mock_extra.quantity_30'.tr(),
                stationName: 'driver_mock_extra.station_galala'.tr(),
                statusText: 'driver_home.status_assigned'.tr(),
                statusColor: context.colors.brandBlue,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildMockOrderListItem(
                context: context,
                orderId: 'ORD-2024-256',
                fuelType: 'driver_mock_extra.fuel_91'.tr(),
                quantity: 'driver_mock_extra.quantity_28'.tr(),
                stationName: 'driver_mock_extra.station_yamama'.tr(),
                statusText: 'driver_home.status_completed'.tr(),
                statusColor: context.colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildTabs() {
    final colors = context.colors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tabKeys.asMap().entries.map((entry) {
          final index = entry.key;
          final tabKey = entry.value;
          final isSelected = _selectedTabIndex == index;

          final textColor = isSelected
              ? Colors.white
              : (_tabColors(context)[tabKey] ?? colors.textSecondary);

          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              margin: EdgeInsetsDirectional.only(
                end: index < _tabKeys.length - 1 ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? colors.brandBlue : colors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? colors.brandBlue : colors.borderHairline,
                ),
              ),
              child: Text(
                tabKey.tr(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMockOrderListItem({
    required BuildContext context,
    required String orderId,
    required String fuelType,
    required String quantity,
    required String stationName,
    required String statusText,
    required Color statusColor,
  }) {
    return OrderCard(
      child: InkWell(
        onTap: () => context.push(AppRoutes.driverOrderDetail(orderId)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(orderId, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(stationName, style: TextStyle(fontSize: 10, color: context.colors.textSecondary)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(statusText, style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(fuelType, style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
                        Text(quantity, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.textPrimary)),
                      ],
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset('assets/driverOrderPage/fuel_pump_diesel.svg', width: 40, height: 40),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: SvgPicture.asset('assets/driverOrderPage/clock_grey.svg', width: 14, height: 14),
                    ),
                    const SizedBox(width: 4),
                    Text('driver_mock_extra.time_pm'.tr(), style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: SvgPicture.asset('assets/driverOrderPage/calendar_grey.svg', width: 14, height: 14),
                    ),
                    const SizedBox(width: 4),
                    Text('driver_notifications.old_date'.tr(), style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 16),
            Icon(Icons.arrow_forward_ios, size: 16, color: context.colors.textPrimary),
          ],
        ),
      ),
    );
  }
}
