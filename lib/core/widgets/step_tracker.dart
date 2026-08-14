import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.indexed.map((e) => Expanded(
        child: _Step(
          step: e.$2,
          index: e.$1,
          totalSteps: steps.length,
        ),
      )).toList(),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.step, required this.index, required this.totalSteps});

  final StepItem step;
  final int index;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = switch (step.state) {
      TrackerStepState.done => colors.brandGreen,
      TrackerStepState.current => colors.brandBlue,
      TrackerStepState.pending => colors.textSecondary,
    };

    final dot = switch (step.state) {
      TrackerStepState.done => Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.canvas,
            border: Border.all(color: colors.brandGreen, width: 1.5),
          ),
          child: Icon(Icons.check, color: colors.brandGreen, size: 16),
        ),
      TrackerStepState.current => Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.brandBlue,
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.canvas,
              ),
            ),
          ),
        ),
      TrackerStepState.pending => Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.canvas,
            border: Border.all(color: colors.borderHairline, width: 1.5),
          ),
        ),
    };

    return Column(
      children: [
        SizedBox(
          height: 24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: index == 0
                        ? const SizedBox()
                        : Container(height: 1, color: colors.borderHairline),
                  ),
                  Expanded(
                    child: index == totalSteps - 1
                        ? const SizedBox()
                        : Container(height: 1, color: colors.borderHairline),
                  ),
                ],
              ),
              dot,
            ],
          ),
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
