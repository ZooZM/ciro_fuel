import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/number_formatting.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/order_card.dart';
import '../../../../shared/entities/invoice.dart';
import '../../../../shared/enums/invoice_state.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';
import '../../../orders/presentation/widgets/order_detail/receipt_breakdown.dart';
import '../cubit/invoice_detail_cubit.dart';
import '../cubit/invoice_detail_state.dart';

/// An invoice's own itemised breakdown (spec 005 T078a) — reuses
/// `ReceiptBreakdown` from the order-detail receipt (T061) so the two can
/// never drift into showing different totals for the same figures.
class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({required this.invoiceId, super.key});

  final String invoiceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceDetailCubit>(
      create: (_) =>
          getIt<InvoiceDetailCubit>(param1: invoiceId)..load(),
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: SafeArea(
          child: BlocBuilder<InvoiceDetailCubit, InvoiceDetailState>(
            builder: (context, state) => switch (state) {
              InvoiceDetailLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              InvoiceDetailFailureState() => _ErrorState(
                onRetry: () => context.read<InvoiceDetailCubit>().load(),
              ),
              InvoiceDetailLoaded(:final invoice) => _Loaded(invoice: invoice),
            },
          ),
        ),
      ),
    );
  }
}

class _Loaded extends StatefulWidget {
  const _Loaded({required this.invoice});

  final Invoice invoice;

  @override
  State<_Loaded> createState() => _LoadedState();
}

class _LoadedState extends State<_Loaded> {
  bool _expanded = true;

  Invoice get invoice => widget.invoice;

  String get _reference => '#${invoice.id.substring(invoice.id.length - 6).toUpperCase()}';

  List<ReceiptInvoice> get _invoices {
    final breakdown = invoice.priceBreakdown;
    if (breakdown == null) return const [];
    final currency = CommonKeys.currencySymbol.tr();
    return [
      (
        lineItem: InvoicesKeys.fuelCharge.tr(),
        lineTotal:
            '${NumberFormatting.currency(breakdown.fuelLineTotal)} $currency',
        deliveryFee:
            breakdown.deliveryFee == null
                ? ''
                : '${NumberFormatting.currency(breakdown.deliveryFee!)} $currency',
        serviceFee:
            '${NumberFormatting.currency(breakdown.serviceFee)} $currency',
        deferred: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currency = CommonKeys.currencySymbol.tr();
    final total = '${NumberFormatting.currency(invoice.amount)} $currency';

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.lg,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      children: [
        AppTopBar(
          notificationCount:
              context.watch<NotificationsCubit>().state.unreadBadgeCount,
          onBack: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Text(
            InvoicesKeys.detailTitle.tr(),
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        OrderCard(
          child: Column(
            children: [
              _row(context, InvoicesKeys.reference.tr(), _reference),
              const SizedBox(height: AppSpacing.sm),
              _row(
                context,
                OrderDetailKeys.orderStatus.tr(),
                _stateLabel(invoice.state),
              ),
              if (invoice.settledAt case final settledAt?) ...[
                const SizedBox(height: AppSpacing.sm),
                _row(
                  context,
                  InvoicesKeys.settledOn.tr(),
                  '${DateFormat.yMd(context.locale.toString()).format(settledAt.toLocal())} '
                  '${DateFormat.jm(context.locale.toString()).format(settledAt.toLocal())}',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ReceiptBreakdown(
          invoices: _invoices,
          total: total,
          expanded: _expanded,
          onToggleExpanded: () => setState(() => _expanded = !_expanded),
        ),
      ],
    );
  }

  String _stateLabel(InvoiceState state) => switch (state) {
    InvoiceState.issued => InvoicesKeys.tabOutstanding.tr(),
    InvoiceState.settled => InvoicesKeys.tabPaid.tr(),
    InvoiceState.voided => InvoicesKeys.tabVoided.tr(),
  };

  Widget _row(BuildContext context, String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
      ),
      Text(
        value,
        style: TextStyle(
          color: context.colors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
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
