// `hide TextDirection`: easy_localization re-exports intl, whose
// TextDirection would shadow the one this screen lays out with.
import 'package:easy_localization/easy_localization.dart'
    hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/number_formatting.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../auth/presentation/cubit/session_state.dart';
import '../../../invoices/presentation/cubit/finance_cubit.dart';
import '../../../invoices/presentation/cubit/finance_state.dart';
import '../../../orders/presentation/constants/order_formatting.dart';
import '../../../orders/presentation/constants/order_presentation.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/cubit/orders_state.dart';
import '../widgets/current_order_card.dart';
import '../widgets/current_station_card.dart';
import '../widgets/finance_cards_row.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../widgets/new_request_button.dart';
import '../widgets/quick_glance_row.dart';
import '../widgets/quick_request_list.dart';
import '../widgets/section_header.dart';

/// The client's home dashboard: current station, balances, the active
/// order and shortcuts to request more fuel.
class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrdersCubit>(create: (_) => getIt<OrdersCubit>()..load()),
        BlocProvider<FinanceCubit>(
          create: (context) => getIt<FinanceCubit>()
            ..load(creditLimit: _creditLimitOf(context.read<SessionCubit>())),
        ),
      ],
      child: const _ClientHomeView(),
    );
  }

  static double? _creditLimitOf(SessionCubit sessionCubit) =>
      switch (sessionCubit.state) {
        SessionAuthenticated(:final user) => user.creditLimit,
        _ => null,
      };
}

class _ClientHomeView extends StatelessWidget {
  const _ClientHomeView();

  /// The order the dashboard follows: the most recently updated one that has
  /// not reached a terminal state. `statusChangedAt` is the backend's own
  /// stamp, so "most recent" never depends on device time.
  static Order? _activeOrder(List<Order> orders) {
    final live = orders.where((o) => !o.status.isTerminal).toList()
      ..sort((a, b) => b.statusChangedAt.compareTo(a.statusChangedAt));
    return live.isEmpty ? null : live.first;
  }

  static List<OrderCountStat> _stats(List<Order> orders) {
    int count(bool Function(Order) test) => orders.where(test).length;
    return [
      OrderCountStat(
        labelKey: HomeKeys.statCancelled,
        count:
            '${count((o) => o.status == OrderStatus.cancelled || o.status == OrderStatus.rejected)}',
        color: AppColors.red,
        icon: Icons.highlight_off,
      ),
      OrderCountStat(
        labelKey: HomeKeys.statInPreparation,
        count:
            '${count((o) => o.status == OrderStatus.pendingApproval || o.status == OrderStatus.approved || o.status == OrderStatus.pendingPayment)}',
        color: AppColors.amber,
        icon: Icons.hourglass_empty,
      ),
      OrderCountStat(
        labelKey: HomeKeys.statInDelivery,
        count:
            '${count((o) => o.status == OrderStatus.assignedToDriver || o.status == OrderStatus.inTransit || o.status == OrderStatus.unloading)}',
        color: AppColors.blue,
        icon: Icons.access_time,
      ),
      OrderCountStat(
        labelKey: HomeKeys.statDelivered,
        count: '${count((o) => o.status == OrderStatus.delivered)}',
        color: AppColors.green,
        // Uses the truck artwork, so it has no Material fallback.
        asset: AppAssets.dashboardStatTruckIcon,
      ),
    ];
  }

  static CurrentOrderSummary _summary(Order order) => CurrentOrderSummary(
    fuelType: OrderPresentation.fuelLabel(order.fuelType),
    quantity: OrderFormatting.litres(order.quantityLiters),
    statusLabel: OrderPresentation.statusLabel(order.status),
    driverName: order.driverSummary?.fullName ?? '—',
    truckPlate: order.driverSummary?.plateNumber ?? '—',
    progress: OrderPresentation.statusProgress(order.status),
    etaMinutes: OrderPresentation.etaLabel(order) ?? '—',
    orderId: OrderPresentation.shortReference(order.id),
    orderDate: OrderPresentation.date(order.statusChangedAt),
    orderTime: OrderPresentation.time(order.statusChangedAt),
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => Future.wait([
              context.read<OrdersCubit>().load(),
              context.read<FinanceCubit>().load(
                creditLimit: ClientHomeScreen._creditLimitOf(
                  context.read<SessionCubit>(),
                ),
              ),
            ]),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                left: AppSpacing.gutter,
                right: AppSpacing.gutter,
                top: AppSpacing.lg,
                bottom: AppSpacing.dashboardNavBarClearance,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TODO: the unread count is still the design's placeholder —
                  // wiring it means depending on NotificationsCubit here.
                  AppTopBar(
                    showProfile: true,
                    notificationCount: 3,
                    onNotificationTap: () =>
                        context.push(AppRoutes.notifications),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BlocBuilder<SessionCubit, SessionState>(
                    builder: (context, state) => _buildStationCard(state),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BlocBuilder<FinanceCubit, FinanceState>(
                    builder: (context, state) => switch (state) {
                      FinanceLoaded(
                        :final pendingInvoiceAmount,
                        :final availableBalanceAmount,
                      ) =>
                        FinanceCardsRow(
                          pendingInvoiceAmount: NumberFormatting.currency(
                            pendingInvoiceAmount,
                          ),
                          availableBalanceAmount: NumberFormatting.currency(
                            availableBalanceAmount,
                          ),
                        ),
                      _ => FinanceCardsRow(
                        pendingInvoiceAmount: NumberFormatting.currency(0),
                        availableBalanceAmount: NumberFormatting.currency(0),
                      ),
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  NewRequestButton(
                    onPressed: () => context.push(AppRoutes.clientCreateOrder),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SectionHeader(HomeKeys.currentOrderSection.tr()),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (context, state) => switch (state) {
                      OrdersLoading() => const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      OrdersLoadFailure() => _HomeMessage(
                        OrdersKeys.loadFailed.tr(),
                      ),
                      OrdersLoaded(:final orders) => _buildCurrentOrder(
                        context,
                        orders,
                      ),
                    },
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SectionHeader(HomeKeys.quickRequestSection.tr()),
                  const SizedBox(height: AppSpacing.md),
                  const QuickRequestList(),
                  const SizedBox(height: AppSpacing.xxl),
                  SectionHeader(HomeKeys.quickGlanceSection.tr()),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (context, state) => QuickGlanceRow(
                      stats: switch (state) {
                        OrdersLoaded(:final orders) => _stats(orders),
                        _ => defaultOrderCountStats(context),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStationCard(SessionState state) {
    final station = switch (state) {
      SessionAuthenticated(:final user) => user.station,
      _ => null,
    };
    return CurrentStationCard(
      name: station?.name ?? HomeKeys.stationNameUnavailable.tr(),
      address: station?.addressText ?? HomeKeys.stationNameUnavailable.tr(),
      onChangeStation: () {},
    );
  }

  Widget _buildCurrentOrder(BuildContext context, List<Order> orders) {
    final order = _activeOrder(orders);
    if (order == null) {
      return _HomeMessage(HomeKeys.noActiveOrder.tr());
    }
    return CurrentOrderCard(
      order: _summary(order),
      onTrackOrder: () => context.push(AppRoutes.clientOrderDetail(order.id)),
      onContactDriver: () {},
    );
  }
}

class _HomeMessage extends StatelessWidget {
  const _HomeMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.grey, fontSize: 14),
        ),
      ),
    );
  }
}
