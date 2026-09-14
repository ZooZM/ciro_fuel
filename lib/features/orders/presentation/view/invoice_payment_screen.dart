import 'dart:async';

// `hide TextDirection`: easy_localization re-exports intl, whose
// `TextDirection` would otherwise shadow the Flutter one used below.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/number_formatting.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/error_presenter.dart';
import '../../../../shared/entities/value_objects.dart';
import '../constants/order_presentation.dart';
import '../cubit/order_detail_cubit.dart';
import '../cubit/order_detail_state.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/order_detail/receipt_breakdown.dart';
import 'order_detail_screen.dart';
import '../../../../core/theme/theme_context.dart';

class InvoicePaymentScreen extends StatefulWidget {
  const InvoicePaymentScreen({required this.orderId, super.key});

  final String orderId;

  @override
  State<InvoicePaymentScreen> createState() => _InvoicePaymentScreenState();
}

class _InvoicePaymentScreenState extends State<InvoicePaymentScreen> {
  late final OrderDetailCubit _orderDetailCubit;
  late final PaymentCubit _paymentCubit;
  bool _navigatedOnConfirm = false;

  @override
  void initState() {
    super.initState();
    _orderDetailCubit = getIt<OrderDetailCubit>(param1: widget.orderId)
      ..load();
    _paymentCubit = getIt<PaymentCubit>(param1: widget.orderId);
  }

  @override
  void dispose() {
    unawaited(_orderDetailCubit.close());
    unawaited(_paymentCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderDetailCubit>.value(value: _orderDetailCubit),
        BlocProvider<PaymentCubit>.value(value: _paymentCubit),
      ],
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: SafeArea(
          child: BlocListener<PaymentCubit, PaymentState>(
            listener: (context, state) {
              if (state is PaymentConfirmed && !_navigatedOnConfirm) {
                _navigatedOnConfirm = true;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => OrderDetailScreen(orderId: widget.orderId),
                  ),
                );
              } else if (state is PaymentFailureState) {
                presentFailure(context, state.failure);
              }
            },
            child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
              builder: (context, orderState) => switch (orderState) {
                OrderDetailLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                OrderDetailFailureState() => _ErrorState(
                  onRetry: () => _orderDetailCubit.load(),
                ),
                OrderDetailLoaded(:final order) => _Loaded(
                  reference: OrderPresentation.shortReference(order.id),
                  amount: order.finalPrice ?? order.estimatedPrice,
                  paymentDeadline: order.paymentDeadline,
                  priceBreakdown: order.priceBreakdown,
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Loaded extends StatefulWidget {
  const _Loaded({
    required this.reference,
    required this.amount,
    required this.paymentDeadline,
    required this.priceBreakdown,
  });

  final String reference;
  final Money? amount;
  final DateTime? paymentDeadline;
  final PriceBreakdown? priceBreakdown;

  @override
  State<_Loaded> createState() => _LoadedState();
}

class _LoadedState extends State<_Loaded> {
  bool _expanded = true;

  List<ReceiptInvoice> get _invoices {
    final breakdown = widget.priceBreakdown;
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
    final amount = widget.amount;
    final total = amount == null
        ? '0.00 $currency'
        : '${NumberFormatting.currency(amount.amountMinor / 100)} $currency';

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            const AppTopBar(),
            const SizedBox(height: 24),
            _buildSadadCard(context),
            const SizedBox(height: 12),
            Text(
              InvoicePaymentKeys.sadadNote.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 16),
            ReceiptBreakdown(
              invoices: _invoices,
              total: total,
              expanded: _expanded,
              onToggleExpanded: () => setState(() => _expanded = !_expanded),
            ),
          ],
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 24,
          child: BlocBuilder<PaymentCubit, PaymentState>(
            builder: (context, paymentState) =>
                _buildActionArea(context, paymentState, amount),
          ),
        ),
      ],
    );
  }

  Widget _buildActionArea(
    BuildContext context,
    PaymentState paymentState,
    Money? amount,
  ) {
    if (paymentState is PaymentAwaitingConfirmation) {
      // FR-024: the invoice stays outstanding until the platform's own
      // webhook confirms it — this screen only ever reports that state,
      // never asserts payment succeeded on the gateway's say-so alone.
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.blueTint,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colors.brandBlue,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                InvoicePaymentKeys.awaitingConfirmation.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.brandBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (paymentState is PaymentWindowExpired) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.orangeTint,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          InvoicePaymentKeys.windowExpired.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.colors.brandOrange,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    final submitting = paymentState is PaymentInitiating;
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.brandBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: submitting || amount == null
            ? null
            : () => context.read<PaymentCubit>().pay(amount),
        child: submitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                InvoicePaymentKeys.confirmAndComplete.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _buildSadadCard(BuildContext context) {
    final deadline = widget.paymentDeadline;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.brandOrange),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    InvoicePaymentKeys.invoiceData.tr(),
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.reference,
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              SvgPicture.asset('assets/Order/Sadaad.svg', height: 32),
            ],
          ),
          if (deadline != null) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  InvoicePaymentKeys.validUntil.tr(),
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${OrderPresentation.date(deadline)} ${OrderPresentation.time(deadline)}',
                  style: TextStyle(
                    color: context.colors.brandGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
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
