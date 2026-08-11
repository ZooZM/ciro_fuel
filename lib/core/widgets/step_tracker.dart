import 'package:flutter/material.dart';

import '../theme/theme_context.dart';

/// Where a stop sits relative to the journey's progress.
enum TrackerStepState { done, current, pending }

/// One stop on a [StepTracker].
class StepItem {
  const StepItem(this.label, this.state);

  final String label;
  final TrackerStepState state;
}

/// A short horizontal journey — a green tick for what is behind us, a solid
/// blue disc for where we are, and a plain grey disc for what is still ahead,
/// joined by hairline rules.
///
/// The first step renders right-most under a right-to-left [Directionality], so
/// list the stops in the order they happen.
class StepTracker extends StatelessWidget {
  const StepTracker({super.key, required this.steps});

  final List<StepItem> steps;

  static const double _dot = 32;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, step) in steps.indexed) ...[
          if (index > 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: _dot / 2),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: context.colors.borderHairline,
                ),
              ),
            ),
          _Step(step),
        ],
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step(this.step);

  final StepItem step;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = switch (step.state) {
      TrackerStepState.done => colors.brandGreen,
      TrackerStepState.current => colors.brandBlue,
      TrackerStepState.pending => colors.textSecondary,
    };

    return Column(
      children: [
        SizedBox(
          width: StepTracker._dot,
          height: StepTracker._dot,
          child: switch (step.state) {
            // Green ring with a tick.
            TrackerStepState.done => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colors.brandGreen, width: 1.5),
              ),
              child: Icon(Icons.check, size: 18, color: colors.brandGreen),
            ),
            // Solid blue disc with a contrasting core.
            TrackerStepState.current => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.brandBlue,
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface,
                  ),
                ),
              ),
            ),
            // Nothing yet: a plain filled disc, no ring and no glyph.
            TrackerStepState.pending => DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.borderHairline,
              ),
            ),
          },
        ),
        const SizedBox(height: 8),
        Text(
          step.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: step.state == TrackerStepState.pending
                ? FontWeight.w400
                : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
