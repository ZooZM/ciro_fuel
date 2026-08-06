import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// An icon paired with a label/value pair — the driver and truck rows in
/// the current-order card.
///
/// Wrapped in [Expanded] internally so a long value (e.g. a driver's full
/// name) shrinks instead of overflowing its half of the card.
class OrderInfoRow extends StatelessWidget {
  const OrderInfoRow({
    required this.asset,
    required this.label,
    required this.value,
    super.key,
  });

  final String asset;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          asset,
          width: AppSizes.icon16,
          height: AppSizes.icon16,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
