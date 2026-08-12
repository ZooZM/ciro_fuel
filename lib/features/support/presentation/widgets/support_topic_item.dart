import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/support_topics.dart';

/// One row of the most-searched list. The '+' says the row expands, which it
/// will once the articles behind these topics exist.
class SupportTopicItem extends StatelessWidget {
  const SupportTopicItem({required this.topic, required this.onTap, super.key});

  final SupportTopic topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              topic.icon,
              width: AppSizes.supportTopicIconSize,
              height: AppSizes.supportTopicIconSize,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                topic.titleKey.tr(),
                style: const TextStyle(
                  fontSize: AppFontSizes.bodyLarge,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
            const Icon(
              Icons.add,
              color: AppColors.grey,
              size: AppSizes.iconLg,
            ),
          ],
        ),
      ),
    );
  }
}
