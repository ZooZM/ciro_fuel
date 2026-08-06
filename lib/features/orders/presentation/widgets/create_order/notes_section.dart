import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../constants/create_order_strings.dart';

/// The optional driver-notes field. Untitled, unlike the numbered sections
/// above it.
class NotesSection extends StatelessWidget {
  const NotesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  CreateOrderStrings.notesLabel,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                TextField(
                  style: const TextStyle(color: AppColors.navy, fontSize: 13),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: CreateOrderStrings.notesHint,
                    hintStyle: TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SvgPicture.asset(
            AppAssets.lockIcon,
            width: AppSizes.iconMd,
            height: AppSizes.iconMd,
            colorFilter: const ColorFilter.mode(AppColors.navy, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
