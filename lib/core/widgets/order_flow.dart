import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../localization/translation_keys.dart';
import '../theme/theme_context.dart';

/// A stop on the delivery journey, in order.
enum OrderFlowStep {
  accepted(OrderFlowKeys.accepted),
  loading(OrderFlowKeys.loading, asset: 'assets/HomePage/flow/drop.svg'),
  dispatched(OrderFlowKeys.dispatched, asset: 'assets/HomePage/flow/truck.svg'),
  onTheWay(OrderFlowKeys.onTheWay),
  delivered(OrderFlowKeys.delivered);

  const OrderFlowStep(this.labelKey, {this.asset});

  /// Translation key for the step's caption — `.tr()` at the point of use so
  /// the timeline re-reads on a locale switch.
  final String labelKey;

  /// Artwork that stands in for the whole bubble once the step is behind us —
  /// these two are drawn with their own filled circle.
  final String? asset;
}

/// The five-stop delivery timeline: accepted ← loading ← dispatched ←
/// on the way ← delivered.
///
/// Shared by the home screen's current-order card, the order detail screen and
/// the tracking screen, which all draw the same journey.
class OrderFlow extends StatelessWidget {
  const OrderFlow({super.key, this.current = OrderFlowStep.onTheWay});

  /// Where the order has got to. Everything before it reads as done, everything
  /// after as still ahead.
  final OrderFlowStep current;

  static const _bubble = 24.0;
  static const _truckIcon = 'assets/HomePage/truck.svg';

  @override
  Widget build(BuildContext context) {
    const steps = OrderFlowStep.values;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, step) in steps.indexed) ...[
          if (index > 0)
            // The rule takes its colour from the step it leads into, so the
            // green track stops exactly where progress does.
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: _bubble / 2),
                child: CustomPaint(
                  size: const Size(double.infinity, 1),
                  painter: _DashedRulePainter(
                    index < current.index ? context.colors.brandGreen : context.colors.borderHairline,
                  ),
                ),
              ),
            ),
          // The labels want more room than the connectors; the design lets a
          // long one run slightly under its neighbouring dashes.
          Expanded(flex: 5, child: _Step(step, current: current)),
        ],
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step(this.step, {required this.current});

  final OrderFlowStep step;
  final OrderFlowStep current;

  @override
  Widget build(BuildContext context) {
    final done = step.index < current.index;
    final isCurrent = step == current;
    final color = isCurrent
        ? context.colors.brandBlue
        : (done ? context.colors.brandGreen : context.colors.textSecondary);

    return Column(
      children: [
        _bubbleFor(context, done: done, isCurrent: isCurrent, color: color),
        const SizedBox(height: 8),
        Text(
          step.labelKey.tr(),
          textAlign: TextAlign.center,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: TextStyle(
            color: done || isCurrent ? color : context.colors.textSecondary,
            fontSize: 8,
            fontWeight: done || isCurrent ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _bubbleFor(
    BuildContext context, {
    required bool done,
    required bool isCurrent,
    required Color color,
  }) {
    // The flow artwork carries its own circle, but only in the completed
    // colourway — anything else is drawn.
    if (done && step.asset != null) {
      return SvgPicture.asset(
        step.asset!,
        width: OrderFlow._bubble,
        height: OrderFlow._bubble,
      );
    }

    // A step still ahead is a plain filled disc: no ring, no glyph.
    if (!done && !isCurrent) {
      return Container(
        width: OrderFlow._bubble,
        height: OrderFlow._bubble,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.borderHairline,
        ),
      );
    }

    return Container(
      width: OrderFlow._bubble,
      height: OrderFlow._bubble,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color),
        // Tinted to match the flow artwork's own bubbles, so the drawn steps
        // and the asset-backed ones read as one row.
        color: color.withValues(alpha: 0.1),
      ),
      child: Center(
        child: isCurrent
            ? SvgPicture.asset(
                OrderFlow._truckIcon,
                width: 14,
                height: 14,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              )
            : Icon(Icons.check, size: 14, color: color),
      ),
    );
  }
}

class _DashedRulePainter extends CustomPainter {
  const _DashedRulePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    const dash = 3.0;
    const gap = 3.0;
    for (var x = 0.0; x < size.width; x += dash + gap) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset((x + dash).clamp(0, size.width), size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRulePainter oldDelegate) =>
      oldDelegate.color != color;
}
