// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/search_filter_bar.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/models/filter_selection.dart';
import '../../../../shared/models/station_option.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../stations/domain/entities/station.dart';
import '../../../stations/domain/usecases/get_stations.dart';
import '../constants/order_formatting.dart';
import '../constants/order_presentation.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';
import '../widgets/order_list_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  /// The status-pill block. Several pill labels also appear on the order cards
  /// below, so tests need a handle on the block itself rather than on its
  /// copy.
  static const Key pillsKey = Key('orders-filter-pills');

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  late final OrdersCubit _cubit;
  late final ScrollController _scrollController;

  /// The client's real stations, for the filter sheet's station picker
  /// (spec 005 FR-001/FR-002) — never the fixed `kStationOptions` sample.
  List<StationOption> _filterStations = const [];

  OrderFilter _selectedFilter = OrderFilter.all;

  /// What the search/sort sheet last returned. Sorting and the fuel-type/date
  /// refinements it offers are local-only display preferences with no
  /// backend equivalent — unrelated to the status pills below, which are the
  /// real, server-applied filter (FR-005/FR-048d).
  FilterSelection _filters = const FilterSelection();

  static const List<OrderFilter> _filterOrder = [
    OrderFilter.all,
    OrderFilter.failed,
    OrderFilter.delivered,
    OrderFilter.inDelivery,
    OrderFilter.awaitingPayment,
    OrderFilter.confirmed,
    OrderFilter.underReview,
  ];

  /// The tint each filter pill draws in. Anything absent falls back to the
  /// default navy.
  static Map<OrderFilter, Color> _filterColors(BuildContext context) => {
    OrderFilter.inDelivery: context.colors.brandBlue,
    OrderFilter.delivered: context.colors.brandGreen,
    OrderFilter.failed: context.colors.brandRed,
    OrderFilter.awaitingPayment: context.colors.brandOrange,
    OrderFilter.all: context.colors.brandBlue,
  };

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OrdersCubit>();
    // A session-lifetime singleton (FR-047/T028) — only load if nothing has
    // been fetched yet; navigating back to this screen must not refetch.
    if (_cubit.state is OrdersLoading) {
      _cubit.load();
    }
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadFilterStations();
  }

  Future<void> _loadFilterStations() async {
    final result = await getIt<GetStations>()();
    if (!mounted) return;
    result.fold(
      (_) {},
      (stations) => setState(
        () => _filterStations = stations.map(_stationOptionOf).toList(),
      ),
    );
  }

  StationOption _stationOptionOf(Station station) {
    // Real data has one locale, not two — the platform never fabricates a
    // translation of a client's own free-text station name/address (same
    // reasoning as CreateOrderScreen's own copy of this mapping).
    final name = station.name?.isNotEmpty == true
        ? station.name!
        : station.addressText;
    return StationOption(
      id: station.id,
      name: name,
      nameEn: name,
      area: station.addressText,
      areaEn: station.addressText,
      isFavourite: station.isFavourite,
    );
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

  /// A pill spanning more than one backend status can't be expressed by the
  /// single-value `?status=` query the platform accepts (`OrderFilter`'s own
  /// doc comment). Rather than silently filter only the pages already
  /// scrolled to — which is exactly what FR-048d forbids — every remaining
  /// page is fetched first, so the filtered view always reflects the
  /// client's whole order set, not just what happened to be loaded.
  Future<void> _applyFilter(OrderFilter filter) async {
    setState(() => _selectedFilter = filter);
    if (filter.statuses.length <= 1) {
      await _cubit.setStatusFilter(
        filter.statuses.isEmpty ? null : filter.statuses.first,
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
    // No Directionality here: the screen follows the app locale, so it lays
    // out RTL in Arabic and LTR in English.
    return BlocProvider<OrdersCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.topBarInsetH,
                  vertical: AppSpacing.topBarInsetV,
                ),
                // No `onNotificationTap`: the bar's default opens the
                // notifications screen. The empty callback that used to sit
                // here swallowed the tap and left the bell dead on this
                // screen alone.
                child: AppTopBar(
                  showProfile: true,
                  notificationCount: context
                      .watch<NotificationsCubit>()
                      .state
                      .unreadBadgeCount,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _cubit.refresh,
                  child: BlocBuilder<OrdersCubit, OrdersState>(
                    builder: _buildBody,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, OrdersState state) {
    return switch (state) {
      OrdersLoading() => const Center(child: CircularProgressIndicator()),
      OrdersLoadFailure() => _ErrorState(onRetry: _cubit.load),
      OrdersLoaded(:final orders) => _buildList(context, orders, state),
    };
  }

  Widget _buildList(
    BuildContext context,
    List<Order> orders,
    OrdersLoaded state,
  ) {
    final filtered = orders.where(_selectedFilter.matches).toList();

    return ListView(
      controller: _scrollController,
      // Always scrollable so pull-to-refresh works even when the filtered
      // list is short enough to fit on screen.
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  OrdersListKeys.title.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  OrdersListKeys.count.tr(
                    namedArgs: {'count': '${filtered.length}'},
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
            // Pull-to-refresh (below) is the functional refresh gesture;
            // this icon was decorative before this screen read real data
            // too, and stays that way here — unchanged scope.
            // const AppActionIcon.reload(),
          ],
        ),
        const SizedBox(height: 16),
        SearchFilterBar(
          hintText: CommonKeys.searchByOrderCode.tr(),
          sortOptions: const [
            SortOption.newestFirst,
            SortOption.oldestFirst,
            SortOption.highestQuantity,
            SortOption.lowestQuantity,
          ],
          filterStations: _filterStations,
          showFuelTypeFilter: true,
          showDateFilter: true,
          filters: _filters,
          onFiltersChanged: (f) => setState(() => _filters = f),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colors.borderHairline),
          ),
          child: _pillRows(),
        ),
        const SizedBox(height: 24),
        if (filtered.isEmpty)
          const _EmptyState()
        else
          ...filtered.map((order) => _buildOrderCard(context, order)),
        if (state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (state.loadMoreFailed)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: TextButton(
                onPressed: _cubit.loadMore,
                child: Text(OrdersKeys.retry.tr()),
              ),
            ),
          ),
        const SizedBox(height: 100),
      ],
    );
  }

  /// [filter] is a fixed member of [OrderFilter], so identity — not the
  /// label — decides which pill is active. That already survives a locale
  /// switch since the enum itself doesn't change.
  static const _pillStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  static const _firstRowCount = 4;

  Widget _pillRows() {
    return Column(
      key: OrdersListScreen.pillsKey,
      children: [
        _pillRow(_filterOrder.take(_firstRowCount)),
        const SizedBox(height: 10),
        _pillRow(_filterOrder.skip(_firstRowCount)),
      ],
    );
  }

  Widget _pillRow(Iterable<OrderFilter> filters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [for (final filter in filters) _buildFilterPill(filter)],
    );
  }

  Widget _buildFilterPill(OrderFilter filter) {
    final isActive = _selectedFilter == filter;
    final isAll = filter == OrderFilter.all;

    final baseColor =
        _filterColors(context)[filter] ?? context.colors.textPrimary;
    final textColor = isActive && isAll ? Colors.white : baseColor;
    final bgColor = !isActive
        ? Colors.transparent
        : isAll
        ? context.colors.brandBlue
        : context.colors.surface2;

    return GestureDetector(
      onTap: () => _applyFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          filter.label,
          maxLines: 1,
          style: _pillStyle.copyWith(color: textColor),
        ),
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
      onTap: () => context.push(AppRoutes.clientOrderDetail(order.id)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          OrdersKeys.empty.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            OrdersKeys.loadFailed.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(OrdersKeys.retry.tr())),
        ],
      ),
    );
  }
}
