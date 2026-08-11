import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/localization/translation_keys.dart';
import '../widgets/current_order_card.dart';
import '../widgets/current_station_card.dart';
import '../widgets/finance_cards_row.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../widgets/new_request_button.dart';
import '../widgets/quick_glance_row.dart';
import '../widgets/quick_request_list.dart';
import '../widgets/section_header.dart';
import '../../../../core/theme/theme_context.dart';

/// The client's home dashboard: current station, balances, the active
/// order and shortcuts to request more fuel.
class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  // Placeholder data until this screen is wired to a real order/session
  // source. A getter rather than a `const` field: the translated parts have
  // to be resolved per build so they follow a locale switch.
  CurrentOrderSummary _currentOrder(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    return CurrentOrderSummary(
      fuelType: FuelKeys.gasoline95.tr(),
      quantity: '20,000 ${CommonKeys.litre.tr()}',
      statusLabel: HomeKeys.statInDelivery.tr(),
      driverName: isAr ? 'أحمد السبيعي' : 'Ahmed Al-Subaie',
      truckPlate: 'ABC-1234',
      progress: 0.65,
      etaMinutes: '35',
      orderId: 'ORD-2024-256',
      orderDate: '02/05/2024',
      orderTime: isAr ? '04:35 م' : '04:35 PM',
    );
  }

  @override
  Widget build(BuildContext context) {
    // No Directionality override: MaterialApp already supplies the direction
    // that matches the active locale, so the dashboard mirrors itself.
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: AppSpacing.dashboardNavBarClearance,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The bar takes the inset the list screens' headers use rather
              // than the dashboard's wider gutter, so it measures the same on
              // every screen. The content below keeps the gutter.
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.topBarInsetH,
                  vertical: AppSpacing.topBarInsetV,
                ),
                child: AppTopBar(
                  showProfile: true,
                  notificationCount: 3,
                  onNotificationTap: () =>
                      context.push(AppRoutes.notifications),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CurrentStationCard(
            name: context.locale.languageCode == 'ar'
                ? 'محطة الرحاب'
                : 'Al Rehab Station',
            address: context.locale.languageCode == 'ar'
                ? 'جدة - طريق مكة القديم - حي البوادي'
                : 'Jeddah - Old Makkah Road - Al Bawadi District',
            onChangeStation: () {},
            onOpenStations: () => context.push(AppRoutes.clientStations),
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
          SectionHeader(HomeKeys.currentOrderSection.tr()),
          const SizedBox(height: AppSpacing.md),
          CurrentOrderCard(
            order: _currentOrder(context),
            onTrackOrder: () {},
            onContactDriver: () {},
          ),
          const SizedBox(height: AppSpacing.xxl),
          SectionHeader(HomeKeys.quickRequestSection.tr()),
          const SizedBox(height: AppSpacing.md),
          const QuickRequestList(),
          const SizedBox(height: AppSpacing.xxl),
          SectionHeader(HomeKeys.quickGlanceSection.tr()),
          const SizedBox(height: AppSpacing.md),
          QuickGlanceRow(stats: defaultOrderCountStats(context)),
        ],
      ),
    );
  }
}
