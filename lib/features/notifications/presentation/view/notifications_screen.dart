import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/scroll_top_button.dart';
import '../../../../shared/enums/user_role.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../auth/presentation/cubit/session_state.dart';
import '../../domain/entities/app_notification.dart';
import '../constants/notification_presentation.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

const _kUnreadIcon = 'assets/Notification Page/gas gun (unread).svg';
const _kReadIcon = 'assets/Notification Page/gas  gun (read).svg';

const _kChipSelectedText = Color(0xFFF6F3EF);

const _kIconTile = 28.0;

/// All / unread — the one real, server-applied filter (`?unread=true`).
/// The design's order/invoice/system chips predate the real
/// [AppNotification] shape, which carries no such category, so they've
/// been dropped rather than sorted against data that doesn't distinguish
/// them (every [NotificationType] the app models today is order-related).
enum _Filter {
  all(NotificationKeys.filterAll),
  unread(NotificationKeys.filterUnread);

  const _Filter(this.labelKey);

  final String labelKey;
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsCubit _cubit;
  final _scrollController = ScrollController();
  _Filter _filter = _Filter.all;
  bool _showScrollTop = false;
  bool _markingAllRead = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<NotificationsCubit>();
    // A session-lifetime singleton (it also receives live pushes) — load
    // only if nothing has been fetched yet, same convention as OrdersCubit.
    if (_cubit.state is NotificationsLoading) {
      _cubit.load();
    }
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
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 300;
    if (_scrollController.position.pixels >= threshold) {
      _cubit.loadMore();
    }
  }

  Future<void> _markAllRead(List<AppNotification> visible) async {
    if (_markingAllRead) return;
    setState(() => _markingAllRead = true);
    for (final n in visible.where((n) => !n.isRead)) {
      await _cubit.markRead(n.id);
    }
    if (mounted) setState(() => _markingAllRead = false);
  }

  void _openNotification(AppNotification notification) {
    unawaited(_cubit.markRead(notification.id));
    final orderId = notification.orderId;
    if (orderId == null) return;
    final role = switch (context.read<SessionCubit>().state) {
      SessionAuthenticated(:final user) => user.role,
      _ => null,
    };
    if (role == null) return;
    context.push(
      role == UserRole.driver
          ? AppRoutes.driverOrderDetail(orderId)
          : AppRoutes.clientOrderDetail(orderId),
    );
  }

  /// Today and yesterday read as words; anything older uses the Hijri date
  /// the design shows (e.g. "9 صفر 1448").
  String _groupLabel(DateTime date) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfDate = DateTime(date.year, date.month, date.day);
    final daysAgo = startOfToday.difference(startOfDate).inDays;

    if (daysAgo <= 0) return CommonKeys.today.tr();
    if (daysAgo == 1) return CommonKeys.yesterday.tr();

    HijriCalendar.setLocal('ar');
    final hijri = HijriCalendar.fromDate(date);
    return '${hijri.hDay} ${hijri.getLongMonthName()} ${hijri.hYear}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) => switch (state) {
                    NotificationsLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    NotificationsFailureState() => _ErrorState(
                      onRetry: _cubit.load,
                    ),
                    NotificationsLoaded() => _buildLoaded(context, state),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, NotificationsLoaded state) {
    final visible = _filter == _Filter.unread
        ? state.notifications.where((n) => !n.isRead).toList()
        : state.notifications;

    final groups = <String, List<AppNotification>>{};
    for (final n in visible) {
      groups.putIfAbsent(_groupLabel(n.createdAt), () => []).add(n);
    }

    return Stack(
      children: [
        ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          children: [
            _buildFilterRow(visible),
            const SizedBox(height: 24),
            if (visible.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    OrdersKeys.empty.tr(),
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              for (final entry in groups.entries) ...[
                _buildGroup(entry.key, entry.value),
                const SizedBox(height: 24),
              ],
            if (state.isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (state.loadMoreFailed)
              Center(
                child: TextButton(
                  onPressed: _cubit.loadMore,
                  child: Text(OrdersKeys.retry.tr()),
                ),
              ),
          ],
        ),
        if (_showScrollTop)
          Positioned(
            right: ScrollTopButton.inset,
            bottom: ScrollTopButton.inset,
            child: ScrollTopButton(controller: _scrollController),
          ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
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
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 22,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          const AppLogo(),
          const SizedBox(width: 38, height: 38),
        ],
      ),
    );
  }

  Widget _buildFilterRow(List<AppNotification> visible) {
    return Row(
      children: [
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
          onTap: _markingAllRead ? null : () => _markAllRead(visible),
          child: Text(
            NotificationKeys.markAllRead.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _markingAllRead
                  ? context.colors.textTertiary
                  : context.colors.brandBlue,
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
          border: isSelected
              ? null
              : Border.all(color: context.colors.borderHairline, width: 0.8),
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

  Widget _buildGroup(String label, List<AppNotification> items) {
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

  Widget _buildCard(AppNotification n) {
    return GestureDetector(
      onTap: () => _openNotification(n),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: n.isRead ? context.colors.surface : context.colors.blueTint,
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
            SvgPicture.asset(
              n.isRead ? _kReadIcon : _kUnreadIcon,
              width: _kIconTile,
              height: _kIconTile,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      NotificationPresentation.message(n.type),
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (!n.isRead) ...[
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 4, left: 4),
                      decoration: BoxDecoration(
                        color: context.colors.brandBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            OrdersKeys.loadFailed.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: Text(OrdersKeys.retry.tr())),
        ],
      ),
    );
  }
}
