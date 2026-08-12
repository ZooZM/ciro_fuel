// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../home/presentation/widgets/current_order_card.dart';
import '../../../home/presentation/widgets/current_station_card.dart';
import '../../../home/presentation/widgets/new_request_button.dart';
import '../../../home/presentation/widgets/quick_glance_row.dart';
import '../../../home/presentation/widgets/section_header.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/date_time_row.dart';

const _kProfileImage = 'assets/more/Image.png';

const _kStationIcon = 'assets/HomePage/green station.svg';

class ClientStationsScreen extends StatefulWidget {
  const ClientStationsScreen({super.key});

  @override
  State<ClientStationsScreen> createState() => _ClientStationsScreenState();
}

class _ClientStationsScreenState extends State<ClientStationsScreen> {
  // A getter rather than a `const` field: the translated parts have to be
  // resolved per build so they follow a locale switch.
  static CurrentOrderSummary get _currentOrder => CurrentOrderSummary(
    fuelType: FuelKeys.gasoline95.tr(),
    quantity: '20,000 ${CommonKeys.litre.tr()}',
    statusLabel: OrdersListKeys.statusInDelivery.tr(),
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
    return Scaffold(
      backgroundColor: context.colors.canvas,
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
                // This is the stations screen: nothing to point a chevron at.
                headsWithStar: true,
              ),
              const SizedBox(height: 24),
              NewRequestButton(
                onPressed: () => context.push(AppRoutes.clientCreateOrder),
              ),
              const SizedBox(height: 32),
              SectionHeader(StationsKeys.currentOrder.tr()),
              const SizedBox(height: 12),
              CurrentOrderCard(
                order: _currentOrder,
                onTrackOrder: () {},
                onContactDriver: () {},
              ),
              const SizedBox(height: 32),
              SectionHeader(StationsKeys.lastOrder.tr()),
              const SizedBox(height: 12),
              _buildLastOrderCard(),
              const SizedBox(height: 32),
              SectionHeader(StationsKeys.quickGlance.tr()),
              const SizedBox(height: 12),
              QuickGlanceRow(stats: defaultOrderCountStats(context)),
            ],
          ),
        ),
      ),
    );
  }

  /// Back on the leading edge, logo centred, profile on the trailing one.
  ///
  /// The back button leads, as it does in [AppTopBar] and on every other
  /// screen: it used to be the row's last child, which put it on the left in
  /// Arabic and — once the row mirrored — on the right under English, where a
  /// back button never sits.
  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  offset: Offset(0, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 2.0),
                // No manual swap: arrow_back_ios_new is declared
                // `matchTextDirection`, so Flutter mirrors it already.
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ),
        ),
        const AppLogo(),
        GestureDetector(
          onTap: () => context.push(AppRoutes.clientProfile),
          child: ClipOval(
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
        color: context.colors.surface,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${FuelKeys.gasoline95.tr()} • 20,000 ${CommonKeys.litre.tr()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.colors.brandBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ORD-2024-256',
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Bar first so it sits on the right under the fuel line, with
                // the dot and then the label trailing off to the left. The
                // label is [Flexible] because StationsKeys.deliveredDeferredInvoice.tr() is
                // long enough to push the fixed-width bar off the card on
                // narrower screens.
                Row(
                  children: [
                    _buildProgressBar(1.0, context.colors.brandOrange),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: context.colors.brandOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        StationsKeys.deliveredDeferredInvoice.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  context.locale.languageCode == 'ar'
                      ? 'طريق أنس بن مالك، حي الملقا'
                      : 'Anas Bin Malik Road, Al Malqa District',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.colors.brandBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                DateTimeRow(
                  date: context.locale.languageCode == 'ar'
                      ? '9 صفر 1446'
                      : '9 Safar 1446',
                  time: context.locale.languageCode == 'ar'
                      ? '06.30 صباحاً'
                      : '06.30 AM',
                  iconSize: 16,
                  fontSize: 12,
                  textColor: context.colors.textPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SvgPicture.asset(_kStationIcon, width: 72, height: 72),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress, Color color) {
    return Container(
      height: 8,
      width: 80,
      decoration: BoxDecoration(
        color: context.colors.borderHairline,
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
