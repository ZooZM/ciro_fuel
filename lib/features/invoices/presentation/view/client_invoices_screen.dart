import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class ClientInvoicesScreen extends StatefulWidget {
  const ClientInvoicesScreen({super.key});

  @override
  State<ClientInvoicesScreen> createState() => _ClientInvoicesScreenState();
}

class _ClientInvoicesScreenState extends State<ClientInvoicesScreen> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['الكل', 'مؤجلة', 'مدفوعة', 'فشلت'];

  final List<_InvoiceData> _allInvoices = const [
    _InvoiceData(status: _InvoiceStatus.paid, id: 'ORD-2024-256', location: 'طريق أنس بن مالك، حي الملقا', date: '9 صفر 1446', time: '06.30 صباحاً', amount: '600,120.00 ر.س'),
    _InvoiceData(status: _InvoiceStatus.pending, id: 'ORD-2024-257', location: 'طريق أنس بن مالك، حي الملقا', date: '9 صفر 1446', time: '06.30 صباحاً', amount: '600,120.00 ر.س'),
    _InvoiceData(status: _InvoiceStatus.paid, id: 'ORD-2024-258', location: 'طريق أنس بن مالك، حي الملقا', date: '9 صفر 1446', time: '06.30 صباحاً', amount: '600,120.00 ر.س'),
    _InvoiceData(status: _InvoiceStatus.pending, id: 'ORD-2024-259', location: 'طريق أنس بن مالك، حي الملقا', date: '9 صفر 1446', time: '06.30 صباحاً', amount: '600,120.00 ر.س'),
    _InvoiceData(status: _InvoiceStatus.failed, id: 'ORD-2024-260', location: 'طريق أنس بن مالك، حي الملقا', date: '9 صفر 1446', time: '06.30 صباحاً', amount: '600,120.00 ر.س'),
    _InvoiceData(status: _InvoiceStatus.paid, id: 'ORD-2024-261', location: 'طريق أنس بن مالك، حي الملقا', date: '9 صفر 1446', time: '06.30 صباحاً', amount: '600,120.00 ر.س'),
    _InvoiceData(status: _InvoiceStatus.failed, id: 'ORD-2024-262', location: 'طريق أنس بن مالك، حي الملقا', date: '9 صفر 1446', time: '06.30 صباحاً', amount: '600,120.00 ر.س'),
    _InvoiceData(status: _InvoiceStatus.pending, id: 'ORD-2024-263', location: 'طريق أنس بن مالك، حي الملقا', date: '9 صفر 1446', time: '06.30 صباحاً', amount: '600,120.00 ر.س'),
  ];

  List<_InvoiceData> get _filteredInvoices {
    switch (_selectedTabIndex) {
      case 1: // مؤجلة
        return _allInvoices.where((i) => i.status == _InvoiceStatus.pending).toList();
      case 2: // مدفوعة
        return _allInvoices.where((i) => i.status == _InvoiceStatus.paid).toList();
      case 3: // فشلت
        return _allInvoices.where((i) => i.status == _InvoiceStatus.failed).toList();
      default: // الكل
        return _allInvoices;
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoices = _filteredInvoices;
    return Scaffold(
      backgroundColor: AppColors.light.canvas,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    const SizedBox(height: 16),
                    _buildTitleRow(),
                    const SizedBox(height: 16),
                    _buildSearchAndFilter(),
                    const SizedBox(height: 16),
                    _buildTabs(),
                    const SizedBox(height: 16),
                    ...invoices.map((invoice) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildInvoiceCard(
                        status: invoice.status,
                        id: invoice.id,
                        location: invoice.location,
                        date: invoice.date,
                        time: invoice.time,
                        amount: invoice.amount,
                      ),
                    )),
                    if (invoices.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text(
                            'لا توجد فواتير',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.light.textTertiary,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header (LTR like the rest of the app) ──────────────────────────
  Widget _buildHeader() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.light.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppColors.shadowCard,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.slateCharcoal,
                size: 20,
              ),
            ),
            // Logo
            SvgPicture.asset('assets/Logo/appBar Logo.svg', height: 24),
            // Notification bell
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.light.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppColors.shadowCard,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none,
                    color: AppColors.slateCharcoal,
                    size: 24,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.errorRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Title row ──────────────────────────────────────────────────────
  Widget _buildTitleRow() {
    return Row(
      children: [
        // Title + subtitle (RTL start = right)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'كل الفواتير',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.slateCharcoal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '8 فاتورة إجمالاً',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.light.textSecondary,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Reload icon button
        SvgPicture.asset('assets/invoices/reload.svg', width: 32, height: 32),
        const SizedBox(width: 8),
        // Download icon button
        SvgPicture.asset('assets/invoices/download.svg', width: 32, height: 32),
      ],
    );
  }

  // ── Search + Filter ────────────────────────────────────────────────
  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        // Filter button (RTL start = right)
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.light.greenTint,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.forestGreen),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/invoices/filter.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Search field (RTL end = left, takes most space)
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.light.borderHairline),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                SvgPicture.asset(
                  'assets/invoices/search.svg',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: 'ابحث بكود الفاتورة',
                      hintStyle: TextStyle(
                        color: AppColors.light.textTertiary,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Tabs ────────────────────────────────────────────────────────────
  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = _selectedTabIndex == index;

          Color textColor;
          if (isSelected) {
            textColor = Colors.white;
          } else {
            switch (label) {
              case 'مؤجلة':
                textColor = AppColors.ignitionOrange;
                break;
              case 'مدفوعة':
                textColor = AppColors.forestGreen;
                break;
              case 'فشلت':
                textColor = AppColors.errorRed;
                break;
              default:
                textColor = AppColors.light.textSecondary;
            }
          }

          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              margin: EdgeInsets.only(left: index < _tabs.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.light.brandBlue : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.light.brandBlue
                      : AppColors.light.borderHairline,
                ),
              ),
              child: Text(
                label,
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
        color: Colors.white,
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
                              color: AppColors.light.textTertiary,
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
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.slateCharcoal,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/invoices/date.svg',
                                width: 14,
                                height: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.slateCharcoal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/invoices/hour.svg',
                                width: 14,
                                height: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.slateCharcoal,
                                ),
                              ),
                            ],
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
                        SvgPicture.asset(
                          'assets/invoices/download.svg',
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'الإجمالي',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.light.textTertiary,
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
