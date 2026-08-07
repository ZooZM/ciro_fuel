import 'package:flutter/material.dart';

import '../../constants/order_detail_strings.dart';
import 'mock_order_state.dart';

/// One step of the order-progress bar, mirroring the five variants in
/// `assets/Order/status/`. Those SVGs bake a placeholder label into their
/// paths, so the bar and dot are redrawn here to their measurements — 110x8
/// track at radius 4, a 3x3 dot 8 above it — with real text for the label.
enum _StepStatus {
  /// Bar filled end to end.
  finished(Color(0xFF12A150), filled: true),

  /// Bar filled to the halfway point.
  onProgress(Color(0xFF1E5FFF)),

  /// Half-filled like [onProgress], in the alert colour.
  warning(Color(0xFFFF5810)),

  /// Filled end to end, in the error colour. No screen in the current
  /// designs reaches it, but it completes the artwork's set.
  // ignore: unused_field
  failed(Color(0xFFEF3F3F), filled: true),

  /// Track only; the dot still shows the journey ahead.
  notFinished(Color(0xFF1E5FFF), fraction: 0);

  const _StepStatus(this.color, {bool filled = false, double? fraction})
    : fraction = fraction ?? (filled ? 1 : 0.5);

  final Color color;

  /// How much of the track the fill covers, measured from the leading edge.
  final double fraction;
}

/// The four-stop تأكيد الطلب ← الدفع ← التوصيل ← التسليم progress bar at
/// the top of the order-detail screen.
class OrderStepper extends StatelessWidget {
  const OrderStepper({required this.currentState, super.key});

  final MockOrderState currentState;

  static const _titles = [
    OrderDetailStrings.stepConfirmOrder,
    OrderDetailStrings.stepPayment,
    OrderDetailStrings.stepDelivery,
    OrderDetailStrings.stepHandover,
  ];

  // التوصيل runs about four times the length of the other three, which are
  // all of a size — measured off the design.
  static const _flexes = [1, 1, 4, 1];

  /// Status of each of the four steps, right-to-left:
  /// تأكيد الطلب، الدفع، التوصيل، التسليم.
  List<_StepStatus> _stepStatuses() {
    const done = _StepStatus.finished;
    const todo = _StepStatus.notFinished;
    switch (currentState) {
      case MockOrderState.pendingReview:
        return const [_StepStatus.onProgress, todo, todo, todo];
      case MockOrderState.confirmed:
        return const [done, _StepStatus.onProgress, todo, todo];
      case MockOrderState.waitingPayment:
      case MockOrderState.deferred:
        return const [done, _StepStatus.warning, todo, todo];
      case MockOrderState.failedPayment:
        return const [done, _StepStatus.failed, todo, todo];
      case MockOrderState.paid:
        return const [done, done, todo, todo];
      case MockOrderState.inTransit:
        return const [done, done, _StepStatus.onProgress, todo];
      case MockOrderState.delivered:
        return const [done, done, done, done];
      case MockOrderState.canceled:
        return const [_StepStatus.failed, todo, todo, todo];
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuses = _stepStatuses();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < _titles.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            flex: _flexes[i],
            child: _Step(title: _titles[i], status: statuses[i]),
          ),
        ],
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.title, required this.status});

  final String title;
  final _StepStatus status;

  static const _labelColor = Color(0xFF6B7280);
  static const _trackColor = Color(0xFFE7E9EF);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: const TextStyle(color: _labelColor, fontSize: 10),
        ),
        const SizedBox(height: 6),
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 8),
        // The Column hands out loose constraints, so without this the bar
        // would shrink-wrap its fill: the track would never show and the
        // fill would sit centred instead of against the leading edge.
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 8,
              color: _trackColor,
              // Fills from the leading (right) edge under RTL, as the
              // artwork does.
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: status.fraction,
                child: ColoredBox(color: status.color),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
