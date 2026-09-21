import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';

import '../../constants/order_presentation.dart';
import '../../../../../core/theme/theme_context.dart';

/// Which palette entry a step's bar and dot read from. An enum cannot hold a
/// resolved [Color] any more — the value now depends on the active theme — so
/// each status names its ink and [_StepStatus.colorOf] looks it up per build.
enum _StepInk { green, blue, orange, red }

/// One step of the order-progress bar, mirroring the five variants in
/// `assets/Order/status/`. Those SVGs bake a placeholder label into their
/// paths, so the bar and dot are redrawn here to their measurements — 110x8
/// track at radius 4, a 3x3 dot 8 above it — with real text for the label.
enum _StepStatus {
  /// Bar filled end to end.
  finished(_StepInk.green, filled: true),

  /// Bar filled to the halfway point.
  onProgress(_StepInk.blue),

  /// Half-filled like [onProgress], in the alert colour.
  warning(_StepInk.orange),

  /// Filled end to end, in the error colour.
  failed(_StepInk.red, filled: true),

  /// Track only; the dot still shows the journey ahead.
  notFinished(_StepInk.blue, fraction: 0);

  const _StepStatus(this.ink, {bool filled = false, double? fraction})
    : fraction = fraction ?? (filled ? 1 : 0.5);

  final _StepInk ink;

  Color colorOf(BuildContext context) => switch (ink) {
    _StepInk.green => context.colors.brandGreen,
    _StepInk.blue => context.colors.brandBlue,
    _StepInk.orange => context.colors.brandOrange,
    _StepInk.red => context.colors.brandRed,
  };

  /// How much of the track the fill covers, measured from the leading edge.
  final double fraction;
}

/// The four-stop confirm ← pay ← deliver ← hand over progress bar at the top
/// of the order-detail screen. Driven by [OrderCardKind] (spec 005 T039)
/// rather than the platform's finer-grained [OrderStatus] — the stepper
/// only needs the same coarse classification the status card itself uses.
class OrderStepper extends StatelessWidget {
  const OrderStepper({required this.cardKind, super.key});

  final OrderCardKind cardKind;

  // Keys, not copy: the list stays `const` and each caption is translated
  // where it is drawn, so the stepper follows a locale switch.
  static const _titleKeys = [
    OrderDetailKeys.stepConfirmOrder,
    OrderDetailKeys.stepPayment,
    OrderDetailKeys.stepDelivery,
    OrderDetailKeys.stepHandover,
  ];

  // The delivery step runs about four times the length of the other three,
  // which are all of a size — measured off the design.
  static const _flexes = [1, 1, 4, 1];

  /// Status of each of the four steps, right-to-left:
  /// تأكيد الطلب، الدفع، التوصيل، التسليم.
  List<_StepStatus> _stepStatuses() {
    const done = _StepStatus.finished;
    const todo = _StepStatus.notFinished;
    return switch (cardKind) {
      OrderCardKind.pendingApproval => const [
        _StepStatus.onProgress,
        todo,
        todo,
        todo,
      ],
      OrderCardKind.awaitingPayment => const [
        done,
        _StepStatus.warning,
        todo,
        todo,
      ],
      // Same step, same "waiting on you" treatment — what is owed differs
      // (an acceptance, not a settlement), where the order stands does not.
      OrderCardKind.awaitingAcceptance => const [
        done,
        _StepStatus.warning,
        todo,
        todo,
      ],
      OrderCardKind.confirmed => const [done, done, _StepStatus.onProgress, todo],
      OrderCardKind.inTransit => const [done, done, done, _StepStatus.onProgress],
      OrderCardKind.delivered => const [done, done, done, done],
      OrderCardKind.cancelled => const [_StepStatus.failed, todo, todo, todo],
    };
  }

  @override
  Widget build(BuildContext context) {
    final statuses = _stepStatuses();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < _titleKeys.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            flex: _flexes[i],
            child: _Step(title: _titleKeys[i].tr(), status: statuses[i]),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
        ),
        const SizedBox(height: 6),
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            color: status.colorOf(context),
            shape: BoxShape.circle,
          ),
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
              color: context.colors.borderHairline,
              // Fills from the leading (right) edge under RTL, as the
              // artwork does.
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: status.fraction,
                child: ColoredBox(color: status.colorOf(context)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
