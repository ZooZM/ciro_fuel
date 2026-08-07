import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../home/presentation/widgets/current_station_card.dart';
import '../../../home/presentation/widgets/new_request_button.dart';
import '../../../home/presentation/widgets/current_order_card.dart';
import '../../../home/presentation/widgets/quick_glance_row.dart';
import '../../../home/presentation/widgets/section_header.dart';

const _kAppBarLogo = 'assets/Logo/appBar Logo.svg';
const _kProfileImage = 'assets/more/Image.png';

const _kStationIcon = 'assets/HomePage/green station.svg';
const _kCardDateIcon = 'assets/Icons/date.svg';
const _kHourIcon = 'assets/HomePage/flow/hour.svg';

const _kNavy = Color(0xFF0F1B2E);
const _kGreen = Color(0xFF17A34A);
const _kGrey = Color(0xFF8A93A6);
const _kBackground = Color(0xFFF5F6F8);
const _kBlue = Color(0xFF1E5FFF);
const _kOrange = Color(0xFFF97316);

class ClientStationsScreen extends StatefulWidget {
  const ClientStationsScreen({super.key});

  @override
  State<ClientStationsScreen> createState() => _ClientStationsScreenState();
}

class _ClientStationsScreenState extends State<ClientStationsScreen> {
  static const _currentOrder = CurrentOrderSummary(
    fuelType: 'بنزين 95',
    quantity: '20,000 لتر',
    statusLabel: 'قيد التوصيل',
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
        backgroundColor: _kBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 16.0,
              bottom: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAppBar(),
                const SizedBox(height: 24),
                CurrentStationCard(
                  name: 'محطة الرحاب',
                  address: 'جدة - طريق مكة القديم - حي البوادي',
                  onChangeStation: () {},
                ),
                const SizedBox(height: 24),
                NewRequestButton(
                  onPressed: () => context.push(AppRoutes.clientCreateOrder),
                ),
                const SizedBox(height: 32),
                const SectionHeader('طلبك الحالي'),
                const SizedBox(height: 12),
                CurrentOrderCard(
                  order: _currentOrder,
                  onTrackOrder: () {},
                  onContactDriver: () {},
                ),
                const SizedBox(height: 32),
                const SectionHeader('أخر طلب'),
                const SizedBox(height: 12),
                _buildLastOrderCard(),
                const SizedBox(height: 32),
                const SectionHeader('نظرة سريعة'),
                const SizedBox(height: 12),
                const QuickGlanceRow(stats: defaultOrderCountStats),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Profile on the right, logo centred, and a way back on the left.
  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipOval(
          child: Image.asset(
            _kProfileImage,
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
        SvgPicture.asset(_kAppBarLogo, height: 20),
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  offset: Offset(0, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            // The chevron is a matchTextDirection icon, so on this RTL page it
            // would mirror and point right without this.
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: Icon(Icons.arrow_back_ios_new, size: 20, color: _kNavy),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// The most recent completed order, laid out like the payments screen's card:
  /// the text column on the right, the station artwork on the left.
  Widget _buildLastOrderCard() {
    return Container(
      padding: const EdgeInsetsDirectional.only(
        start: 16,
        top: 16,
        bottom: 16,
        // The artwork keeps a margin off the card's left edge rather than
        // bleeding into it.
        end: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fuel type + order id
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'بنزين 95 • 20,000 لتر',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _kBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'ORD-2024-256',
                      style: TextStyle(color: _kGrey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Bar first so it sits on the right under the fuel line, with
                // the dot and then the label trailing off to the left. The
                // label is [Flexible] because 'تم التسليم (الفاتورة مؤجلة)' is
                // long enough to push the fixed-width bar off the card on
                // narrower screens.
                Row(
                  children: [
                    _buildProgressBar(1.0, _kOrange),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: _kOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: Text(
                        'تم التسليم (الفاتورة مؤجلة)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _kGrey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'طريق أنس بن مالك، حي الملقا',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _kBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SvgPicture.asset(_kCardDateIcon, width: 16, height: 16),
                    const SizedBox(width: 4),
                    const Text(
                      '9 صفر 1446',
                      style: TextStyle(color: _kNavy, fontSize: 12),
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time, color: _kGreen, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      '06.30 صباحاً',
                      style: TextStyle(color: _kNavy, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SvgPicture.asset(
            _kStationIcon,
            width: 72,
            height: 72,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress, Color color) {
    return Container(
      height: 8,
      width: 80,
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
