import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../constants/order_mock_data.dart';

/// "تتبع الطلب" and the order reference, with a copy-to-clipboard glyph.
class TrackOrderTitle extends StatelessWidget {
  const TrackOrderTitle({this.orderCode = OrderMockData.orderCode, super.key});

  /// The bare reference; the "رقم الطلب :" prefix comes from the copy.
  final String orderCode;

  @override
  Widget build(BuildContext context) {
    final orderReference =
        this.orderReference ??
        TrackOrderKeys.orderReference.tr(namedArgs: {'id': 'ORD-2024-256'});

    return Column(
      children: [
        Text(
          TrackOrderKeys.title.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: AppFontSizes.display,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        GestureDetector(
          onTap: () => Clipboard.setData(ClipboardData(text: orderCode)),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppAssets.copyIcon,
                width: AppSizes.iconXs,
                height: AppSizes.iconXs,
                colorFilter: const ColorFilter.mode(
                  AppColors.navy,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  TrackOrderKeys.orderNumber.tr(
                    namedArgs: {'reference': orderCode},
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: AppFontSizes.caption,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
