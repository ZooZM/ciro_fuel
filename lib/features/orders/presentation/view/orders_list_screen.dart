import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/search_filter_bar.dart';
import '../../../home/presentation/widgets/home_top_bar.dart';
import '../widgets/order_detail/mock_order_state.dart';
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
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFC),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: HomeTopBar(
                  notificationCount: 3,
                  onNotificationTap: () {},
                ),
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
                          children: const [
                            Text('كل الطلبات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF162155))),
                            Text('8 طلب إجمالاً', style: TextStyle(fontSize: 12, color: Color(0xFF8A93A6))),
                          ],
                        ),
                        // Reload icon button
                        SvgPicture.asset('assets/invoices/reload.svg', width: 44, height: 44),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SearchFilterBar(hintText: 'ابحث بكود الطلب'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F3F5)),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Column(
                          children: [
                            Row(
                              children: _filtersRow1.map((filter) => Expanded(child: _buildFilterPill(filter))).toList(),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(flex: 2, child: _buildFilterPill('قيد المراجعة')),
                                Expanded(flex: 1, child: _buildFilterPill('مؤكد')),
                                Expanded(flex: 1, child: _buildFilterPill('مدفوع')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ..._orders.map((order) => _buildOrderCard(context, order)),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill(String title) {
    final isActive = _selectedFilter == title;
    
    // Determine the base color of the text
    Color baseColor;
    if (title == 'قيد التوصيل') baseColor = const Color(0xFF1E5FFF);
    else if (title == 'تم التسليم') baseColor = const Color(0xFF12A150);
    else if (title == 'فشلت') baseColor = const Color(0xFFEF3F3F);
    else if (title == 'مدفوع') baseColor = const Color(0xFFFF5810);
    else if (title == 'الكل') baseColor = const Color(0xFF1E5FFF);
    else baseColor = const Color(0xFF162155); // Default dark color for others like 'مؤكد' and 'قيد المراجعة'

    // Text color becomes white ONLY for 'الكل' when active
    Color textColor = baseColor;
    if (isActive && title == 'الكل') {
      textColor = Colors.white;
    }

    // Background color: Blue for 'الكل', Light Grey for others when active
    Color bgColor = Colors.transparent;
    if (isActive) {
      if (title == 'الكل') bgColor = const Color(0xFF1E5FFF);
      else bgColor = const Color(0xFFE2E8F0);
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = title),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
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

  Widget _buildOrderCard(BuildContext context, _MockOrder order) {
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.clientOrderDetail(order.orderId),
        extra: order.mockState,
      ),
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
                      Text(
                        '${order.fuelType} · ${order.quantity}',
                        style: const TextStyle(color: Color(0xFF1E5FFF), fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                      Text(
                        order.orderId,
                        style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        order.statusText,
                        style: const TextStyle(color: Color(0xFF718096), fontSize: 10),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: order.statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
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
                                  width: constraints.maxWidth * order.statusProgress,
                                  decoration: BoxDecoration(
                                    color: order.statusColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.address,
                    style: const TextStyle(color: Color(0xFF1E5FFF), fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset('assets/Icons/date.svg', height: 12),
                      const SizedBox(width: 4),
                      Text(
                        order.date,
                        style: const TextStyle(color: Color(0xFF4A5568), fontSize: 10),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 12, color: Color(0xFF12A150)),
                      const SizedBox(width: 4),
                      Text(
                        order.time,
                        style: const TextStyle(color: Color(0xFF4A5568), fontSize: 10),
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

class _MockOrder {
  final String fuelType;
  final String quantity;
  final String orderId;
  final String statusText;
  final Color statusColor;
  final double statusProgress;
  final String address;
  final String time;
  final String date;
  final MockOrderState mockState;

  const _MockOrder({
    required this.fuelType,
    required this.quantity,
    required this.orderId,
    required this.statusText,
    required this.statusColor,
    required this.statusProgress,
    required this.address,
    required this.time,
    required this.date,
    required this.mockState,
  });
}
