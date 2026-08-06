import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../constants/client_home_strings.dart';
import '../widgets/current_order_card.dart';
import '../widgets/current_station_card.dart';
import '../widgets/finance_cards_row.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/new_request_button.dart';
import '../widgets/quick_glance_row.dart';
import '../widgets/quick_request_list.dart';
import '../widgets/section_header.dart';

/// The client's home dashboard: current station, balances, the active
/// order and shortcuts to request more fuel.
class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  // Placeholder data until this screen is wired to a real order/session
  // source.
  static const _currentOrder = CurrentOrderSummary(
    fuelType: 'بنزين 95',
    quantity: '20,000 لتر',
    statusLabel: ClientHomeStrings.statInDelivery,
    driverName: 'أحمد السبيعي',
    truckPlate: 'ABC-1234',
    progress: 0.65,
    etaMinutes: '35',
    orderId: 'ORD-2024-256',
    orderDate: '02/05/2024',
    orderTime: '04:35 م',
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: AppSpacing.gutter,
              right: AppSpacing.gutter,
              top: AppSpacing.lg,
              bottom: AppSpacing.dashboardNavBarClearance,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeTopBar(
                  notificationCount: 3,
                  onNotificationTap: () =>
                      context.push(AppRoutes.notifications),
                ),
                const SizedBox(height: AppSpacing.xl),
                CurrentStationCard(
                  name: 'محطة الرحاب',
                  address: 'جدة - طريق مكة القديم - حي البوادي',
                  onChangeStation: () {},
                ),
                const SizedBox(height: AppSpacing.lg),
                const FinanceCardsRow(
                  pendingInvoiceAmount: '128,450',
                  availableBalanceAmount: '128,450',
                ),
                const SizedBox(height: AppSpacing.xl),
                NewRequestButton(
                  onPressed: () => context.push(AppRoutes.clientCreateOrder),
                ),
                const SizedBox(height: AppSpacing.xxl),
                const SectionHeader(ClientHomeStrings.currentOrderSection),
                const SizedBox(height: AppSpacing.md),
                CurrentOrderCard(
                  order: _currentOrder,
                  onTrackOrder: () {},
                  onContactDriver: () {},
                ),
                const SizedBox(height: AppSpacing.xxl),
                const SectionHeader(ClientHomeStrings.quickRequestSection),
                const SizedBox(height: AppSpacing.md),
                const QuickRequestList(),
                const SizedBox(height: AppSpacing.xxl),
                const SectionHeader(ClientHomeStrings.quickGlanceSection),
                const SizedBox(height: AppSpacing.md),
                const QuickGlanceRow(stats: defaultOrderCountStats),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
