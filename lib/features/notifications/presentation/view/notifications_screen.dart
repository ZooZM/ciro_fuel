import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/scroll_top_button.dart';

// Each of these SVGs already draws its own 28x28 rounded tile (background +
// glyph), so they are rendered as plain images — wrapping one in a coloured
// Container would double the tile.
const _kOrderUnreadIcon = 'assets/Notification Page/gas gun (unread).svg';
const _kOrderReadIcon = 'assets/Notification Page/gas  gun (read).svg';
const _kInvoiceUnreadIcon = 'assets/Notification Page/invoice (unread).svg';
const _kInvoiceReadIcon = 'assets/Notification Page/incoice (read).svg';
const _kSystemIcon = 'assets/Notification Page/setting.svg';

// Design tokens (Figma: CIRO Fuel Mobile App / Notifications).
const _kChipSelectedText = Color(0xFFF6F3EF);

const _kIconTile = 28.0;

/// Which icon/tint a notification uses, and what the filter chips select on.
enum _Category { order, invoice, system }

enum _Filter {
  all(NotificationKeys.filterAll, null),
  orders(NotificationKeys.filterOrders, _Category.order),
  invoices(NotificationKeys.filterInvoices, _Category.invoice),
  system(NotificationKeys.filterSystem, _Category.system);

  const _Filter(this.labelKey, this.category);

  /// Translation key — `.tr()` where the chip is drawn.
  final String labelKey;
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

/// Dates are relative to "now" so the three groups (today / yesterday / an
/// older Hijri date) always land in the right bucket whenever the app is run.
List<_DemoNotification> _demoNotifications() {
  final now = DateTime.now();
  // `now` itself, not `now - 5 minutes`: only the bucket is read off this
  // date — the "5 minutes ago" the row shows is its own label — and backdating
  // it dropped these three into yesterday for the first five minutes after
  // midnight, leaving the screen with no "today" group at all.
  final today = now;
  final yesterday = now.subtract(const Duration(days: 1));
  final older = now.subtract(const Duration(days: 13));

  return [
    _DemoNotification(
      category: _Category.order,
      title: NotificationKeys.orderAcceptedTitle.tr(),
      body: NotificationKeys.orderBody.tr(namedArgs: {'id': 'ORD-2024-256'}),
      orderId: 'ORD-2024-256',
      date: today,
      timeLabel: NotificationKeys.minutesAgo.tr(),
    ),
    _DemoNotification(
      category: _Category.invoice,
      title: NotificationKeys.invoiceDueTitle.tr(),
      body: NotificationKeys.invoiceBody.tr(namedArgs: {'amount': '12,450'}),
      orderId: 'ORD-2024-256',
      date: today,
      timeLabel: NotificationKeys.minutesAgo.tr(),
    ),
    _DemoNotification(
      category: _Category.order,
      title: NotificationKeys.orderAcceptedTitle.tr(),
      body: NotificationKeys.orderBody.tr(namedArgs: {'id': 'ORD-2024-256'}),
      orderId: 'ORD-2024-256',
      date: today,
      timeLabel: NotificationKeys.minutesAgo.tr(),
    ),
    _DemoNotification(
      category: _Category.system,
      title: NotificationKeys.systemUpdateTitle.tr(),
      body: NotificationKeys.systemBody.tr(),
      date: yesterday,
      timeLabel: NotificationKeys.minutesAgo.tr(),
    ),
    _DemoNotification(
      category: _Category.order,
      title: NotificationKeys.orderAcceptedTitle.tr(),
      body: NotificationKeys.orderBody.tr(namedArgs: {'id': 'ORD-2024-256'}),
      orderId: 'ORD-2024-256',
      date: yesterday,
      timeLabel: NotificationKeys.minutesAgo.tr(),
    ),
    _DemoNotification(
      category: _Category.invoice,
      title: NotificationKeys.invoiceDueTitle.tr(),
      body: NotificationKeys.invoiceBody.tr(namedArgs: {'amount': '12,450'}),
      orderId: 'ORD-2024-256',
      date: yesterday,
      timeLabel: NotificationKeys.yesterdayTime.tr(),
      isRead: true,
    ),
    _DemoNotification(
      category: _Category.invoice,
      title: NotificationKeys.invoiceDueTitle.tr(),
      body: NotificationKeys.invoiceBody.tr(namedArgs: {'amount': '12,450'}),
      orderId: 'ORD-2024-256',
      date: older,
      timeLabel: NotificationKeys.yesterdayTime.tr(),
      isRead: true,
    ),
    _DemoNotification(
      category: _Category.order,
      title: NotificationKeys.orderAcceptedTitle.tr(),
      body: NotificationKeys.orderBody.tr(namedArgs: {'id': 'ORD-2024-256'}),
      orderId: 'ORD-2024-256',
      date: older,
      timeLabel: NotificationKeys.yesterdayTime.tr(),
      isRead: true,
    ),
    _DemoNotification(
      category: _Category.order,
      title: NotificationKeys.orderAcceptedTitle.tr(),
      body: NotificationKeys.orderBody.tr(namedArgs: {'id': 'ORD-2024-256'}),
      orderId: 'ORD-2024-256',
      date: older,
      timeLabel: NotificationKeys.yesterdayTime.tr(),
      isRead: true,
    ),
    _DemoNotification(
      category: _Category.system,
      title: NotificationKeys.systemUpdateTitle.tr(),
      body: NotificationKeys.systemBody.tr(),
      date: older,
      timeLabel: NotificationKeys.yesterdayTime.tr(),
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

    if (daysAgo <= 0) return CommonKeys.today.tr();
    if (daysAgo == 1) return CommonKeys.yesterday.tr();

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

    return Scaffold(
      backgroundColor: context.colors.canvas,
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
                  // The same button the terms screen floats, at the same inset
                  // — it replaces the bare SVG that used to sit here, which
                  // read as a different control and only took taps where its
                  // artwork actually painted. It still waits for the list to
                  // be scrolled before appearing.
                  if (_showScrollTop)
                    Positioned(
                      right: ScrollTopButton.inset,
                      bottom: ScrollTopButton.inset,
                      child: ScrollTopButton(controller: _scrollController),
                    ),
                ],
              ),
            ),
          ],
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
          // The back control leads the row, so it sits on the same side as
          // `AppTopBar`'s — left under English, right under Arabic — instead of
          // crossing the header when the locale changes.
          GestureDetector(
            // Always returns to the home page rather than popping, so the
            // arrow lands in the same place however the screen was reached.
            onTap: () => context.go(AppRoutes.clientHome),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              // `arrow_back_ios_new` is declared `matchTextDirection`, so
              // Flutter mirrors it for us — '<' under English, '>' under
              // Arabic. Picking the forward glyph by hand mirrored it twice.
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 22,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          const AppLogo(),
          // Balances the back button so the logo stays optically centred.
          const SizedBox(width: 38, height: 38),
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
          child: Text(
            NotificationKeys.markAllRead.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.colors.brandBlue,
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
          color: isSelected ? context.colors.brandBlue : context.colors.sunken,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? null : Border.all(color: context.colors.borderHairline, width: 0.8),
        ),
        child: Text(
          filter.labelKey.tr(),
          style: TextStyle(
            color: isSelected ? _kChipSelectedText : context.colors.textPrimary,
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
          style: TextStyle(
            color: context.colors.textTertiary,
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
                            style: TextStyle(
                              color: context.colors.textPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (n.orderId != null)
                            Text(
                              n.orderId!,
                              style: TextStyle(
                                color: context.colors.textTertiary,
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
                          style: TextStyle(
                            color: context.colors.textSecondary,
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
                  style: TextStyle(
                    color: context.colors.textSecondary,
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
    if (n.isRead) return context.colors.surface;
    return switch (n.category) {
      _Category.order => context.colors.blueTint,
      _Category.invoice => context.colors.greenTint,
      _Category.system => context.colors.surface2,
    };
  }

  Color _accentColor(_Category category) => switch (category) {
    _Category.order => context.colors.brandBlue,
    _Category.invoice => context.colors.brandGreen,
    _Category.system => context.colors.textTertiary,
  };

  String _iconFor(_DemoNotification n) => switch (n.category) {
    _Category.order => n.isRead ? _kOrderReadIcon : _kOrderUnreadIcon,
    _Category.invoice => n.isRead ? _kInvoiceReadIcon : _kInvoiceUnreadIcon,
    _Category.system => _kSystemIcon,
  };
}
