import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../notifications/domain/entities/app_notification.dart';
import '../../../notifications/presentation/constants/notification_presentation.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';

/// feature 013 US3: the driver's real notification centre.
///
/// Was a `StatelessWidget` with hardcoded rows (`ORD-2024-256`, "5 mins ago")
/// and three category tabs. It now renders the app-wide [NotificationsCubit]
/// — the same instance the nav-bar badge reads — with a re-skin of the
/// client's `notifications_screen.dart`, not a second notifications stack
/// (debt #2). The category tabs are gone: a DRIVER only ever receives
/// `ORDER_ASSIGNED` and `DRIVER_STOP_DETECTED`, both order-related, so
/// "System" could never match and "Orders" equalled "All" (research R7). The
/// All / Unread filter replaces them, the same choice the client screen made.
enum _Filter { all, unread }

class DriverNotificationsScreen extends StatefulWidget {
  const DriverNotificationsScreen({super.key});

  @override
  State<DriverNotificationsScreen> createState() =>
      _DriverNotificationsScreenState();
}

class _DriverNotificationsScreenState extends State<DriverNotificationsScreen> {
  late final NotificationsCubit _cubit;
  final _scrollController = ScrollController();
  _Filter _filter = _Filter.all;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<NotificationsCubit>();
    // A session-lifetime singleton (it also receives live pushes) — load only
    // if nothing has been fetched yet, same convention as the client screen.
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
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 300;
    if (_scrollController.position.pixels >= threshold) {
      _cubit.loadMore();
    }
  }

  void _open(AppNotification n) {
    unawaited(_cubit.markRead(n.id));
    final orderId = n.orderId;
    if (orderId == null) return;
    // A notification whose order the driver no longer holds must not land on
    // an error screen — the detail route handles its own not-found state
    // (FR-030).
    context.push(AppRoutes.driverOrderDetail(orderId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: SafeArea(
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) => switch (state) {
              NotificationsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              NotificationsFailureState() => _ErrorState(onRetry: _cubit.load),
              NotificationsLoaded() => _buildLoaded(context, state),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, NotificationsLoaded state) {
    final visible = _filter == _Filter.unread
        ? state.notifications.where((n) => !n.isRead).toList()
        : state.notifications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            48,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: state.unreadCount == 0 ? null : _cubit.markAllRead,
                child: Text(
                  NotificationKeys.markAllRead.tr(),
                  style: TextStyle(
                    color: state.unreadCount == 0
                        ? context.colors.textTertiary
                        : context.colors.brandBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: [
                  _FilterChip(
                    label: NotificationKeys.filterAll.tr(),
                    selected: _filter == _Filter.all,
                    onTap: () => setState(() => _filter = _Filter.all),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: NotificationKeys.filterUnread.tr(),
                    selected: _filter == _Filter.unread,
                    onTap: () => setState(() => _filter = _Filter.unread),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? Center(
                  child: Text(
                    OrdersKeys.empty.tr(),
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                )
              : ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    120,
                  ),
                  itemCount: visible.length + (state.isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    if (i >= visible.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return _NotificationRow(
                      notification: visible[i],
                      onTap: () => _open(visible[i]),
                    );
                  },
                ),
        ),
        if (state.loadMoreFailed)
          Center(
            child: TextButton(
              onPressed: _cubit.loadMore,
              child: Text(OrdersKeys.retry.tr()),
            ),
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? context.colors.brandBlue : context.colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? context.colors.brandBlue
                : context.colors.borderHairline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : context.colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: unread ? context.colors.blueTint : context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.borderHairline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: context.colors.brandBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SvgPicture.asset(
                  'assets/icons/truck.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                // Per-type copy, shared with the transient banner — an
                // unrecognised type renders its neutral fallback rather than
                // blank or dropped (FR-031).
                NotificationPresentation.message(notification.type),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            if (unread) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: context.colors.brandBlue,
                  shape: BoxShape.circle,
                ),
              ),
            ],
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
