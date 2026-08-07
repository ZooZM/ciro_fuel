import 'package:flutter/material.dart';

const _kBlue = Color(0xFF1E5FFF);
const _kGreen = Color(0xFF12A150);
const _kGrey = Color(0xFF6B7280);
const _kTrack = Color(0xFFE7E9EF);

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
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: _dot / 2),
                child: Divider(height: 1, thickness: 1, color: _kTrack),
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
    final color = switch (step.state) {
      TrackerStepState.done => _kGreen,
      TrackerStepState.current => _kBlue,
      TrackerStepState.pending => _kGrey,
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
                border: Border.all(color: _kGreen, width: 1.5),
              ),
              child: const Icon(Icons.check, size: 18, color: _kGreen),
            ),
            // Solid blue disc with a white core.
            TrackerStepState.current => Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _kBlue,
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Nothing yet: a plain filled disc, no ring and no glyph.
            TrackerStepState.pending => const DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, color: _kTrack),
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
