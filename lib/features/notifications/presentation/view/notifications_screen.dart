import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/router/app_routes.dart';

// Each of these SVGs already draws its own 28x28 rounded tile (background +
// glyph), so they are rendered as plain images — wrapping one in a coloured
// Container would double the tile.
const _kOrderUnreadIcon = 'assets/Notification Page/gas gun (unread).svg';
const _kOrderReadIcon = 'assets/Notification Page/gas  gun (read).svg';
const _kInvoiceUnreadIcon = 'assets/Notification Page/invoice (unread).svg';
const _kInvoiceReadIcon = 'assets/Notification Page/incoice (read).svg';
const _kSystemIcon = 'assets/Notification Page/setting.svg';
const _kScrollTopButton = 'assets/Notification Page/Button.svg';
const _kAppBarLogo = 'assets/HomePage/appBar Logo.svg';

// Design tokens (Figma: CIRO Fuel Mobile App / Notifications).
const _kCanvas = Color(0xFFF4F6FA);
const _kBlue = Color(0xFF1E5FFF);
const _kGreen = Color(0xFF12A150);
const _kBlueTint = Color(0xFFE7EEFF);
const _kGreenTint = Color(0xFFE4F7EC);
const _kChipSurface = Color(0xFFF0F2F7);
const _kSunken = Color(0xFFEAEDF3);
const _kHairline = Color(0xFFE7E9EF);
const _kTextPrimary = Color(0xFF162155);
const _kTextSecondary = Color(0xFF6B7280);
const _kTextTertiary = Color(0xFF9CA3AF);
const _kOrderIdText = Color(0xFF9BA1AE);
const _kChipText = Color(0xFF232324);
const _kChipSelectedText = Color(0xFFF6F3EF);

const _kIconTile = 28.0;
const _kScrollTopSize = 32.0;

/// Which icon/tint a notification uses, and what the filter chips select on.
enum _Category { order, invoice, system }

enum _Filter {
  all('الكل', null),
  orders('الطلبات', _Category.order),
  invoices('الفواتير', _Category.invoice),
  system('النظام', _Category.system);

  const _Filter(this.label, this.category);

  final String label;
  final _Category? category;
}

/// A mock notification. The real [AppNotification] entity carries only
/// `type`/`orderId`/`createdAt`, with no title or body, so this screen runs on
/// local demo data until the backend supplies that copy.
class _DemoNotification {
  const _DemoNotification({
    required this.category,
    required this.title,
    required this.body,
    required this.date,
    required this.timeLabel,
    this.orderId,
    this.isRead = false,
  });

  final _Category category;
  final String title;
  final String body;
  final DateTime date;
  final String timeLabel;
  final String? orderId;
  final bool isRead;

  _DemoNotification asRead() => _DemoNotification(
    category: category,
    title: title,
    body: body,
    date: date,
    timeLabel: timeLabel,
    orderId: orderId,
    isRead: true,
  );
}

const _kOrderBody = 'تم قبول طلب الوقود ORD-2024-256 وجاري تحضير الشحنة الآن.';
const _kInvoiceBody =
    'لديك فاتورة مستحقة الدفع بقيمة 12,450 ريال، يرجى السداد قبل نهاية الشهر.';
const _kSystemBody =
    'تم تحديث التطبيق إلى الإصدار الجديد مع تحسينات في الأداء والاستقرار.';

/// Dates are relative to "now" so the three groups (اليوم / أمس / an older
/// Hijri date) always land in the right bucket whenever the app is run.
List<_DemoNotification> _demoNotifications() {
  final now = DateTime.now();
  final today = now.subtract(const Duration(minutes: 5));
  final yesterday = now.subtract(const Duration(days: 1));
  final older = now.subtract(const Duration(days: 13));

  return [
    _DemoNotification(
      category: _Category.order,
      title: 'تم قبول طلبك',
      body: _kOrderBody,
      orderId: 'ORD-2024-256',
      date: today,
      timeLabel: 'قبل 5 دقائق',
    ),
    _DemoNotification(
      category: _Category.invoice,
      title: 'فاتورة مستحقة',
      body: _kInvoiceBody,
      orderId: 'ORD-2024-256',
      date: today,
      timeLabel: 'قبل 5 دقائق',
    ),
    _DemoNotification(
      category: _Category.order,
      title: 'تم قبول طلبك',
      body: _kOrderBody,
      orderId: 'ORD-2024-256',
      date: today,
      timeLabel: 'قبل 5 دقائق',
    ),
    _DemoNotification(
      category: _Category.system,
      title: 'تحديث النظام',
      body: _kSystemBody,
      date: yesterday,
      timeLabel: 'قبل 5 دقائق',
    ),
    _DemoNotification(
      category: _Category.order,
      title: 'تم قبول طلبك',
      body: _kOrderBody,
      orderId: 'ORD-2024-256',
      date: yesterday,
      timeLabel: 'قبل 5 دقائق',
    ),
    _DemoNotification(
      category: _Category.invoice,
      title: 'فاتورة مستحقة',
      body: _kInvoiceBody,
      orderId: 'ORD-2024-256',
      date: yesterday,
      timeLabel: 'أمس, 09:35 ص',
      isRead: true,
    ),
    _DemoNotification(
      category: _Category.invoice,
      title: 'فاتورة مستحقة',
      body: _kInvoiceBody,
      orderId: 'ORD-2024-256',
      date: older,
      timeLabel: 'أمس, 09:35 ص',
      isRead: true,
    ),
    _DemoNotification(
      category: _Category.order,
      title: 'تم قبول طلبك',
      body: _kOrderBody,
      orderId: 'ORD-2024-256',
      date: older,
      timeLabel: 'أمس, 09:35 ص',
      isRead: true,
    ),
    _DemoNotification(
      category: _Category.order,
      title: 'تم قبول طلبك',
      body: _kOrderBody,
      orderId: 'ORD-2024-256',
      date: older,
      timeLabel: 'أمس, 09:35 ص',
      isRead: true,
    ),
    _DemoNotification(
      category: _Category.system,
      title: 'تحديث النظام',
      body: _kSystemBody,
      date: older,
      timeLabel: 'أمس, 09:35 ص',
      isRead: true,
    ),
  ];
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _scrollController = ScrollController();
  List<_DemoNotification> _items = _demoNotifications();
  _Filter _filter = _Filter.all;
  bool _showScrollTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollController.offset > 120;
    if (show != _showScrollTop) setState(() => _showScrollTop = show);
  }

  void _markAllRead() {
    setState(() => _items = [for (final n in _items) n.asRead()]);
  }

  List<_DemoNotification> get _visible {
    final category = _filter.category;
    if (category == null) return _items;
    return [
      for (final n in _items)
        if (n.category == category) n,
    ];
  }

  /// Today and yesterday read as words; anything older uses the Hijri date the
  /// design shows (e.g. "9 صفر 1448").
  String _groupLabel(DateTime date) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfDate = DateTime(date.year, date.month, date.day);
    final daysAgo = startOfToday.difference(startOfDate).inDays;

    if (daysAgo <= 0) return 'اليوم';
    if (daysAgo == 1) return 'أمس';

    HijriCalendar.setLocal('ar');
    final hijri = HijriCalendar.fromDate(date);
    // Built by hand rather than via toFormat(), which renders Arabic-Indic
    // digits (٩) where the design uses Latin ones (9).
    return '${hijri.hDay} ${hijri.getLongMonthName()} ${hijri.hYear}';
  }

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<_DemoNotification>>{};
    for (final n in _visible) {
      groups.putIfAbsent(_groupLabel(n.date), () => []).add(n);
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _kCanvas,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: Stack(
                  children: [
                    ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      children: [
                        _buildFilterRow(),
                        const SizedBox(height: 24),
                        for (final entry in groups.entries) ...[
                          _buildGroup(entry.key, entry.value),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                    if (_showScrollTop)
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: GestureDetector(
                          onTap: () => _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          ),
                          child: SvgPicture.asset(
                            _kScrollTopButton,
                            width: _kScrollTopSize,
                            height: _kScrollTopSize,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Balances the back button so the logo stays optically centred.
          const SizedBox(width: 38, height: 38),
          SvgPicture.asset(_kAppBarLogo, height: 20),
          GestureDetector(
            // Always returns to the home page rather than popping, so the
            // arrow lands in the same place however the screen was reached.
            onTap: () => context.go(AppRoutes.clientHome),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              // Mirrored under RTL (matchTextDirection), so this is what
              // actually draws the '<' the design shows.
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 22,
                color: _kTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        // Chips lead, so الكل sits right-most in RTL. Expanded + a horizontal
        // scroll keeps the row intact at a larger system text scale, where the
        // four labels plus the action would otherwise overflow the line.
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in _Filter.values) ...[
                  if (filter != _Filter.values.first) const SizedBox(width: 8),
                  _buildChip(filter),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _markAllRead,
          child: const Text(
            'تحديد الكل كمقروء',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _kBlue,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(_Filter filter) {
    final isSelected = _filter == filter;
    return GestureDetector(
      onTap: () => setState(() => _filter = filter),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 3),
        decoration: BoxDecoration(
          color: isSelected ? _kBlue : _kSunken,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? null : Border.all(color: _kHairline, width: 0.8),
        ),
        child: Text(
          filter.label,
          style: TextStyle(
            color: isSelected ? _kChipSelectedText : _kChipText,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildGroup(String label, List<_DemoNotification> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _kTextTertiary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        for (final n in items) ...[
          if (n != items.first) const SizedBox(height: 8),
          _buildCard(n),
        ],
      ],
    );
  }

  Widget _buildCard(_DemoNotification n) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _cardColor(n),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(_iconFor(n), width: _kIconTile, height: _kIconTile),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n.title,
                            style: const TextStyle(
                              color: _kTextPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (n.orderId != null)
                            Text(
                              n.orderId!,
                              style: const TextStyle(
                                color: _kOrderIdText,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Dot first so it renders to the right of the timestamp.
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!n.isRead) ...[
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _accentColor(n.category),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          n.timeLabel,
                          style: const TextStyle(
                            color: _kTextSecondary,
                            fontSize: 6,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  n.body,
                  style: const TextStyle(
                    color: _kTextSecondary,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _cardColor(_DemoNotification n) {
    if (n.isRead) return Colors.white;
    return switch (n.category) {
      _Category.order => _kBlueTint,
      _Category.invoice => _kGreenTint,
      _Category.system => _kChipSurface,
    };
  }

  Color _accentColor(_Category category) => switch (category) {
    _Category.order => _kBlue,
    _Category.invoice => _kGreen,
    _Category.system => _kTextTertiary,
  };

  String _iconFor(_DemoNotification n) => switch (n.category) {
    _Category.order => n.isRead ? _kOrderReadIcon : _kOrderUnreadIcon,
    _Category.invoice => n.isRead ? _kInvoiceReadIcon : _kInvoiceUnreadIcon,
    _Category.system => _kSystemIcon,
  };
}
