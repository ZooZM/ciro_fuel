import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/search_filter_bar.dart';

class ClientPaymentsScreen extends StatefulWidget {
  const ClientPaymentsScreen({super.key});

  @override
  State<ClientPaymentsScreen> createState() => _ClientPaymentsScreenState();
}

class _ClientPaymentsScreenState extends State<ClientPaymentsScreen> {
  static const List<_MockPayment> _payments = [
    _MockPayment(
      fuelType: 'بنزين 95',
      quantity: '20,000 لتر',
      orderId: 'ORD-2024-256',
      statusText: 'تم التأكيد',
      statusColor: Color(0xFF17A34A),
      progress: 1.0,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
    ),
    _MockPayment(
      fuelType: 'بنزين 95',
      quantity: '20,000 لتر',
      orderId: 'ORD-2024-256',
      statusText: 'الفاتورة معلقة',
      statusColor: Color(0xFFF97316),
      progress: 0.7,
      address: 'طريق أنس بن مالك، حي الملقا',
      time: '06.30 صباحاً',
      date: '9 صفر 1446',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildAppBar(),
              const SizedBox(height: 24),
              _buildTitleRow(),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SearchFilterBar(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _payments.length,
                  itemBuilder: (context, index) {
                    return _PaymentCard(payment: _payments[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/more/Image.png',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 44,
                height: 44,
                color: Colors.grey[200],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
            ),
          ),
          SvgPicture.asset(AppAssets.appBarLogo, height: 20),
          GestureDetector(
            onTap: () => context.push(AppRoutes.notifications),
            child: SvgPicture.asset(
              AppAssets.notificationBadgeIcon,
              width: 62,
              height: 63,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'كل الطلبات مستحقة الدفع',
                style: TextStyle(color: Color(0xFF0F1B2E), fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                '${_payments.length} طلب إجمالاً',
                style: const TextStyle(color: Color(0xFF8A93A6), fontSize: 12),
              ),
            ],
          ),
          SvgPicture.asset(
            AppAssets.reloadIcon,
            width: 32,
            height: 32,
          ),
        ],
      ),
    );
  }

}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});

  final _MockPayment payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsetsDirectional.only(start: 16, top: 16, bottom: 16, end: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl, // Enforces RTL for the entire card
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Right Side: All Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Fuel Type & Order ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${payment.fuelType} • ${payment.quantity}',
                          style: const TextStyle(color: Color(0xFF1E5FFF), fontSize: 13, fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    Text(
                      payment.orderId,
                      style: const TextStyle(color: Color(0xFF8A93A6), fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Row 2: Status Bar, Dot, and Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      payment.statusText,
                      style: const TextStyle(color: Color(0xFF8A93A6), fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: payment.statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildProgressBar(payment.progress, payment.statusColor),
                  ],
                ),
                const SizedBox(height: 10),
                // Row 3: Address
                Text(
                  payment.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF1E5FFF), fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                // Row 4: Date & Time
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.dateIcon,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      payment.date,
                      style: const TextStyle(color: Color(0xFF0F1B2E), fontSize: 12),
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time, color: Color(0xFF17A34A), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      payment.time,
                      style: const TextStyle(color: Color(0xFF0F1B2E), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Left Side: Fuel Pump
          SvgPicture.asset(
            'assets/OrdersPage/fuel_pump.svg',
            width: 50,
            height: 68,
            colorFilter: const ColorFilter.mode(Color(0xFF17A34A), BlendMode.srcIn),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, Color color) {
    return Container(
      height: 8,
      width: 100, // Fixed width matching the image proportions
      decoration: BoxDecoration(
        color: const Color(0xFFE7E9EF),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _MockPayment {
  const _MockPayment({
    required this.fuelType,
    required this.quantity,
    required this.orderId,
    required this.statusText,
    required this.statusColor,
    required this.progress,
    required this.address,
    required this.time,
    required this.date,
  });

  final String fuelType;
  final String quantity;
  final String orderId;
  final String statusText;
  final Color statusColor;
  final double progress;
  final String address;
  final String time;
  final String date;
}
