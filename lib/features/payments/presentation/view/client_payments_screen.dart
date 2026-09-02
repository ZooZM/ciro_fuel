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
import '../../../../core/widgets/app_top_bar.dart';
import '../../domain/entities/payment.dart';
import '../cubit/payments_cubit.dart';
import '../cubit/payments_state.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';

class ClientPaymentsScreen extends StatefulWidget {
  const ClientPaymentsScreen({super.key});

  @override
  State<ClientPaymentsScreen> createState() => _ClientPaymentsScreenState();
}

class _ClientPaymentsScreenState extends State<ClientPaymentsScreen> {
  late final PaymentsCubit _cubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PaymentsCubit>();
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
    return BlocProvider<PaymentsCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _cubit.refresh,
            child: BlocBuilder<PaymentsCubit, PaymentsState>(
              builder: _buildBody,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PaymentsState state) {
    return switch (state) {
      PaymentsLoading() => const Center(child: CircularProgressIndicator()),
      PaymentsLoadFailure() => _ErrorState(onRetry: _cubit.load),
      PaymentsLoaded(:final payments) => _buildList(context, payments, state),
    };
  }

  Widget _buildList(
    BuildContext context,
    List<Payment> payments,
    PaymentsLoaded state,
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
          PaymentsKeys.count.tr(namedArgs: {'count': '${payments.length}'}),
          style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 16),
        if (payments.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                PaymentsKeys.empty.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: context.colors.textTertiary,
                ),
              ),
            ),
          )
        else
          ...payments.map((payment) => _PaymentCard(payment: payment)),
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
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currency = CommonKeys.currencySymbol.tr();
    final reference =
        '#${payment.orderId.substring(payment.orderId.length - 6).toUpperCase()}';

    return GestureDetector(
      onTap: () => context.push(AppRoutes.clientOrderDetail(payment.orderId)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reference,
                    style: TextStyle(color: colors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    payment.gateway,
                    style: TextStyle(
                      color: colors.brandBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${DateFormat.yMd(context.locale.toString()).format(payment.createdAt.toLocal())} '
                    '${DateFormat.jm(context.locale.toString()).format(payment.createdAt.toLocal())}',
                    style: TextStyle(color: colors.textTertiary, fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              '${NumberFormatting.currency(payment.amount)} $currency',
              style: TextStyle(
                color: colors.brandGreen,
                fontSize: 15,
                fontWeight: FontWeight.w800,
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
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(OrdersKeys.retry.tr())),
        ],
      ),
    );
  }
}
