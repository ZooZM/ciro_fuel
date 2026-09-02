import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_action_icon.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../orders/presentation/constants/order_formatting.dart';
import '../../../orders/presentation/constants/order_presentation.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/cubit/orders_state.dart';
import '../../../orders/presentation/widgets/order_list_card.dart';

/// One of the four real delivery categories a driver's own order list
/// filters by (FR-020/FR-020a/FR-020b) — not the invoice vocabulary
/// (`InvoicesKeys.tabAll`/`tabDeferred`/`tabPaid`/`tabFailed`) this screen
/// used to borrow by copy-paste, and not the client's own `OrderFilter`
/// (whose categories — under review, awaiting payment, … — describe a
/// billing lifecycle a driver never sees any part of).
enum _DriverDeliveryTab {
  all(<OrderStatus>{}),
  inProgress({OrderStatus.loading, OrderStatus.inTransit, OrderStatus.unloading}),
  completed({OrderStatus.delivered}),
  cancelled({OrderStatus.cancelled});

  const _DriverDeliveryTab(this.statuses);
  final Set<OrderStatus> statuses;

  String label(BuildContext context) => switch (this) {
    _DriverDeliveryTab.all => 'driver_orders.tab_all'.tr(),
    _DriverDeliveryTab.inProgress => 'driver_orders.tab_in_progress'.tr(),
    _DriverDeliveryTab.completed => 'driver_orders.tab_completed'.tr(),
    _DriverDeliveryTab.cancelled => 'driver_orders.tab_cancelled'.tr(),
  };

  bool matches(Order order) =>
      statuses.isEmpty || statuses.contains(order.status);
}

class DriverOrdersScreen extends StatefulWidget {
  const DriverOrdersScreen({super.key});

  @override
  State<DriverOrdersScreen> createState() => _DriverOrdersScreenState();
}

class _DriverOrdersScreenState extends State<DriverOrdersScreen> {
  late final OrdersCubit _cubit;
  late final ScrollController _scrollController;

  _DriverDeliveryTab _selectedTab = _DriverDeliveryTab.all;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OrdersCubit>();
    // Session-lifetime singleton (spec 005 FR-047/T028, reused as-is here
    // per research R4): only load if nothing has been fetched yet —
    // returning to this tab must not refetch.
    if (_cubit.state is OrdersLoading) {
      _cubit.load();
    }
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 300;
    if (_scrollController.position.pixels >= threshold) {
      _cubit.loadMore();
    }
  }

  /// `inProgress` spans two backend statuses, which the single-value
  /// `?status=` query can't express in one request — every remaining page
  /// is fetched first (same reasoning, same shape, as the client's own
  /// `OrdersListScreen._applyFilter`), so switching to it never silently
  /// narrows to whatever happened to already be loaded (FR-020b).
  Future<void> _selectTab(_DriverDeliveryTab tab) async {
    setState(() => _selectedTab = tab);
    if (tab.statuses.length <= 1) {
      await _cubit.setStatusFilter(
        tab.statuses.isEmpty ? null : tab.statuses.first,
      );
      return;
    }
    await _cubit.setStatusFilter(null);
    while (true) {
      final state = _cubit.state;
      if (state is! OrdersLoaded || state.nextCursor == null) break;
      await _cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BlocProvider<OrdersCubit>.value(
        value: _cubit,
        child: Scaffold(
          backgroundColor: context.colors.canvas,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _cubit.refresh,
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: _buildBody,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, OrdersState state) {
    return switch (state) {
      OrdersLoading() => const Center(child: CircularProgressIndicator()),
      OrdersLoadFailure() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(OrdersKeys.loadFailed.tr()),
            const SizedBox(height: AppSpacing.md),
            TextButton(onPressed: _cubit.load, child: Text(OrdersKeys.retry.tr())),
          ],
        ),
      ),
      OrdersLoaded(:final orders) => _buildList(context, orders, state),
    };
  }

  Widget _buildList(BuildContext context, List<Order> orders, OrdersLoaded state) {
    final filtered = orders.where(_selectedTab.matches).toList();

    return ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: 120, // space for nav bar
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  OrdersListKeys.title.tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: context.colors.textPrimary),
                ),
                Text(
                  OrdersListKeys.count.tr(namedArgs: {'count': '${filtered.length}'}),
                  style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
                ),
              ],
            ),
            GestureDetector(
              onTap: _cubit.refresh,
              child: const AppActionIcon.reload(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildTabs(),
        const SizedBox(height: AppSpacing.lg),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                'driver_orders.empty'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
              ),
            ),
          )
        else
          for (final order in filtered) ...[
            _buildOrderCard(context, order),
            const SizedBox(height: AppSpacing.md),
          ],
        if (state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (state.loadMoreFailed)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: TextButton(onPressed: _cubit.loadMore, child: Text(OrdersKeys.retry.tr())),
            ),
          ),
      ],
    );
  }

  Widget _buildTabs() {
    final colors = context.colors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _DriverDeliveryTab.values.map((tab) {
          final isSelected = _selectedTab == tab;
          return GestureDetector(
            onTap: () => _selectTab(tab),
            child: Container(
              margin: EdgeInsetsDirectional.only(
                end: tab != _DriverDeliveryTab.values.last ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? colors.brandBlue : colors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? colors.brandBlue : colors.borderHairline),
              ),
              child: Text(
                tab.label(context),
                style: TextStyle(
                  color: isSelected ? Colors.white : colors.textSecondary,
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

  Widget _buildOrderCard(BuildContext context, Order order) {
    return OrderListCard(
      fuelLine:
          '${OrderPresentation.fuelLabel(order.fuelType)} · '
          '${OrderFormatting.litres(order.quantityLiters)}',
      orderId: OrderPresentation.shortReference(order.id),
      statusLabel: OrderPresentation.statusLabel(order.status),
      statusColor: OrderPresentation.statusColor(order.status),
      statusProgress: OrderPresentation.statusProgress(order.status),
      address: OrderPresentation.destinationLabel(order),
      date: OrderPresentation.date(order.statusChangedAt),
      time: OrderPresentation.time(order.statusChangedAt),
      onTap: () => context.push(AppRoutes.driverOrderDetail(order.id)),
    );
  }
}
