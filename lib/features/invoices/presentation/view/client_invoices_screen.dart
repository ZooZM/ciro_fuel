// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/date_time_row.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/search_filter_bar.dart';
import '../../../../shared/models/filter_selection.dart';
import '../../../../shared/models/station_option.dart';
import '../../../../core/widgets/app_action_icon.dart';

class ClientInvoicesScreen extends StatefulWidget {
  const ClientInvoicesScreen({super.key});

  @override
  State<ClientInvoicesScreen> createState() => _ClientInvoicesScreenState();
}

class _ClientInvoicesScreenState extends State<ClientInvoicesScreen> {
  int _selectedTabIndex = 0;

  /// What the filter sheet last returned.
  FilterSelection _filters = const FilterSelection();

  // Translation keys, in tab order — the switch below keys off the index,
  // and the tint off the key, so neither depends on the rendered label.
  static const List<String> _tabKeys = [
    InvoicesKeys.tabAll,
    InvoicesKeys.tabDeferred,
    InvoicesKeys.tabPaid,
    InvoicesKeys.tabFailed,
  ];

  /// The tint each tab's label reads in.
  ///
  /// These came from the brand foundation, which is tuned for a light ground:
  /// forest green measured 3.1:1 against the dark surface and error red 3.4:1,
  /// both under the 4.5:1 needed for body text. The palette's own accents are
  /// lightened for dark mode and land at 7.9:1 and 6.0:1, so the tints resolve
  /// per theme rather than being fixed.
  static Map<String, Color> _tabColors(BuildContext context) => {
    InvoicesKeys.tabDeferred: context.colors.brandOrange,
    InvoicesKeys.tabPaid: context.colors.brandGreen,
    InvoicesKeys.tabFailed: context.colors.brandRed,
  };

  final List<_InvoiceData> _allInvoices = const [
    _InvoiceData(
      status: _InvoiceStatus.paid,
      id: 'ORD-2024-256',
      location: 'طريق أنس بن مالك، حي الملقا',
      date: '9 صفر 1446',
      time: '06.30 صباحاً',
      amount: '600,120.00 ر.س',
    ),
    _InvoiceData(
      status: _InvoiceStatus.pending,
      id: 'ORD-2024-257',
      location: 'طريق أنس بن مالك، حي الملقا',
      date: '9 صفر 1446',
      time: '06.30 صباحاً',
      amount: '600,120.00 ر.س',
    ),
    _InvoiceData(
      status: _InvoiceStatus.paid,
      id: 'ORD-2024-258',
      location: 'طريق أنس بن مالك، حي الملقا',
      date: '9 صفر 1446',
      time: '06.30 صباحاً',
      amount: '600,120.00 ر.س',
    ),
    _InvoiceData(
      status: _InvoiceStatus.pending,
      id: 'ORD-2024-259',
      location: 'طريق أنس بن مالك، حي الملقا',
      date: '9 صفر 1446',
      time: '06.30 صباحاً',
      amount: '600,120.00 ر.س',
    ),
    _InvoiceData(
      status: _InvoiceStatus.failed,
      id: 'ORD-2024-260',
      location: 'طريق أنس بن مالك، حي الملقا',
      date: '9 صفر 1446',
      time: '06.30 صباحاً',
      amount: '600,120.00 ر.س',
    ),
    _InvoiceData(
      status: _InvoiceStatus.paid,
      id: 'ORD-2024-261',
      location: 'طريق أنس بن مالك، حي الملقا',
      date: '9 صفر 1446',
      time: '06.30 صباحاً',
      amount: '600,120.00 ر.س',
    ),
    _InvoiceData(
      status: _InvoiceStatus.failed,
      id: 'ORD-2024-262',
      location: 'طريق أنس بن مالك، حي الملقا',
      date: '9 صفر 1446',
      time: '06.30 صباحاً',
      amount: '600,120.00 ر.س',
    ),
    _InvoiceData(
      status: _InvoiceStatus.pending,
      id: 'ORD-2024-263',
      location: 'طريق أنس بن مالك، حي الملقا',
      date: '9 صفر 1446',
      time: '06.30 صباحاً',
      amount: '600,120.00 ر.س',
    ),
  ];

  List<_InvoiceData> get _filteredInvoices {
    final isAr = context.locale.languageCode == 'ar';
    final loc = isAr
        ? 'طريق أنس بن مالك، حي الملقا'
        : 'Anas Bin Malik Road, Al Malqa District';
    final dat = isAr ? '9 صفر 1446' : '9 Safar 1446';
    final tim = isAr ? '06.30 صباحاً' : '06.30 AM';
    final cur = CommonKeys.currencySymbol.tr();
    final amountText = '600,120.00 $cur';

    final updatedInvoices = _allInvoices
        .map(
          (i) => _InvoiceData(
            status: i.status,
            id: i.id,
            location: loc,
            date: dat,
            time: tim,
            amount: amountText,
          ),
        )
        .toList();

    switch (_selectedTabIndex) {
      case 1: // deferred
        return updatedInvoices
            .where((i) => i.status == _InvoiceStatus.pending)
            .toList();
      case 2: // paid
        return updatedInvoices
            .where((i) => i.status == _InvoiceStatus.paid)
            .toList();
      case 3: // failed
        return updatedInvoices
            .where((i) => i.status == _InvoiceStatus.failed)
            .toList();
      default: // all
        return updatedInvoices;
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoices = _filteredInvoices;
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            // No Directionality override here: the screen follows the app
            // locale, so it lays out RTL in Arabic and LTR in English. Pinning
            // it to RTL kept the tab row and the cards mirrored under English.
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 16),
                  _buildTitleRow(),
                  const SizedBox(height: 16),
                  SearchFilterBar(
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
                  const SizedBox(height: 16),
                  _buildTabs(),
                  const SizedBox(height: 16),
                  ...invoices.map(
                    (invoice) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildInvoiceCard(
                        status: invoice.status,
                        id: invoice.id,
                        location: invoice.location,
                        date: invoice.date,
                        time: invoice.time,
                        amount: invoice.amount,
                      ),
                    ),
                  ),
                  if (invoices.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          InvoicesKeys.empty.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            color: colors.textTertiary,
                          ),
                        ),
                      ),
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

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.topBarInsetH,
        vertical: AppSpacing.topBarInsetV,
      ),
      child: AppTopBar(
        showProfile: true,
        notificationCount: 3,
        // Optional: onNotificationTap if needed, otherwise it defaults to AppRoutes.notifications
      ),
    );
  }

  // ── Title row ──────────────────────────────────────────────────────
  Widget _buildTitleRow() {
    final colors = context.colors;
    return Row(
      children: [
        // Title + subtitle (RTL start = right)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              InvoicesKeys.title.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              InvoicesKeys.count.tr(namedArgs: {'count': '8'}),
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
          ],
        ),
        const Spacer(),
        // Reload icon button
        const AppActionIcon.reload(),
        const SizedBox(width: 8),
        // Download icon button
        const AppActionIcon.download(),
      ],
    );
  }

  // ── Tabs ────────────────────────────────────────────────────────────
  Widget _buildTabs() {
    final colors = context.colors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tabKeys.asMap().entries.map((entry) {
          final index = entry.key;
          final tabKey = entry.value;
          final isSelected = _selectedTabIndex == index;

          final textColor = isSelected
              ? Colors.white
              : (_tabColors(context)[tabKey] ?? colors.textSecondary);

          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              // Gap goes *after* each chip except the last, and it has to be
              // directional: a plain `left` margin leaves the final chip
              // (Failed) glued to its neighbour and flips wrong in RTL.
              margin: EdgeInsetsDirectional.only(
                end: index < _tabKeys.length - 1 ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? colors.brandBlue : colors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? colors.brandBlue : colors.borderHairline,
                ),
              ),
              child: Text(
                tabKey.tr(),
                style: TextStyle(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Invoice Card ───────────────────────────────────────────────────
  Widget _buildInvoiceCard({
    required _InvoiceStatus status,
    required String id,
    required String location,
    required String date,
    required String time,
    required String amount,
  }) {
    final colors = context.colors;
    Color statusColor;
    String statusIcon;
    switch (status) {
      case _InvoiceStatus.paid:
        statusColor = AppColors.forestGreen;
        statusIcon = 'assets/invoices/right_check.svg';
      case _InvoiceStatus.pending:
        statusColor = AppColors.ignitionOrange;
        statusIcon = 'assets/invoices/pending.svg';
      case _InvoiceStatus.failed:
        statusColor = AppColors.errorRed;
        statusIcon = 'assets/invoices/fail.svg';
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.shadowCard,
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Colored stripe on start (right in RTL)
            Container(width: 4, color: statusColor),
            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Status icon (right side in RTL)
                    SvgPicture.asset(statusIcon, width: 48, height: 48),
                    const SizedBox(width: 12),
                    // Details column (middle)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            id,
                            style: TextStyle(
                              color: colors.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: SvgPicture.asset(
                                  'assets/invoices/station.svg',
                                  width: 14,
                                  height: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.textPrimary,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Stacked rather than side by side, as the invoice
                          // card is drawn — but the same two glyphs as every
                          // other card, each against its own value.
                          DateTimeLabel.date(
                            label: date,
                            size: 14,
                            style: TextStyle(
                              fontSize: 11,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          DateTimeLabel.hour(
                            label: time,
                            size: 14,
                            style: TextStyle(
                              fontSize: 11,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Download + Amount column (left side in RTL)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppActionIcon.download(size: 28),
                        const SizedBox(height: 16),
                        Text(
                          CommonKeys.total.tr(),
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          amount,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _InvoiceStatus { paid, pending, failed }

class _InvoiceData {
  final _InvoiceStatus status;
  final String id;
  final String location;
  final String date;
  final String time;
  final String amount;

  const _InvoiceData({
    required this.status,
    required this.id,
    required this.location,
    required this.date,
    required this.time,
    required this.amount,
  });
}
