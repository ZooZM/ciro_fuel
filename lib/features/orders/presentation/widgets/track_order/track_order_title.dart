import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/translation_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';

/// "تتبع الطلب" and the order reference, with a copy-to-clipboard glyph.
class TrackOrderTitle extends StatelessWidget {
  const TrackOrderTitle({this.orderReference, super.key});

  final String? orderReference;

  @override
  Widget build(BuildContext context) {
    final orderReference =
        this.orderReference ??
        TrackOrderKeys.orderReference.tr(namedArgs: {'id': 'ORD-2024-256'});

    return Column(
      children: [
        Text(
          TrackOrderKeys.title.tr(),
          style: TextStyle(
            color: context.colors.textPrimary,
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
              colorFilter: ColorFilter.mode(
                context.colors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              orderReference,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}
