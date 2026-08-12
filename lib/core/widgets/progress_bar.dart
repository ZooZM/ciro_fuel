import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// The short status bar the list cards carry — how far an order or a payment
/// has got, drawn as a filled portion of a fixed-width track.
///
/// Fixed width rather than [Expanded]: it sits in a row beside a label long
/// enough to squeeze it to nothing ('تم التسليم (الفاتورة مؤجلة)'), and the
/// design keeps the bar the same length on every card.
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    required this.progress,
    required this.color,
    this.width = AppSizes.stationsProgressBarWidth,
    this.height = AppSizes.stationsProgressBarHeight,
    super.key,
  });

  /// 0–1. Values outside that range are clamped, so a bad figure from the
  /// backend cannot paint outside the track.
  final double progress;

  /// Fill colour — the status colour of whatever the bar belongs to.
  final Color color;

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.track,
        borderRadius: BorderRadius.circular(AppSizes.orderStepTrackRadius),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: progress.clamp(0, 1),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppSizes.orderStepTrackRadius),
          ),
        ),
      ),
    );
  }
}
