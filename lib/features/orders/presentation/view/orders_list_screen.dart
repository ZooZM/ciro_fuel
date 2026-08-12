import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/number_formatting.dart';
import '../../../../core/widgets/search_filter_bar.dart';
import '../../../../shared/entities/order.dart';
import '../../../home/presentation/widgets/home_top_bar.dart';
import '../constants/order_formatting.dart';
import '../constants/order_presentation.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';

/// The client's order history, served by `GET /orders` — already scoped to the
/// signed-in client by the backend, so no client-side ownership filtering is
/// needed here.
class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersCubit>(
      create: (_) => getIt<OrdersCubit>()..load(),
      child: const _OrdersListView(),
    );
  }
}

class _OrdersListView extends StatefulWidget {
  const _OrdersListView();

  @override
  State<_OrdersListView> createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<_OrdersListView> {
  OrderFilter _selectedFilter = OrderFilter.all;
  String _query = '';

  // The design lays the pills out in two rows.
  static const List<OrderFilter> _filtersRow1 = [
    OrderFilter.inDelivery,
    OrderFilter.delivered,
    OrderFilter.failed,
    OrderFilter.all,
  ];
  static const List<OrderFilter> _filtersRow2 = [
    OrderFilter.underReview,
    OrderFilter.confirmed,
    OrderFilter.awaitingPayment,
  ];

  /// Filter and search are applied to the loaded list rather than refetched:
  /// several pills span more than one status, which `?status=` cannot express
  /// in a single request.
  List<Order> _visible(List<Order> orders) {
    final query = _query.trim().toUpperCase();
    return orders.where((order) {
      if (!_selectedFilter.matches(order)) return false;
      if (query.isEmpty) return true;
      return order.id.toUpperCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFC),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                // TODO: the unread count is still the design's placeholder —
                // wiring it means depending on NotificationsCubit here.
                child: HomeTopBar(
                  notificationCount: 3,
                  onNotificationTap: () =>
                      context.push(AppRoutes.notifications),
                ),
              ),
              Expanded(
                child: BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) => switch (state) {
                    OrdersLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    OrdersLoadFailure() => _ErrorView(
                      onRetry: context.read<OrdersCubit>().load,
                    ),
                    OrdersLoaded(:final orders) => _buildList(context, orders),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Order> orders) {
    final visible = _visible(orders);

    return RefreshIndicator(
      onRefresh: context.read<OrdersCubit>().load,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    OrdersKeys.listTitle.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF162155),
                    ),
                  ),
                  Text(
                    OrdersKeys.totalCount.tr(
                      namedArgs: {
                        'count': NumberFormatting.thousands(orders.length),
                      },
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A93A6),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: context.read<OrdersCubit>().load,
                child: SvgPicture.asset(
                  'assets/invoices/reload.svg',
                  width: 44,
                  height: 44,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SearchFilterBar(
            hintText: 'ابحث بكود الطلب',
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F3F5)),
            ),
            child: Directionality(
              textDirection: ui.TextDirection.ltr,
              child: Column(
                children: [
                  Row(
                    children: _filtersRow1
                        .map((f) => Expanded(child: _buildFilterPill(f)))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ..._filtersRow2.map(
                        (f) => Expanded(child: _buildFilterPill(f)),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (visible.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Center(
                child: Text(
                  OrdersKeys.empty.tr(),
                  style: const TextStyle(
                    color: Color(0xFF8A93A6),
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ...visible.map((order) => _buildOrderCard(context, order)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFilterPill(OrderFilter filter) {
    final isActive = _selectedFilter == filter;

    final baseColor = switch (filter) {
      OrderFilter.inDelivery || OrderFilter.all => const Color(0xFF1E5FFF),
      OrderFilter.delivered => const Color(0xFF12A150),
      OrderFilter.failed => const Color(0xFFEF3F3F),
      OrderFilter.awaitingPayment => const Color(0xFFFF5810),
      _ => const Color(0xFF162155),
    };

    // Only the "all" pill inverts to white-on-blue when active.
    final isAll = filter == OrderFilter.all;
    final textColor = isActive && isAll ? Colors.white : baseColor;
    final bgColor = !isActive
        ? Colors.transparent
        : isAll
        ? const Color(0xFF1E5FFF)
        : const Color(0xFFE2E8F0);

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            filter.label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final statusColor = OrderPresentation.statusColor(order.status);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.clientOrderDetail(order.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F3F5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '${OrderPresentation.fuelLabel(order.fuelType)} · '
                          '${OrderFormatting.litres(order.quantityLiters)}',
                          style: const TextStyle(
                            color: Color(0xFF1E5FFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Text(
                        OrderPresentation.shortReference(order.id),
                        style: const TextStyle(
                          color: Color(0xFFA0AEC0),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        OrderPresentation.statusLabel(order.status),
                        style: const TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) => Stack(
                            children: [
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDF2F7),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              Container(
                                height: 6,
                                width:
                                    constraints.maxWidth *
                                    OrderPresentation.statusProgress(
                                      order.status,
                                    ),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    OrderPresentation.destinationLabel(order),
                    style: const TextStyle(
                      color: Color(0xFF1E5FFF),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(AppAssets.dateIcon, height: 12),
                      const SizedBox(width: 4),
                      Text(
                        OrderPresentation.date(order.statusChangedAt),
                        style: const TextStyle(
                          color: Color(0xFF4A5568),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: Color(0xFF12A150),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        OrderPresentation.time(order.statusChangedAt),
                        style: const TextStyle(
                          color: Color(0xFF4A5568),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SvgPicture.asset('assets/OrdersPage/fuel_pump.svg', height: 75),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            OrdersKeys.loadFailed.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF718096), fontSize: 14),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: Text(OrdersKeys.retry.tr())),
        ],
      ),
    );
  }
}
