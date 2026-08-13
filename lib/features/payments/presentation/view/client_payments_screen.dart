// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/widgets/date_time_row.dart';
import '../../../../core/widgets/search_filter_bar.dart';
import '../../../../shared/models/filter_selection.dart';
import '../../../../shared/models/station_option.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_action_icon.dart';

class ClientPaymentsScreen extends StatefulWidget {
  const ClientPaymentsScreen({super.key});

  @override
  State<ClientPaymentsScreen> createState() => _ClientPaymentsScreenState();
}

class _ClientPaymentsScreenState extends State<ClientPaymentsScreen> {
  /// What the filter sheet last returned.
  FilterSelection _filters = const FilterSelection();

  List<_MockPayment> get _payments {
    final isAr = context.locale.languageCode == 'ar';
    final loc = isAr
        ? 'طريق أنس بن مالك، حي الملقا'
        : 'Anas Bin Malik Road, Al Malqa District';
    final dat = isAr ? '9 صفر 1446' : '9 Safar 1446';
    final tim = isAr ? '06.30 صباحاً' : '06.30 AM';
    return [
      _MockPayment(
        fuelType: FuelKeys.gasoline95.tr(),
        quantity: '20,000 ${CommonKeys.litre.tr()}',
        orderId: 'ORD-2024-256',
        statusText: OrdersListKeys.statusConfirmed.tr(),
        statusColor: context.colors.brandGreen,
        progress: 1.0,
        address: loc,
        time: tim,
        date: dat,
      ),
      _MockPayment(
        fuelType: FuelKeys.gasoline95.tr(),
        quantity: '20,000 ${CommonKeys.litre.tr()}',
        orderId: 'ORD-2024-256',
        statusText: OrdersListKeys.statusInvoicePending.tr(),
        statusColor: context.colors.brandOrange,
        progress: 0.7,
        address: loc,
        time: tim,
        date: dat,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The bar sits straight under the safe area, as on the orders and
            // invoices screens — the 16 that used to lead here pushed this
            // header lower than theirs, and its own inset already spaces it.
            _buildAppBar(),
            const SizedBox(height: 16),
            _buildTitleRow(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchFilterBar(
                // No fuel grade or quantity here: these lists are money,
                // not consignments. Confirm the exact sections with the
                // design before treating this as settled.
                sortOptions: const [
                  SortOption.newestFirst,
                  SortOption.oldestFirst,
                  SortOption.highestAmount,
                  SortOption.lowestAmount,
                ],
                filterStations: [
                  for (final s in kStationOptions)
                    if (s.isActive) s,
                ],
                showDateFilter: true,
                filters: _filters,
                onFiltersChanged: (f) => setState(() => _filters = f),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _payments.length,
                itemBuilder: (context, index) {
                  return _PaymentCard(payment: _payments[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    // Was a hand-rolled copy of [AppTopBar] whose bell came from
    // `notification_badge.svg` — a composite that wraps the tile, glyph and
    // count in a `<g filter="url(#…)">` drop shadow. flutter_svg does not
    // implement that filter and drops the whole group, so nothing drew; the
    // artwork also baked in a white tile and navy glyph, which would have
    // been wrong on a dark canvas either way. The shared bar draws the same
    // three pieces from the palette.
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.topBarInsetH,
        vertical: AppSpacing.topBarInsetV,
      ),
      child: AppTopBar(showProfile: true, notificationCount: 3),
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
              Text(
                PaymentsKeys.title.tr(),
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                PaymentsKeys.count.tr(
                  namedArgs: {'count': '${_payments.length}'},
                ),
                style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const AppActionIcon.paymentsReload(),
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
      padding: const EdgeInsetsDirectional.only(
        start: 16,
        top: 16,
        bottom: 16,
        end: 0,
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
                        style: TextStyle(
                          color: context.colors.brandBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      payment.orderId,
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 12,
                      ),
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
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 12,
                      ),
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
                    _buildProgressBar(
                      context,
                      payment.progress,
                      payment.statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Row 3: Address
                Text(
                  payment.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.colors.brandBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                // Row 4: Date & Time
                DateTimeRow(
                  date: payment.date,
                  time: payment.time,
                  iconSize: 16,
                  fontSize: 12,
                  textColor: context.colors.textPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Trailing: the fuel pump, drawn facing the card's start edge — how
          // it reads under Arabic, where it sits on the left. The row mirrors
          // under English and the artwork does not, so it is flipped there to
          // keep it facing into the card rather than off it.
          Transform.flip(
            flipX: Directionality.of(context) == TextDirection.ltr,
            child: SvgPicture.asset(
              'assets/OrdersPage/fuel_pump.svg',
              width: 50,
              height: 68,
              colorFilter: ColorFilter.mode(
                context.colors.brandGreen,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double progress, Color color) {
    return Container(
      height: 8,
      width: 100, // Fixed width matching the image proportions
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
