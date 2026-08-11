// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/search_filter_bar.dart';
import '../../../../shared/models/filter_selection.dart';
import '../../../../shared/models/station_option.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../widgets/order_detail/mock_order_state.dart';
import '../widgets/order_list_card.dart';
import 'order_detail_screen.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_action_icon.dart';

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
  // Filters are tracked by translation key, not by the label on screen, so
  // the selection survives a locale switch.
  String _selectedFilterKey = CommonKeys.all;

  static const List<String> _filterKeys = [
    CommonKeys.all,
    OrdersListKeys.filterFailed,
    OrdersListKeys.filterDelivered,
    OrdersListKeys.filterInDelivery,
    OrdersListKeys.filterPaid,
    OrdersListKeys.filterConfirmed,
    OrdersListKeys.filterPendingReview,
  ];

  /// What the filter sheet last returned.
  FilterSelection _filters = const FilterSelection();

  /// The tint each filter pill draws in. Anything absent falls back to the
  /// default navy.
  static Map<String, Color> _filterColors(BuildContext context) => {
    OrdersListKeys.filterInDelivery: context.colors.brandBlue,
    OrdersListKeys.filterDelivered: context.colors.brandGreen,
    OrdersListKeys.filterFailed: context.colors.brandRed,
    OrdersListKeys.filterPaid: context.colors.brandOrange,
    CommonKeys.all: context.colors.brandBlue,
  };

  // ── Static mock orders. `statusKey` is a translation key; the rest stands
  // in for API data and is left as-is.
  //
  // `statusProgress` only ever takes one of two values: a finished status
  // fills the bar, and one still in flight sits at the halfway mark. The
  // in-between figures it used to carry read as precise progress the app has
  // no way to know. ──
  static const double _statusDone = 1.0;
  static const double _statusUnderway = 0.5;

  static List<_MockOrder> _ordersFor(BuildContext context) => [
    _MockOrder(
      statusKey: OrdersListKeys.statusConfirmed,
      orderId: 'ORD-2024-256',
      statusColor: context.colors.brandGreen,
      statusProgress: _statusDone,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
      mockState: MockOrderState.confirmed,
    ),
    _MockOrder(
      statusKey: OrdersListKeys.statusInvoicePending,
      orderId: 'ORD-2024-256',
      statusColor: context.colors.brandOrange,
      statusProgress: _statusUnderway,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
      mockState: MockOrderState.waitingPayment,
    ),
    _MockOrder(
      statusKey: OrdersListKeys.statusFailed,
      orderId: 'ORD-2024-256',
      statusColor: context.colors.brandRed,
      statusProgress: _statusUnderway,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
      mockState: MockOrderState.failedPayment,
    ),
    _MockOrder(
      statusKey: OrdersListKeys.statusSettled,
      orderId: 'ORD-2024-256',
      statusColor: context.colors.brandGreen,
      statusProgress: _statusDone,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
      mockState: MockOrderState.paid,
    ),
    _MockOrder(
      statusKey: OrdersListKeys.statusInDelivery,
      orderId: 'ORD-2024-256',
      statusColor: context.colors.brandBlue,
      statusProgress: _statusUnderway,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
      mockState: MockOrderState.inTransit,
    ),
  ];
  List<_MockOrder> get _localizedOrders {
    final isAr = context.locale.languageCode == 'ar';
    final loc = isAr
        ? 'طريق أنس بن مالك، حي الملقا'
        : 'Anas Bin Malik Road, Al Malqa District';
    final dat = isAr ? '9 صفر 1446' : '9 Safar 1446';
    final tim = isAr ? '06.30 صباحاً' : '06.30 AM';

    return _ordersFor(context)
        .map(
          (o) => _MockOrder(
            orderId: o.orderId,
            statusKey: o.statusKey,
            statusColor: o.statusColor,
            statusProgress: o.statusProgress,
            address: loc,
            time: tim,
            date: dat,
            mockState: o.mockState,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // No Directionality here: the screen follows the app locale, so it lays
    // out RTL in Arabic and LTR in English.
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.topBarInsetH,
                vertical: AppSpacing.topBarInsetV,
              ),
              // No `onNotificationTap`: the bar's default opens the
              // notifications screen. The empty callback that used to sit here
              // swallowed the tap and left the bell dead on this screen alone.
              child: AppTopBar(showProfile: true, notificationCount: 3),
            ),
            Expanded(
              child: ListView(
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
                              namedArgs: {
                                'count': '${_localizedOrders.length}',
                              },
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      // Reload icon button, at the same 32 the payments and
                      // invoices screens draw theirs at.
                      const AppActionIcon.reload(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SearchFilterBar(
                    hintText: CommonKeys.searchByOrderCode.tr(),
                    // The full set from the design: orders are the only list
                    // with a quantity and a fuel grade to sort and filter on.
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
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.colors.borderHairline),
                    ),
                    // Every label is drawn at one type size. The pills used to
                    // wrap a `FittedBox`, which scaled each label by a
                    // different amount to fit its cell — so no two pills read
                    // the same. Ellipsis instead of scaling keeps the type
                    // consistent.
                    child: _pillRows(),
                  ),
                  const SizedBox(height: 24),
                  ..._localizedOrders.map(
                    (order) => _buildOrderCard(context, order),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [filterKey] is a translation key, so the pill's identity and its colour
  /// no longer depend on the label the active locale happens to render.
  // 12 with tight padding: at 13 the Arabic set needed three rows rather than
  // two. One size for every pill in both languages, and the set still lands in
  // two rows either way.
  static const _pillStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  /// How many pills the first row carries; the rest fall to the second.
  static const _firstRowCount = 4;

  /// The status pills, four on the first row and three on the second, in both
  /// languages.
  ///
  /// The split is fixed rather than flowed: a `Wrap` fits as many as the width
  /// allows, which put five on the first row under English and left the second
  /// row with two.
  ///
  /// Each pill takes exactly its own label's width. `Flexible` was the obvious
  /// way to keep a long one in bounds, but it hands every child an equal share
  /// of the row — 78dp on a 360dp screen — and cropped قيد التوصيل and "In
  /// delivery" against a row they otherwise clear by 50dp. Natural widths
  /// instead, with `order_filter_pills_test` measuring the set at a phone
  /// width in both languages so a longer label cannot quietly overrun it.
  ///
  /// `spaceEvenly`, not `spaceBetween`: the second row carries three pills
  /// against the first row's four, so pinning both to the edges left it with a
  /// gap half the card wide between the first two. Even gaps, including the
  /// ones at the ends, keep the two rows reading as one block.
  Widget _pillRows() {
    return Column(
      key: OrdersListScreen.pillsKey,
      children: [
        _pillRow(_filterKeys.take(_firstRowCount)),
        const SizedBox(height: 10),
        _pillRow(_filterKeys.skip(_firstRowCount)),
      ],
    );
  }

  Widget _pillRow(Iterable<String> filterKeys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [for (final filter in filterKeys) _buildFilterPill(filter)],
    );
  }

  Widget _buildFilterPill(String filterKey) {
    final isActive = _selectedFilterKey == filterKey;
    final isAll = filterKey == CommonKeys.all;

    // Filters without their own tint fall back to the default navy.
    final baseColor =
        _filterColors(context)[filterKey] ?? context.colors.textPrimary;

    // Only the "All" pill inverts to white on its filled blue background.
    final textColor = isActive && isAll ? Colors.white : baseColor;

    final bgColor = !isActive
        ? Colors.transparent
        : isAll
        ? context.colors.brandBlue
        : context.colors.surface2;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilterKey = filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          filterKey.tr(),
          maxLines: 1,
          style: _pillStyle.copyWith(color: textColor),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, _MockOrder order) {
    return OrderListCard(
      orderId: order.orderId,
      statusLabel: order.statusKey.tr(),
      statusColor: order.statusColor,
      statusProgress: order.statusProgress,
      address: order.address,
      date: order.date,
      time: order.time,
      onTap: () => context.push(
        AppRoutes.clientOrderDetail(order.orderId),
        extra: order.mockState,
      ),
    );
  }
}

class _MockOrder {
  final String orderId;

  /// Translation key, resolved where the card is drawn.
  final String statusKey;
  final Color statusColor;
  final double statusProgress;
  final String address;
  final String time;
  final String date;
  final MockOrderState mockState;

  const _MockOrder({
    required this.orderId,
    required this.statusKey,
    required this.statusColor,
    required this.statusProgress,
    required this.address,
    required this.time,
    required this.date,
    required this.mockState,
  });
}
