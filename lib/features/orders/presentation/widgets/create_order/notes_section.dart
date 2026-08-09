import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/order_card.dart';

/// The optional driver-notes field. Untitled, unlike the numbered sections
/// above it.
///
/// The field is a multi-line well rather than the single squeezed line the
/// first cut shipped with: delivery instructions ("البوابة الخلفية، اتصل قبل
/// الوصول بعشر دقائق") run past one line, and a customer could neither see
/// what they had typed nor tell the row was editable.
class NotesSection extends StatelessWidget {
  const NotesSection({this.controller, super.key});

  /// Supplied by the form so the note can be read back on submit; the
  /// field manages its own text when omitted.
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.lockIcon,
                width: AppSizes.iconMd,
                height: AppSizes.iconMd,
                colorFilter: const ColorFilter.mode(
                  AppColors.navy,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  CreateOrderKeys.notesLabel.tr(),
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: AppFontSizes.body,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            constraints: const BoxConstraints(
              minHeight: AppSizes.orderNotesFieldMinHeight,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.screenBackground,
              borderRadius: BorderRadius.circular(AppRadii.tile),
              border: Border.all(color: AppColors.itemBorder),
            ),
            child: TextField(
              controller: controller,
              minLines: AppSizes.orderNotesMinLines,
              maxLines: AppSizes.orderNotesMaxLines,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: AppFontSizes.body,
                height: 1.5,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: CreateOrderKeys.notesHint.tr(),
                hintStyle: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppFontSizes.footnote,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
