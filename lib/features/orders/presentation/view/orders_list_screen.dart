import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'order_detail_screen.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  String _selectedFilter = 'الكل';

  final List<String> _filtersRow1 = ['قيد التوصيل', 'تم التسليم', 'فشلت', 'الكل'];
  final List<String> _filtersRow2 = ['قيد المراجعة', 'مؤكد', 'مدفوع'];

  // ── Static mock orders ──
  static const List<_MockOrder> _orders = [
    _MockOrder(
      fuelType: 'بنزين 95',
      quantity: '20,000 لتر',
      orderId: 'ORD-2024-256',
      statusText: 'تم التأكيد',
      statusColor: Color(0xFF12A150),
      statusProgress: 1.0,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
      mockState: MockOrderState.confirmed,
    ),
    _MockOrder(
      fuelType: 'بنزين 95',
      quantity: '20,000 لتر',
      orderId: 'ORD-2024-256',
      statusText: 'الفاتورة معلقة',
      statusColor: Color(0xFFF97316),
      statusProgress: 0.6,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
      mockState: MockOrderState.waitingPayment,
    ),
    _MockOrder(
      fuelType: 'بنزين 95',
      quantity: '20,000 لتر',
      orderId: 'ORD-2024-256',
      statusText: 'فشلت',
      statusColor: Color(0xFFEF3F3F),
      statusProgress: 0.35,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
      mockState: MockOrderState.failedPayment,
    ),
    _MockOrder(
      fuelType: 'بنزين 95',
      quantity: '20,000 لتر',
      orderId: 'ORD-2024-256',
      statusText: 'تم السداد',
      statusColor: Color(0xFF12A150),
      statusProgress: 1.0,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
      mockState: MockOrderState.paid,
    ),
    _MockOrder(
      fuelType: 'بنزين 95',
      quantity: '20,000 لتر',
      orderId: 'ORD-2024-256',
      statusText: 'قيد التوصيل',
      statusColor: Color(0xFF1E5FFF),
      statusProgress: 0.75,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
      mockState: MockOrderState.inTransit,
    ),
    _MockOrder(
      fuelType: 'بنزين 95',
      quantity: '20,000 لتر',
      orderId: 'ORD-2024-256',
      statusText: 'فشلت',
      statusColor: Color(0xFFEF3F3F),
      statusProgress: 0.35,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
      mockState: MockOrderState.canceled,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('Orders')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.clientCreateOrder),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) => switch (state) {
            OrdersLoading() => const Center(child: CircularProgressIndicator()),
            OrdersLoadFailure() => Center(
              child: TextButton(
                onPressed: () => context.read<OrdersCubit>().load(),
                child: const Text('Could not load orders. Tap to retry.'),
              ),
            ),
            OrdersLoaded(:final orders) when orders.isEmpty => const Center(child: Text('No orders yet')),
            OrdersLoaded(:final orders) => RefreshIndicator(
              onRefresh: () => context.read<OrdersCubit>().load(),
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text(
                      '${order.quantityLiters} L · ${order.fuelType.name}',
                    ),
                    subtitle: Text(order.status.wire),
                    onTap: () => context.push(AppRoutes.clientOrderDetail(order.id)),
                  );
                },
              ),
            ),
          },
        ),
      ),
    );
  }
}
