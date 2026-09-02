import 'dart:async';

// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/translation_keys.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/number_formatting.dart';
import '../../../../core/widgets/app_action_icon.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../shared/entities/invoice.dart';
import '../../../../shared/enums/invoice_state.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';
import '../cubit/invoices_cubit.dart';
import '../cubit/invoices_state.dart';

class ClientInvoicesScreen extends StatefulWidget {
  const ClientInvoicesScreen({super.key});

  @override
  State<ClientInvoicesScreen> createState() => _ClientInvoicesScreenState();
}

class _ClientInvoicesScreenState extends State<ClientInvoicesScreen> {
  late final InvoicesCubit _cubit;
  late final ScrollController _scrollController;

  InvoiceState? _selectedTab;

  static const List<InvoiceState?> _tabOrder = [
    null,
    InvoiceState.issued,
    InvoiceState.settled,
    InvoiceState.voided,
  ];

  static String _tabLabel(InvoiceState? state) => switch (state) {
    null => InvoicesKeys.tabAll,
    InvoiceState.issued => InvoicesKeys.tabOutstanding,
    InvoiceState.settled => InvoicesKeys.tabPaid,
    InvoiceState.voided => InvoicesKeys.tabVoided,
  };

  @override
  void initState() {
    super.initState();
    _cubit = getIt<InvoicesCubit>();
    _cubit.load();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    unawaited(_cubit.close());
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 300;
    if (_scrollController.position.pixels >= threshold) {
      _cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoicesCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _cubit.refresh,
            child: BlocBuilder<InvoicesCubit, InvoicesState>(
              builder: _buildBody,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, InvoicesState state) {
    return switch (state) {
      InvoicesLoading() => const Center(child: CircularProgressIndicator()),
      InvoicesLoadFailure() => _ErrorState(onRetry: _cubit.load),
      InvoicesLoaded(:final invoices) => _buildList(context, invoices, state),
    };
  }

  Widget _buildList(
    BuildContext context,
    List<Invoice> invoices,
    InvoicesLoaded state,
  ) {
    return ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.topBarInsetV),
          child: AppTopBar(
            showProfile: true,
            notificationCount:
                context.watch<NotificationsCubit>().state.unreadBadgeCount,
          ),
        ),
        _buildTitleRow(invoices.length),
        const SizedBox(height: 16),
        _buildTabs(),
        const SizedBox(height: 16),
        if (invoices.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                InvoicesKeys.empty.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: context.colors.textTertiary,
                ),
              ),
            ),
          )
        else
          ...invoices.map(
            (invoice) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _InvoiceCard(invoice: invoice),
            ),
          ),
        if (state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (state.loadMoreFailed)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: TextButton(
                onPressed: _cubit.loadMore,
                child: Text(OrdersKeys.retry.tr()),
              ),
            ),
          ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildTitleRow(int count) {
    final colors = context.colors;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              InvoicesKeys.title.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              InvoicesKeys.count.tr(namedArgs: {'count': '$count'}),
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
          ],
        ),
        const Spacer(),
        // Pull-to-refresh (above) is the functional refresh gesture; this
        // icon is decorative, matching the orders list's own copy of it.
        const AppActionIcon.reload(),
      ],
    );
  }

  Widget _buildTabs() {
    final colors = context.colors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tabOrder.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTab == tab;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedTab = tab);
              _cubit.setStateFilter(tab);
            },
            child: Container(
              margin: EdgeInsetsDirectional.only(
                end: index < _tabOrder.length - 1 ? 8 : 0,
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
                _tabLabel(tab).tr(),
                style: TextStyle(
                  color: isSelected ? Colors.white : colors.textSecondary,
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
}

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({required this.invoice});

  final Invoice invoice;

  Color _statusColor(BuildContext context) => switch (invoice.state) {
    InvoiceState.issued => context.colors.brandOrange,
    InvoiceState.settled => context.colors.brandGreen,
    InvoiceState.voided => context.colors.brandRed,
  };

  String _statusLabel() => switch (invoice.state) {
    InvoiceState.issued => InvoicesKeys.tabOutstanding.tr(),
    InvoiceState.settled => InvoicesKeys.tabPaid.tr(),
    InvoiceState.voided => InvoicesKeys.tabVoided.tr(),
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currency = CommonKeys.currencySymbol.tr();
    final reference =
        '#${invoice.id.substring(invoice.id.length - 6).toUpperCase()}';

    return GestureDetector(
      onTap: () => context.push(AppRoutes.clientInvoiceDetail(invoice.id)),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 4, color: _statusColor(context)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reference,
                              style: TextStyle(
                                color: colors.textTertiary,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _statusLabel(),
                              style: TextStyle(
                                color: _statusColor(context),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              DateFormat.yMd(
                                context.locale.toString(),
                              ).format(invoice.createdAt.toLocal()),
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${NumberFormatting.currency(invoice.amount)} $currency',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _statusColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(OrdersKeys.retry.tr())),
        ],
      ),
    );
  }
}
