// `easy_localization` re-exports intl, whose own `TextDirection` would
// otherwise shadow the `dart:ui` one this screen sets RTL with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../../core/localization/translation_keys.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/delivery_time_card.dart';
import '../constants/order_mock_data.dart';
import '../widgets/order_detail/credit_limit_card.dart';
import '../widgets/order_detail/in_transit_order_status_card.dart';
import '../widgets/order_detail/mock_order_state.dart';
import '../widgets/order_detail/order_stepper.dart';
import '../widgets/order_detail/payable_order_status_card.dart';
import '../widgets/order_detail/pending_order_status_card.dart';
import '../widgets/order_detail/receipt_card.dart';
import '../widgets/order_detail/receipt_code_card.dart';
import '../widgets/order_detail/settled_order_status_card.dart';
import '../widgets/order_detail/support_fab.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/order_top_bar.dart';

export '../widgets/order_detail/mock_order_state.dart' show MockOrderState;

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({
    super.key,
    required this.orderId,
    this.mockState = MockOrderState.pendingReview,
  });

  final String orderId;
  final MockOrderState mockState;

  @override
  Widget build(BuildContext context) {
    // Return the view directly for static UI preview, removing Cubits and APIs
    return _OrderDetailView(orderId: orderId, mockState: mockState);
  }
}

class _OrderDetailView extends StatefulWidget {
  const _OrderDetailView({
    required this.orderId,
    this.mockState = MockOrderState.pendingReview,
  });

  final String orderId;
  final MockOrderState mockState;

  @override
  State<_OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<_OrderDetailView> {
  late MockOrderState _currentState;

  /// The receipt breakdown starts open, except once the order is delivered —
  /// by then the total is all the design keeps on screen.
  late bool _detailsExpanded;

  @override
  void initState() {
    super.initState();
    _currentState = widget.mockState;
    _detailsExpanded = _currentState != MockOrderState.delivered;
  }

  bool get _deferred => _currentState == MockOrderState.deferred;

  void _cycleMockState() {
    setState(() {
      const order = MockOrderState.values;
      _currentState = order[(_currentState.index + 1) % order.length];
      _detailsExpanded = _currentState != MockOrderState.delivered;
    });
  }

  void _deferPayment() {
    setState(() {
      _currentState = MockOrderState.deferred;
      _detailsExpanded = true;
    });
  }

  void _toggleDetails() => setState(() => _detailsExpanded = !_detailsExpanded);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.lg,
                  AppSpacing.gutter,
                  AppSpacing.orderScreenBottomPadding,
                ),
                children: [
                  OrderTopBar(
                    notificationCount: OrderMockData.notificationCount,
                    onBack: () => context.pop(),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  OrderStepper(currentState: _currentState),
                  const SizedBox(height: AppSpacing.xl),
                  ..._buildStateBody(),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.orderPrimaryActionHeight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _cycleMockState,
                      icon: const Icon(Icons.swap_horiz),
                      label: Text(OrderDetailKeys.changeMockState.tr()),
                    ),
                  ),
                ],
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

  List<Widget> _buildStateBody() {
    switch (_currentState) {
      case MockOrderState.paid:
      case MockOrderState.deferred:
      case MockOrderState.delivered:
        return [
          SettledOrderStatusCard(state: _currentState),
          const SizedBox(height: AppSpacing.lg),
          const DeliveryTimeCard(
            date: OrderMockData.deliveryDate,
            time: OrderMockData.deliveryHour,
            station: OrderMockData.deliveryStationAddress,
          ),
          const SizedBox(height: AppSpacing.lg),
          ReceiptCard(
            deferred: _deferred,
            detailsExpanded: _detailsExpanded,
            onToggleDetails: _toggleDetails,
          ),
        ];
      case MockOrderState.inTransit:
        return [
          const InTransitOrderStatusCard(),
          const SizedBox(height: AppSpacing.lg),
          const ReceiptCodeCard(),
          const SizedBox(height: AppSpacing.lg),
          const DeliveryTimeCard(
            date: OrderMockData.deliveryDate,
            time: OrderMockData.deliveryHour,
            station: OrderMockData.deliveryStationAddress,
          ),
        ];
      case MockOrderState.pendingReview:
      case MockOrderState.confirmed:
      case MockOrderState.waitingPayment:
      case MockOrderState.failedPayment:
        return [
          OrderSummaryCard(),
          const SizedBox(height: AppSpacing.lg),
          if (_currentState == MockOrderState.pendingReview)
            const PendingOrderStatusCard()
          else
            PayableOrderStatusCard(
              invoicePending:
                  _currentState == MockOrderState.waitingPayment ||
                  _currentState == MockOrderState.failedPayment,
              onDeferPayment: _deferPayment,
            ),
          const SizedBox(height: AppSpacing.lg),
          if (_currentState != MockOrderState.pendingReview) ...[
            const CreditLimitCard(),
            const SizedBox(height: AppSpacing.lg),
          ],
          const DeliveryTimeCard(
            date: OrderMockData.deliveryDate,
            time: OrderMockData.deliveryHour,
            station: OrderMockData.deliveryStationAddress,
          ),
        ];
      case MockOrderState.canceled:
        return const [];
    }
  }
}
