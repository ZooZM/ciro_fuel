import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/number_formatting.dart';
import '../../../../core/widgets/delivery_time_card.dart';
import '../../../../core/widgets/error_presenter.dart';
import '../../../../shared/entities/order.dart';
import '../../../../shared/enums/order_status.dart';
import '../../../../shared/enums/payment_method.dart';
import '../constants/order_formatting.dart';
import '../constants/order_presentation.dart';
import '../cubit/order_detail_cubit.dart';
import '../../../invoices/presentation/cubit/credit_cubit.dart';
import '../../../invoices/presentation/cubit/credit_state.dart';
import '../cubit/order_detail_state.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';
import '../../domain/entities/otp_challenge.dart';
import '../../domain/usecases/accept_final_price.dart';
import '../../domain/usecases/cancel_order.dart';
import '../../domain/usecases/redispatch.dart';
import '../widgets/order_detail/accept_total_order_status_card.dart';
import '../widgets/order_detail/credit_limit_card.dart';
import '../widgets/order_detail/in_transit_order_status_card.dart';
import '../widgets/order_detail/order_detail_top_bar.dart';
import '../widgets/order_detail/order_stepper.dart';
import '../widgets/order_detail/payable_order_status_card.dart';
import '../widgets/order_detail/pending_order_status_card.dart';
import '../widgets/order_detail/receipt_card.dart';
import '../widgets/order_detail/receipt_code_card.dart';
import '../widgets/order_detail/rating_card.dart';
import '../cubit/rating_cubit.dart';
import '../cubit/rating_state.dart';
import '../widgets/order_detail/settled_order_status_card.dart';
import '../widgets/order_detail/support_fab.dart';
import '../widgets/order_summary_card.dart';
import '../../../../core/theme/theme_context.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderDetailCubit>(
          // One instance per order (not a session singleton, unlike
          // OrdersCubit) — an order's own detail is scoped to the screen
          // showing it.
          create: (_) => getIt<OrderDetailCubit>(param1: orderId)
            ..load()
            ..loadCurrentOtp(),
        ),
        // The credit card on this screen reads the platform's own credit
        // calculation, the same endpoint the dashboard and the credit
        // screen use, so all three agree (FR-026).
        BlocProvider<CreditCubit>(create: (_) => getIt<CreditCubit>()..load()),
        BlocProvider<RatingCubit>(create: (_) => getIt<RatingCubit>(param1: orderId)),
      ],
      child: _OrderDetailView(orderId: orderId),
    );
  }
}

class _OrderDetailView extends StatefulWidget {
  const _OrderDetailView({required this.orderId});

  final String orderId;

  @override
  State<_OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<_OrderDetailView> {
  /// `null` until the client manually toggles it — the breakdown starts
  /// open, except once delivered, when the total alone is kept on screen.
  /// A nullable override (rather than mutating a plain bool from `build`)
  /// keeps that status-derived default reactive to a live status change —
  /// e.g. an order transitioning to DELIVERED while this screen is open —
  /// without fighting Flutter's build semantics by writing to state
  /// mid-build.
  bool? _detailsExpandedOverride;

  bool _resolvedDetailsExpanded(Order order) =>
      _detailsExpandedOverride ?? (order.status != OrderStatus.delivered);

  void _toggleDetails(Order order) => setState(
    () => _detailsExpandedOverride = !_resolvedDetailsExpanded(order),
  );

  bool _actionInFlight = false;

  /// Redraws the handover code's mm:ss countdown once a second. Without it
  /// the figure freezes at whatever it was when the screen last rebuilt, so
  /// an expired code would still read as having minutes left.
  Timer? _countdownTicker;

  @override
  void initState() {
    super.initState();
    _countdownTicker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _countdownTicker?.cancel();
    super.dispose();
  }

  /// Counts down to the code's expiry; clamps at zero rather than going
  /// negative once it lapses.
  String _formatCountdown(DateTime expiresAt) {
    final remaining = expiresAt.difference(DateTime.now());
    if (remaining.isNegative) return '00:00';
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// FR-007: only ever called from a card the platform has already agreed
  /// to show this action on — [_buildCardsFor] is what decides eligibility,
  /// this just performs it and reflects the platform's answer, never
  /// assumes success locally.
  Future<void> _cancel(BuildContext context, Order order) async {
    if (_actionInFlight) return;
    setState(() => _actionInFlight = true);
    final result = await getIt<CancelOrder>()(order.id);
    if (!mounted) return;
    setState(() => _actionInFlight = false);
    result.fold(
      (failure) => presentFailure(context, failure),
      (_) => context.read<OrderDetailCubit>().load(),
    );
  }

  /// The station owner's half of the routing gate: routing priced the haul
  /// and parked the order at PENDING_PAYMENT, and a DEFERRED/CREDIT order
  /// has no gateway payment to make, so acceptance is what releases it back
  /// to the transporter. `AcceptFinalPrice` has existed since spec 005 and
  /// was registered in DI with no caller — reachable only now.
  Future<void> _acceptFinalPrice(BuildContext context, Order order) async {
    if (_actionInFlight) return;
    setState(() => _actionInFlight = true);
    final result = await getIt<AcceptFinalPrice>()(order.id);
    if (!mounted) return;
    setState(() => _actionInFlight = false);
    result.fold(
      (failure) => presentFailure(context, failure),
      (_) => context.read<OrderDetailCubit>().load(),
    );
  }

  Future<void> _redispatch(BuildContext context, Order order) async {
    if (_actionInFlight) return;
    setState(() => _actionInFlight = true);
    final result = await getIt<Redispatch>()(order.id);
    if (!mounted) return;
    setState(() => _actionInFlight = false);
    result.fold(
      (failure) => presentFailure(context, failure),
      (_) => context.read<OrderDetailCubit>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RatingCubit, RatingState>(
      // A submitted rating only reaches the delivered card via the order's
      // own `rating` field (FR-037d) — reload rather than trust the local
      // submit response, keeping OrderDetailCubit the single source of
      // truth for what's rendered.
      listener: (context, state) {
        if (state is RatingSubmitted) {
          context.read<OrderDetailCubit>().load();
        }
      },
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        body: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<OrderDetailCubit, OrderDetailState>(
                builder: (context, state) => switch (state) {
                  OrderDetailLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  OrderDetailFailureState() => _ErrorState(
                    onRetry: () => context.read<OrderDetailCubit>().load(),
                  ),
                  OrderDetailLoaded(:final order, :final activeOtp) =>
                    _buildLoaded(context, order, activeOtp),
                },
              ),
              const Positioned(
                bottom: AppSpacing.xl,
                right: AppSpacing.gutter,
                child: SupportFab(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, Order order, OtpChallenge? activeOtp) {
    final cardKind = cardKindFor(order.status, order.paymentMethod ?? PaymentMethod.direct);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.lg,
        AppSpacing.gutter,
        AppSpacing.orderScreenBottomPadding,
      ),
      children: [
        OrderDetailTopBar(
          notificationCount:
              context.watch<NotificationsCubit>().state.unreadBadgeCount,
          onBack: () => context.pop(),
        ),
        const SizedBox(height: AppSpacing.xxl),
        OrderStepper(cardKind: cardKind),
        const SizedBox(height: AppSpacing.xl),
        ..._buildCardsFor(context, cardKind, order, activeOtp),
      ],
    );
  }

  List<Widget> _buildCardsFor(
    BuildContext context,
    OrderCardKind cardKind,
    Order order,
    OtpChallenge? activeOtp,
  ) {
    final reference = OrderPresentation.shortReference(order.id);
    final date = OrderPresentation.date(order.statusChangedAt);
    final time = OrderPresentation.time(order.statusChangedAt);
    final method = order.paymentMethod ?? PaymentMethod.direct;

    switch (cardKind) {
      case OrderCardKind.confirmed:
      case OrderCardKind.delivered:
        final money = order.finalPrice ?? order.estimatedPrice;
        // The one status a DIRECT order genuinely rests at APPROVED —
        // post-payment-timeout, reopened via POST /orders/:id/redispatch
        // (FR-015a). Every other route to APPROVED continues past it
        // before a client ever observes it.
        final canRedispatch =
            order.status == OrderStatus.approved && method == PaymentMethod.direct;
        return [
          SettledOrderStatusCard(
            status: order.status,
            paymentMethod: method,
            orderReference: '$reference · $date',
            onRedispatch: canRedispatch && !_actionInFlight
                ? () => _redispatch(context, order)
                : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          DeliveryTimeCard(
            date: date,
            time: time,
            station: OrderPresentation.destinationLabel(order),
          ),
          const SizedBox(height: AppSpacing.lg),
          ReceiptCard(
            deferred: method == PaymentMethod.deferred,
            detailsExpanded: _resolvedDetailsExpanded(order),
            onToggleDetails: () => _toggleDetails(order),
            referenceNumber: reference,
            day: date,
            hour: time,
            priceBreakdown: order.priceBreakdown,
            lineItemLabel: OrderFormatting.lineItem(
              OrderPresentation.fuelLabel(order.fuelType),
              order.quantityLiters,
            ),
            total: money != null
                ? '${NumberFormatting.currency(money.amountMinor / 100)} '
                : '0.00 ',
          ),
          // FR-037/FR-037d: only once genuinely DELIVERED, not merely
          // "confirmed" — the two share this card's other content but not
          // the rating slot.
          if (cardKind == OrderCardKind.delivered) ...[
            const SizedBox(height: AppSpacing.lg),
            order.rating != null
                ? RatingSummaryCard(rating: order.rating!)
                : const RatingCard(),
          ],
        ];
      case OrderCardKind.inTransit:
        return [
          InTransitOrderStatusCard(
            orderId: order.id,
            orderReference: '$reference · $date',
            fuelType: OrderPresentation.fuelLabel(order.fuelType),
            quantity: OrderFormatting.litres(order.quantityLiters),
            driverName: order.driverSummary?.fullName ?? '—',
            truckPlate: order.driverSummary?.plateNumber ?? '—',
            // FR-047d: false for an overridden departure — an override
            // deliberately records no verification, so this must never
            // read as proof the platform doesn't have (SC-020).
            vehicleVerified: order.vehicleVerified,
            etaMinutes: order.etaMinutes ?? 0,
          ),
          // Only once the platform has actually issued a code. There is
          // no handover code before the driver reports arriving, and showing
          // one then would be showing a code that does not exist.
          if (activeOtp != null) ...[
            const SizedBox(height: AppSpacing.lg),
            ReceiptCodeCard(
              code: activeOtp.code,
              timeRemaining: _formatCountdown(activeOtp.expiresAt),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          DeliveryTimeCard(
            date: date,
            time: time,
            station: OrderPresentation.destinationLabel(order),
          ),
        ];
      case OrderCardKind.pendingApproval:
      case OrderCardKind.awaitingPayment:
      case OrderCardKind.awaitingAcceptance:
        // `finalPrice` FIRST: once the fuel company approves, the figure the
        // station owner is asked to accept is the final one, and it differs
        // from the estimate by the transport leg (priced only at routing).
        // Reading `estimatedPrice` alone left an approved order showing the
        // pre-approval number it is no longer worth.
        final money = order.finalPrice ?? order.estimatedPrice;
        final breakdown = order.priceBreakdown;
        final currency = CommonKeys.riyal.tr();
        return [
          OrderSummaryCard(
            fuelType: OrderPresentation.fuelLabel(order.fuelType),
            quantity: OrderFormatting.litres(order.quantityLiters),
            // The order carries its own itemisation. Passing only the total
            // left four money slots unset, and the card filled them with its
            // design-mock figures.
            pricePerLiter: breakdown != null
                ? '${NumberFormatting.currency(breakdown.unitPrice)} $currency'
                : null,
            totalWithTax: breakdown != null
                ? '${NumberFormatting.currency(breakdown.fuelLineTotal)} $currency'
                : null,
            // One "fees" slot in the design: delivery plus service fee, and
            // empty while no transporter has been chosen to price the haul.
            transportFees: breakdown == null
                ? null
                : breakdown.deliveryFee == null
                    ? ''
                    : '${NumberFormatting.currency(breakdown.deliveryFee! + breakdown.serviceFee)} $currency',
            vat: breakdown != null
                ? '${NumberFormatting.currency(breakdown.tax)} $currency'
                : null,
            finalTotal: money != null
                ? OrderFormatting.money(money.amountMinor / 100)
                : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (cardKind == OrderCardKind.pendingApproval)
            PendingOrderStatusCard(
              orderReference: '$reference · $date',
              // FR-007: PENDING_APPROVAL is in the backend's
              // CLIENT_CANCELLABLE set (orders.controller.ts).
              onCancel: _actionInFlight ? null : () => _cancel(context, order),
            )
          else if (cardKind == OrderCardKind.awaitingAcceptance)
            AcceptTotalOrderStatusCard(
              orderReference: '$reference · $date',
              onAccept: _actionInFlight
                  ? null
                  : () => _acceptFinalPrice(context, order),
              // FR-007: PENDING_PAYMENT is CLIENT_CANCELLABLE, and refusing
              // the total IS the cancellation (orders.service.ts).
              onCancel: _actionInFlight ? null : () => _cancel(context, order),
            )
          else
            PayableOrderStatusCard(
              orderId: order.id,
              invoicePending: true,
              orderReference: '$reference · $date',
              onDeferPayment: () {},
              // FR-007: PENDING_PAYMENT is likewise CLIENT_CANCELLABLE.
              onCancel: _actionInFlight ? null : () => _cancel(context, order),
            ),
          const SizedBox(height: AppSpacing.lg),
          if (cardKind != OrderCardKind.pendingApproval)
            BlocBuilder<CreditCubit, CreditState>(
              builder: (context, creditState) {
                // Withheld until the real figures arrive, and withheld
                // entirely for a client with no facility — a credit card
                // showing invented numbers is worse than no card.
                if (creditState is! CreditLoaded ||
                    creditState.standing.creditLimit == null) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    CreditLimitCard(standing: creditState.standing),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                );
              },
            ),
          DeliveryTimeCard(
            date: date,
            time: time,
            station: OrderPresentation.destinationLabel(order),
          ),
        ];
      case OrderCardKind.cancelled:
        return const [];
    }
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
