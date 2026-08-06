import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../constants/track_order_strings.dart';

/// "تتبع الطلب" and the order reference, with a copy-to-clipboard glyph.
class TrackOrderTitle extends StatelessWidget {
  const TrackOrderTitle({this.orderReference = 'رقم الطلب : ORD-2024-256', super.key});

  final String orderReference;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          TrackOrderStrings.title,
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.copyIcon,
              width: AppSizes.iconXs,
              height: AppSizes.iconXs,
              colorFilter: const ColorFilter.mode(AppColors.navy, BlendMode.srcIn),
            ),
            const SizedBox(width: 6),
            Text(
              orderReference,
              style: const TextStyle(color: AppColors.grey, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}
